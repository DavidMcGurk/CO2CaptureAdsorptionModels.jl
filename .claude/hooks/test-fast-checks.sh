#!/bin/bash
# Scenario tests for fast-checks.sh, with a stand-in for julia. They run in temporary
# directories and take about a minute. Run them after any change to the hook:
#
#   bash .claude/hooks/test-fast-checks.sh [hook script] [shell that runs the hook]

HOOK_SRC="${1:-$(cd "$(dirname "$0")" && pwd)/fast-checks.sh}"
SH=$(command -v "${2:-bash}")
WORK=$(mktemp -d /tmp/hooktest.XXXXXX)
FAKE="$WORK/fake-julia"
CTL="$WORK/ctl"
mkdir -p "$CTL"
pass=0
fail=0

cat >"$FAKE" <<'EOF'
#!/bin/bash
echo x >>"$FAKE_CTL/calls"
case "$(cat "$FAKE_CTL/mode")" in
  pass) echo "Testing Pkg tests passed"; exit 0 ;;
  fail) cat "$FAKE_CTL/output"; exit 1 ;;
  hang)
    sleep "${FAKE_HANG:-300}" &
    echo $! >"$FAKE_CTL/child-pid"
    echo $$ >"$FAKE_CTL/parent-pid"
    echo "Precompiling..."
    wait
    ;;
esac
EOF
chmod +x "$FAKE"

new_project() {
  P="$WORK/proj-$1"
  rm -rf "$P"
  mkdir -p "$P/.claude/hooks" "$P/test/reference" "$P/docs/papers" "$P/results/run_old"
  cp "$HOOK_SRC" "$P/.claude/hooks/fast-checks.sh"
  printf 'value = 1.0\n' >"$P/test/reference/hag13.toml"
  printf 'pdf-bytes' >"$P/docs/papers/Estupiñan Perez et al. - 2019 – paper.pdf"
  printf 'out' >"$P/results/run_old/output.csv"
  : >"$CTL/calls"
  echo pass >"$CTL/mode"
  sleep 1.1
}

skeleton() {
  mkdir -p "$P/src" "$P/test"
  echo 'name = "X"' >"$P/Project.toml"
  echo 'using Test' >"$P/test/runtests.jl"
  echo 'f(x) = x' >"$P/src/X.jl"
}

hook() {
  ( cd / && env -i PATH="/usr/bin:/bin" HOME="$WORK/home" CLAUDE_PROJECT_DIR="$P" FAKE_CTL="$CTL" FAKE_HANG="${FAKE_HANG:-300}" \
      FAST_CHECKS_JULIA="${JULIA-$FAKE}" ${EXTRA_ENV:-} \
      "$SH" "$P/.claude/hooks/fast-checks.sh" "$1" </dev/null >"$WORK/out" 2>"$WORK/err" )
  rc=$?
}

calls() { wc -l <"$CTL/calls" | tr -d ' '; }

check() {
  local name="$1"
  shift
  if "$@"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL: $name"
    echo "   rc=$rc stdout=[$(head -c 300 "$WORK/out")]"
    echo "   stderr=[$(head -c 600 "$WORK/err")]"
  fi
}

rc_is() { [ "$rc" = "$1" ]; }
silent() { [ ! -s "$WORK/out" ] && [ ! -s "$WORK/err" ]; }
err_has() { grep -qF -- "$1" "$WORK/err"; }
err_lacks() { ! grep -qF -- "$1" "$WORK/err"; }
out_nonempty() { [ -s "$WORK/out" ]; }
out_not_json() { ! head -c 1 "$WORK/out" | grep -q '[{[]'; }
err_one_line() { [ "$(wc -l <"$WORK/err" | tr -d ' ')" = 1 ]; }
calls_are() { [ "$(calls)" = "$1" ]; }
valid_utf8() { iconv -f UTF-8 -t UTF-8 "$1" >/dev/null 2>&1; }
gone() {
  local state
  state=$(ps -o stat= -p "$(cat "$1")" 2>/dev/null)
  case "$state" in '' | Z*) return 0 ;; *) return 1 ;; esac
}

# A: no package skeleton
new_project A
hook mark; check "A mark silent, rc 0" rc_is 0; check "A mark prints nothing" silent
hook gate; check "A gate rc 0" rc_is 0; check "A gate silent" silent; check "A no julia call" calls_are 0

# B: skeleton, nothing changed
new_project B; skeleton
hook mark; hook gate
check "B rc 0" rc_is 0; check "B silent" silent; check "B no julia call" calls_are 0

# C: code changed, tests pass, pass is cached
new_project C; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"
hook gate; check "C rc 0" rc_is 0; check "C silent" silent; check "C one call" calls_are 1
hook gate; check "C cached rc 0" rc_is 0; check "C still one call" calls_are 1

# D-F: failing tests, retries, giving up
new_project D; skeleton
hook mark; echo 'f(x) = 3x' >"$P/src/X.jl"
echo fail >"$CTL/mode"; printf 'Test Failed at test/runtests.jl:3\n  Expression: f(1) ≈ 1\n   Evaluated: 3 ≈ 1\n' >"$CTL/output"
hook gate
check "D rc 2" rc_is 2
check "D retry 1 message" err_has "Fast tests failed (forced retry 1 of 3)"
check "D tail present, UTF-8 kept" err_has "Evaluated: 3 ≈ 1"
check "D log path named" err_has ".claude/.cache/fast-checks.log"
check "D stdout not empty" out_nonempty
check "D stdout is not JSON" out_not_json
check "D full log written" test -s "$P/.claude/.cache/fast-checks.log"
hook gate
check "E rc 1 when stopped without change" rc_is 1
check "E warning text" err_has "stopped without changing the code again"
check "E warning is one line" err_one_line
check "E no extra julia call" calls_are 1
echo 'f(x) = 4x' >"$P/src/X.jl"; hook gate; check "F retry 2 rc 2" rc_is 2; check "F retry 2 text" err_has "forced retry 2 of 3"
echo 'f(x) = 5x' >"$P/src/X.jl"; hook gate; check "F retry 3 rc 2" rc_is 2; check "F retry 3 text" err_has "forced retry 3 of 3"
echo 'f(x) = 6x' >"$P/src/X.jl"; hook gate; check "F give up rc 1" rc_is 1; check "F give up text" err_has "still FAILING after 3 forced retries"; check "F one line" err_one_line
hook mark; echo 'f(x) = 7x' >"$P/src/X.jl"; hook gate; check "F counter resets next turn" err_has "forced retry 1 of 3"

# G: julia missing
new_project G; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"
JULIA="" hook gate
check "G rc 1" rc_is 1; check "G text" err_has "julia not found"; check "G one line" err_one_line

# H: failure text that mentions a missing file
new_project H; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"
echo fail >"$CTL/mode"; printf 'SystemError: opening file "data/x.toml": No such file or directory\n' >"$CTL/output"
hook gate
check "H rc 2" rc_is 2
check "H stderr has the phrase" err_has "No such file or directory"
check "H stdout NOT empty (keeps the block)" out_nonempty

# I: protected folders changed through the shell
new_project I1
hook mark
echo 'value = 2.0' >"$P/test/reference/hag13.toml"
hook gate
check "I1 rc 2 without skeleton" rc_is 2
check "I1 names the file" err_has "modified: test/reference/hag13.toml"
check "I1 stdout not empty" out_nonempty
hook gate
check "I1 second stop rc 1" rc_is 1
check "I1 warning one line" err_one_line
check "I1 warning names file" err_has "still changed: modified: test/reference/hag13.toml"
printf 'value = 1.0\n' >"$P/test/reference/hag13.toml"
hook gate
check "I1 restored rc 0" rc_is 0; check "I1 restored silent" silent

new_project I2
hook mark
echo 'value = 9' >"$P/test/reference/new.toml"
hook gate; check "I2 added rc 2" rc_is 2; check "I2 added text" err_has "added:    test/reference/new.toml"
rm "$P/test/reference/new.toml" "$P/test/reference/hag13.toml"
hook gate; check "I2 deleted rc 2 (new state)" rc_is 2; check "I2 deleted text" err_has "deleted:  test/reference/hag13.toml"; check "I2 removed added file no longer listed" err_lacks "new.toml"

new_project I3
hook mark
echo 'more' >"$P/docs/papers/New paper.pdf"
mkdir -p "$P/results/run_new"; echo 1 >"$P/results/run_new/output.csv"
hook gate; check "I3 new paper and new run are fine" rc_is 0; check "I3 silent" silent
echo 'tampered' >>"$P/results/run_old/output.csv"
hook gate; check "I3 modified old result rc 2" rc_is 2; check "I3 text" err_has "modified: results/run_old/output.csv"
rm "$P/docs/papers/Estupiñan Perez et al. - 2019 – paper.pdf"
hook gate; check "I3 deleted paper rc 2" rc_is 2; check "I3 names paper with spaces and non-ASCII" err_has "deleted:  docs/papers/Estupiñan Perez et al. - 2019 – paper.pdf"
hook mark; hook gate; check "I3 next turn starts clean" rc_is 0

new_project I4; skeleton
hook mark
echo 'value = 2.0' >"$P/test/reference/hag13.toml"
echo fail >"$CTL/mode"; echo 'Test Failed' >"$CTL/output"
hook gate; check "I4 first block is the protected-file report" err_has "Files in folders you must not change"; check "I4 tests not run yet" calls_are 0
hook gate; check "I4 second block is the test failure" err_has "Fast tests failed (forced retry 1 of 3)"; check "I4 rc 2" rc_is 2
echo pass >"$CTL/mode"; echo 'f(x) = 8x' >"$P/src/X.jl"
hook gate; check "I4 tests pass but change remains: rc 1" rc_is 1; check "I4 warning" err_has "protected files changed during this turn and are still changed"; check "I4 one line" err_one_line

# J: tests run past the deadline
new_project J; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"
echo hang >"$CTL/mode"
start=$(date +%s)
EXTRA_ENV="FAST_CHECKS_TIMEOUT=3" hook gate
elapsed=$(($(date +%s) - start))
check "J rc 2" rc_is 2
check "J text" err_has "did not finish within 3 s"
check "J log tail included" err_has "Precompiling..."
check "J stopped within 10 s (took ${elapsed}s)" test "$elapsed" -le 10
check "J stderr has no shell job noise" err_lacks "Terminated"
check "J stdout not empty" out_nonempty
sleep 0.5
check "J julia process gone" gone "$CTL/parent-pid"
check "J its child process gone" gone "$CTL/child-pid"
check "J timeout not recorded as a failure" test ! -s "$P/.claude/.cache/last-fail"
EXTRA_ENV="FAST_CHECKS_TIMEOUT=3" hook gate
check "J second timeout rc 1" rc_is 1; check "J second text" err_has "twice in this turn"; check "J one line" err_one_line
echo pass >"$CTL/mode"
EXTRA_ENV="FAST_CHECKS_TIMEOUT=abc" hook gate
check "J invalid timeout value falls back, tests pass" rc_is 0

# L: long, messy output
new_project L; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"
echo fail >"$CTL/mode"
{
  for i in $(seq 1 5000); do printf 'line %d ✓ precompiled \033[32mgreen\033[0m "quoted" back\\slash\ttab\r\n' "$i"; done
  printf 'nul:\000:byte\n'
  printf 'LAST LINE Evaluated: 0.8874 ≈ 0.8875\n'
} >"$CTL/output"
hook gate
size=$(wc -c <"$WORK/err" | tr -d ' ')
check "L rc 2" rc_is 2
check "L stderr capped (is ${size} bytes)" test "$size" -le 7000
check "L ends with the last line" bash -c "tail -n 1 '$WORK/err' | grep -qF 'LAST LINE Evaluated: 0.8874 ≈ 0.8875'"
check "L control characters removed" bash -c "! LC_ALL=C grep -q \$'[\\x01-\\x08\\x0b-\\x1f\\x7f]' '$WORK/err'"
check "L valid UTF-8" valid_utf8 "$WORK/err"
check "L full log kept (5002 lines)" test "$(wc -l <"$P/.claude/.cache/fast-checks.log" | tr -d ' ')" = 5002

# M: switch
new_project M; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"; echo fail >"$CTL/mode"; echo 'x' >"$CTL/output"
EXTRA_ENV="SKIP_FAST_CHECKS=1" hook gate
check "M skip rc 0" rc_is 0; check "M skip no call" calls_are 0

# O: hook interrupted while tests run
new_project O; skeleton
hook mark; echo 'f(x) = 2x' >"$P/src/X.jl"; echo hang >"$CTL/mode"; rm -f "$CTL/parent-pid" "$CTL/child-pid"
( cd / && env -i PATH="/usr/bin:/bin" HOME="$WORK/home" CLAUDE_PROJECT_DIR="$P" FAKE_CTL="$CTL" FAKE_HANG="${FAKE_HANG:-300}" FAST_CHECKS_JULIA="$FAKE" \
    "$SH" "$P/.claude/hooks/fast-checks.sh" gate </dev/null >/dev/null 2>&1 ) &
hookjob=$!
sleep 2.5
pkill -TERM -f "$P/.claude/hooks/fast-checks.sh gate"
wait "$hookjob" 2>/dev/null
sleep 1.5
rc=-; : >"$WORK/out"; : >"$WORK/err"
check "O julia stopped when the hook is interrupted" gone "$CTL/parent-pid"
check "O child stopped too" gone "$CTL/child-pid"

echo "shell: $("$SH" --version | head -1)"
echo "passed: $pass  failed: $fail"
rm -rf "$WORK"
[ "$fail" = 0 ]
