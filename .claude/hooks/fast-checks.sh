#!/bin/bash
# Fast-check gate for Claude Code, registered in .claude/settings.json.
# Written for the bash 3.2 and BSD tools that macOS ships.
#
#   mark   UserPromptSubmit: record the state of the code and of the protected
#          folders at the start of the turn.
#   gate   Stop: (1) report files in test/reference/, docs/papers/ or results/ that
#          changed during the turn; (2) if src/, test/, ext/, experiments/,
#          Project.toml or Manifest.toml changed, run the fast test tier before
#          Claude may finish.
#
# Exit codes from `gate`:
#   0  nothing to report, or the tests pass
#   2  Claude must keep working: the tests fail or ran out of time, or protected
#      files changed. The reason goes to Claude on stderr.
#   1  the turn ends and you see a one-line warning: tests still failing after
#      MAX_BLOCKS forced retries or with no further change, tests out of time twice,
#      julia not found, or protected files left changed
#
# Environment: SKIP_FAST_CHECKS=1 switches the gate off. FAST_CHECKS_JULIA overrides
# the julia binary. FAST_CHECKS_TIMEOUT is the time allowed for the tests in seconds;
# keep it below the Stop hook timeout in settings.json, because Claude Code cancels a
# hook that reaches that timeout and discards its result.
#
# Scenario tests: bash .claude/hooks/test-fast-checks.sh

MAX_BLOCKS=3
TAIL_LINES=80
TAIL_BYTES=6000
TIMEOUT="${FAST_CHECKS_TIMEOUT:-480}"
case "$TIMEOUT" in '' | *[!0-9]*) TIMEOUT=480 ;; esac

[ -t 0 ] || cat >/dev/null
[ -n "${SKIP_FAST_CHECKS:-}" ] && exit 0

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
CACHE="$ROOT/.claude/.cache"
LOG="$CACHE/fast-checks.log"
cd "$ROOT" || exit 0

fingerprint() {
  {
    find src test ext experiments -type f -exec cksum {} + 2>/dev/null
    cksum Project.toml Manifest.toml 2>/dev/null
  } | LC_ALL=C sort | cksum | cut -d' ' -f1
}

# test/reference/ is small, so every file is checksummed. docs/papers/ and results/
# can be large, so only their file lists are kept and changes are found by mtime.
reference_state() {
  find test/reference -type f ! -name .DS_Store -exec cksum {} + 2>/dev/null | LC_ALL=C sort
}

kept_files() {
  find docs/papers results -type f ! -name .DS_Store 2>/dev/null | LC_ALL=C sort
}

protected_changes() {
  [ -f "$CACHE/ref-start" ] && [ -f "$CACHE/kept-start" ] && [ -f "$CACHE/turn-stamp" ] || return 0
  reference_state > "$CACHE/ref-now"
  kept_files > "$CACHE/kept-now"
  LC_ALL=C comm -3 "$CACHE/ref-start" "$CACHE/ref-now" | tr -d '\t' | cut -d' ' -f3- | LC_ALL=C sort -u |
    while IFS= read -r path; do
      if [ ! -e "$path" ]; then
        echo "  deleted:  $path"
      elif cut -d' ' -f3- "$CACHE/ref-start" | grep -qFx -- "$path"; then
        echo "  modified: $path"
      else
        echo "  added:    $path"
      fi
    done
  LC_ALL=C comm -23 "$CACHE/kept-start" "$CACHE/kept-now" | sed 's/^/  deleted:  /'
  find docs/papers results -type f ! -name .DS_Store -newer "$CACHE/turn-stamp" 2>/dev/null | LC_ALL=C sort |
    LC_ALL=C comm -12 - "$CACHE/kept-start" | sed 's/^/  modified: /'
}

saved() {
  cat "$CACHE/$1" 2>/dev/null
}

find_julia() {
  if [ -n "${FAST_CHECKS_JULIA:-}" ]; then
    echo "$FAST_CHECKS_JULIA"
    return
  fi
  command -v julia 2>/dev/null && return
  for candidate in "$HOME/.juliaup/bin/julia" /opt/homebrew/bin/julia /usr/local/bin/julia; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return
    fi
  done
}

# Runs in its own process group so that a run past the deadline can be stopped
# together with the test process that Pkg.test() starts.
run_fast_tests() {
  timed_out=0
  SECONDS=0
  set -m
  "$julia_bin" --startup-file=no --project="$ROOT" -e 'using Pkg; Pkg.test()' >"$LOG" 2>&1 </dev/null &
  pid=$!
  set +m
  trap 'kill -TERM -- "-$pid" 2>/dev/null; exit 1' TERM INT HUP
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$SECONDS" -ge "$TIMEOUT" ]; then
      timed_out=1
      kill -TERM -- "-$pid" 2>/dev/null
      sleep 2
      kill -KILL -- "-$pid" 2>/dev/null
      break
    fi
    sleep 1
  done
  wait "$pid" 2>/dev/null
}

log_tail() {
  if [ "$(($(wc -c <"$LOG")))" -gt "$TAIL_BYTES" ]; then
    tail -c "$TAIL_BYTES" "$LOG" | LC_ALL=C sed 1d
  else
    cat "$LOG"
  fi | tail -n "$TAIL_LINES" | LC_ALL=C tr -d '\000-\010\013-\037\177'
}

# Claude Code treats a Stop hook that exits 2 with nothing on stdout and a
# missing-file message on stderr ("No such file or directory") as a non-blocking
# error, and test output often contains such messages. The line on stdout keeps
# the block.
block() {
  echo "fast-checks: stop blocked, reason on stderr"
  printf '%s\n' "$1" >&2
  exit 2
}

# Claude Code shows you only the first line of stderr, so warnings are one line.
warn() {
  echo "fast-checks: $1${pending:+ Also: $pending}" >&2
  exit 1
}

finish() {
  [ -z "$pending" ] && exit 0
  echo "fast-checks: $pending" >&2
  exit 1
}

case "${1:-}" in
  mark)
    mkdir -p "$CACHE"
    fingerprint > "$CACHE/turn-start"
    reference_state > "$CACHE/ref-start"
    kept_files > "$CACHE/kept-start"
    touch "$CACHE/turn-stamp"
    echo 0 > "$CACHE/blocks"
    echo 0 > "$CACHE/timeouts"
    : > "$CACHE/last-fail"
    : > "$CACHE/protected-reported"
    ;;

  gate)
    pending=""
    changes=$(protected_changes)
    if [ -n "$changes" ]; then
      signature=$(echo "$changes" | cksum | cut -d' ' -f1)
      if [ "$signature" != "$(saved protected-reported)" ]; then
        echo "$signature" > "$CACHE/protected-reported"
        block "Files in folders you must not change (test/reference/, docs/papers/, results/) changed during this turn:
$changes
If a command or script you ran did this, undo it now: restore tracked files with 'git checkout -- <path>', remove files you added, and tell the user what happened. Files under docs/papers/ and results/ are not in git: if you cannot restore one exactly, say which. If you did not cause these changes (the user may have edited the files, or an earlier run may still be writing), say so in your reply and carry on."
      fi
      pending="protected files changed during this turn and are still changed: $(echo "$changes" | sed 's/^ *//; s/:  */: /' | tr '\n' ';' | sed 's/;$//; s/;/; /g')"
    fi

    [ -f Project.toml ] && [ -f test/runtests.jl ] || finish
    now=$(fingerprint)
    [ "$now" = "$(saved turn-start)" ] && finish
    [ "$now" = "$(saved last-pass)" ] && finish
    if [ "$now" = "$(saved last-fail)" ]; then
      warn "fast tests are FAILING and Claude stopped without changing the code again. This turn's changes are not verified."
    fi

    julia_bin=$(find_julia)
    [ -n "$julia_bin" ] || warn "julia not found, so the fast tests were NOT run. Set FAST_CHECKS_JULIA to its path."

    mkdir -p "$CACHE"
    if run_fast_tests; then
      echo "$now" > "$CACHE/last-pass"
      finish
    fi

    if [ "$timed_out" = 1 ]; then
      timeouts=$(($(saved timeouts) + 1))
      echo "$timeouts" > "$CACHE/timeouts"
      if [ "$timeouts" -gt 1 ]; then
        warn "fast tests did NOT finish within $TIMEOUT s twice in this turn. This turn's changes are not verified."
      fi
      block "The fast tests did not finish within $TIMEOUT s and were stopped, so this turn's changes are not verified yet. The usual cause is package precompilation after a dependency change. Run julia --project -e 'using Pkg; Pkg.instantiate(; workspace=true); Pkg.precompile(; workspace=true)' until it completes, then finish again so that the tests rerun. If the tests themselves are slow, report which ones; do not remove, skip or shrink a test to get under the limit. Full log: .claude/.cache/fast-checks.log
--- end of the log
$(log_tail)"
    fi

    echo "$now" > "$CACHE/last-fail"
    blocks=$(($(saved blocks) + 1))
    echo "$blocks" > "$CACHE/blocks"
    if [ "$blocks" -gt "$MAX_BLOCKS" ]; then
      warn "fast tests still FAILING after $MAX_BLOCKS forced retries. This turn's changes are not verified."
    fi
    block "Fast tests failed (forced retry $blocks of $MAX_BLOCKS). Fix the code. If you cannot do that without weakening a test, stop and report the failure and your diagnosis. Full log: .claude/.cache/fast-checks.log
--- end of: julia --project -e 'using Pkg; Pkg.test()'
$(log_tail)"
    ;;
esac
exit 0
