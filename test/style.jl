# Enforces the type-annotation rules in .claude/rules/julia-code.md (Style) by reading
# the source: every function argument is typed, no return type is annotated in a
# signature, and every function docstring's signature line states `-> T`.
using JuliaSyntax: JuliaSyntax, @K_str, SyntaxNode, children, is_infix_op_call, is_leaf,
    kind, parseall, source_location, sourcetext

"""
    descendants(node::SyntaxNode) -> Vector{SyntaxNode}

`node` and every node below it, depth first.
"""
function descendants(node::SyntaxNode)
    found = SyntaxNode[node]
    is_leaf(node) || foreach(child -> append!(found, descendants(child)), children(node))
    return found
end

"""
    signature_call(signature::SyntaxNode) -> Tuple{Union{SyntaxNode, Nothing}, Bool}

The call node of a function signature with its `where` clauses and return-type
annotation removed, and whether a return type was annotated. The call node is `nothing`
for an anonymous function or a `function f end` declaration.
"""
function signature_call(signature::SyntaxNode)
    has_return_type = false
    while true
        if kind(signature) == K"where"
            signature = children(signature)[1]
        elseif kind(signature) == K"::" && length(children(signature)) == 2
            has_return_type = true
            signature = children(signature)[1]
        else
            break
        end
    end
    return (kind(signature) == K"call" ? signature : nothing), has_return_type
end

"""
    call_arguments(call::SyntaxNode) -> Vector{SyntaxNode}

The positional and keyword arguments of the call node of a function signature.
"""
function call_arguments(call::SyntaxNode)
    nodes = collect(children(call))
    # The callee is the second child of an infix definition such as `a::T + b::T`.
    deleteat!(nodes, is_infix_op_call(call) ? 2 : 1)
    arguments = SyntaxNode[]
    for node in nodes
        kind(node) == K"parameters" ? append!(arguments, children(node)) : push!(arguments, node)
    end
    return arguments
end

"""
    is_annotated(argument::SyntaxNode) -> Bool

Whether a function argument carries a type annotation, looking through a default value
(`x::T = v`) and a splat (`xs::T...`).
"""
function is_annotated(argument::SyntaxNode)
    kind(argument) in (K"=", K"...") && return is_annotated(children(argument)[1])
    return kind(argument) == K"::"
end

"""
    documents_function(target::SyntaxNode) -> Bool

Whether the definition a docstring is attached to is a function, possibly inside a macro
call such as `@inline`.
"""
function documents_function(target::SyntaxNode)
    kind(target) == K"function" && return true
    return kind(target) == K"macrocall" && any(child -> kind(child) == K"function", children(target))
end

"""
    style_violations(source::AbstractString, filename::AbstractString) -> Vector{String}

One message, prefixed with `filename:line:`, for each untyped function argument, each
return type annotated in a signature, and each function docstring whose first non-blank
line does not state a return type with `->`.
"""
function style_violations(source::AbstractString, filename::AbstractString)
    violations = String[]
    for node in descendants(parseall(SyntaxNode, source; filename))
        line = first(source_location(node))
        if kind(node) == K"function"
            call, has_return_type = signature_call(children(node)[1])
            call === nothing && continue
            has_return_type && push!(violations, "$filename:$line: return type annotated in the signature")
            for argument in call_arguments(call)
                is_annotated(argument) ||
                    push!(violations, "$filename:$line: argument `$(sourcetext(argument))` has no type annotation")
            end
        elseif kind(node) == K"doc" && documents_function(children(node)[2])
            text = join(sourcetext.(filter(is_leaf, children(children(node)[1]))))
            signature_line = something(findfirst(!isempty, strip.(split(text, '\n'))), 0)
            if signature_line == 0 || !occursin("->", split(text, '\n')[signature_line])
                push!(violations, "$filename:$line: docstring signature line does not state `-> ReturnType`")
            end
        end
    end
    return violations
end

@testset "Type-annotation checker reports each kind of violation" begin
    source = """
    \"\"\"
        documented(x::Real)

    No return type stated.
    \"\"\"
    documented(x::Real) = x
    untyped(x, y::Real; z = 1, w::Real = 2) = x
    function annotated_return(x::Real)::Real
        return x
    end
    splat(xs...) = xs
    a::Real ⊕ b = a
    good(x::Real, ::Type{T}; k::Real = 1) where {T} = map(u -> u, x)
    \"\"\"
        good_doc(x::Real) -> Real
    \"\"\"
    good_doc(x::Real) = x
    function declared_only end
    """
    @test style_violations(source, "snippet.jl") == [
        "snippet.jl:1: docstring signature line does not state `-> ReturnType`",
        "snippet.jl:7: argument `x` has no type annotation",
        "snippet.jl:7: argument `z = 1` has no type annotation",
        "snippet.jl:8: return type annotated in the signature",
        "snippet.jl:11: argument `xs...` has no type annotation",
        "snippet.jl:12: argument `b` has no type annotation",
    ]
end

@testset "Function arguments typed, return types in docstrings (.claude/rules/julia-code.md): $(relpath(file, ROOT))" for file in julia_source_files(ROOT)
    @test style_violations(read(file, String), relpath(file, ROOT)) == String[]
end
