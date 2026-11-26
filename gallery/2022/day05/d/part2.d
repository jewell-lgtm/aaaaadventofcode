// The CrateMover 9001 lifts several crates at once: append a slice, then shrink.
module part2;

import part1 : parse, tops;

auto solve(string input) {
    auto parsed = parse(input);
    auto stacks = parsed[0];
    foreach (m; parsed[1]) {
        auto cut = stacks[m.from].length - m.count;
        stacks[m.to] ~= stacks[m.from][cut .. $];
        stacks[m.from] = stacks[m.from][0 .. cut];
    }
    return tops(stacks);
}
