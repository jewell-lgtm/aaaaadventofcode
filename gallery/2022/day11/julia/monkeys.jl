# Shared: a mutable struct per monkey; the operation is a closure over the parsed operator.
mutable struct Monkey
    items::Vector{Int}
    op::Function
    divisor::Int
    targets::Tuple{Int,Int}   # (if true, if false), 1-based
    inspected::Int
end

function parse_monkey(block)
    lines = split(block, '\n')
    nums(line) = [parse(Int, m.match) for m in eachmatch(r"\d+", line)]
    sym, rhs = match(r"old (.) (\w+)", lines[3]).captures
    f = sym == "*" ? (*) : (+)
    op = rhs == "old" ? (old -> f(old, old)) : (old -> f(old, parse(Int, rhs)))
    return Monkey(nums(lines[2]), op, only(nums(lines[4])), (only(nums(lines[5])) + 1, only(nums(lines[6])) + 1), 0)
end

parse_monkeys(input) = parse_monkey.(split(strip(input), "\n\n"))

function business(monkeys, rounds, relieve)
    for _ in 1:rounds, m in monkeys
        for item in m.items
            worry = relieve(m.op(item))
            push!(monkeys[worry % m.divisor == 0 ? m.targets[1] : m.targets[2]].items, worry)
        end
        m.inspected += length(m.items)
        empty!(m.items)
    end
    return prod(partialsort([m.inspected for m in monkeys], 1:2; rev = true))
end
