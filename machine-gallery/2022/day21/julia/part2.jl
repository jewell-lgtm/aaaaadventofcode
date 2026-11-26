# Monkey Math, part 2: rewrite root as left - right == 0, then walk down the branch holding humn,
# inverting each operation against the value of the other (known) branch.
using .Aoc: arg, example
include("monkeys.jl")

const INVERSE = Dict("+" => -, "-" => +, "*" => //, "/" => *)   # x op k = t  =>  x = INVERSE[op](t, k)

function solve_for(tree, name, target)
    name == "humn" && return target
    left, op, right = tree[name]
    if depends_on(tree, left)
        return solve_for(tree, left, INVERSE[op](target, evaluate(tree, right)))
    end
    known = evaluate(tree, left)
    # k op x = t: - and / swap operands, + and * invert as usual
    next = op in ("-", "/") ? OPS[op](known, target) : INVERSE[op](target, known)
    return solve_for(tree, right, next)
end

function solve(input)
    tree = parse_tree(input)
    left, _, right = tree["root"]
    tree["root"] = (left, "-", right)
    return Int(solve_for(tree, "root", 0 // 1))
end
