# Shared: Dict of name => Int | (left, op, right). Rational{Int128} keeps division exact.
const OPS = Dict("+" => +, "-" => -, "*" => *, "/" => //)

function parse_tree(input)
    tree = Dict{String,Any}()
    for line in split(chomp(input), '\n')
        name, job = split(line, ": ")
        parts = split(job)
        tree[name] = length(parts) == 1 ? parse(Int128, job) : Tuple(parts)
    end
    return tree
end

evaluate(tree, name) = evaluate(tree, tree[name])
evaluate(tree, n::Integer) = n // 1
evaluate(tree, (left, op, right)::Tuple) = OPS[op](evaluate(tree, left), evaluate(tree, right))

depends_on(tree, name) = name == "humn" || (tree[name] isa Tuple && any(depends_on(tree, n) for n in tree[name][[1, 3]]))
