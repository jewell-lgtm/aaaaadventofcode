// Stacks are char[] arrays filled bottom-up from the drawing; ~= pushes,
// .back / .popBack pop. The CrateMover 9000 moves one crate at a time.
module part1;

import std.algorithm, std.array, std.conv, std.range, std.string, std.typecons;

struct Move { size_t count, from, to; }

auto parse(string input) {
    auto sections = input.split("\n\n");
    auto rows = sections[0].splitLines;
    auto stacks = new char[][]((rows.back.length + 2) / 4); // " 1   2   3": 4 chars per stack
    foreach_reverse (row; rows[0 .. $ - 1])
        foreach (i, ref stack; stacks)
            if (1 + 4 * i < row.length && row[1 + 4 * i] != ' ') stack ~= row[1 + 4 * i];

    auto moves = sections[1].splitLines.map!((line) {
        auto n = line.split.drop(1).stride(2).map!(to!size_t).array; // "move 1 from 2 to 1"
        return Move(n[0], n[1] - 1, n[2] - 1);
    }).array;
    return tuple(stacks, moves);
}

string tops(char[][] stacks) {
    return stacks.filter!(s => !s.empty).map!(s => s.back).to!string;
}

auto solve(string input) {
    auto parsed = parse(input);
    auto stacks = parsed[0];
    foreach (m; parsed[1]) {
        foreach (_; 0 .. m.count) {
            stacks[m.to] ~= stacks[m.from].back;
            stacks[m.from].popBack();
        }
    }
    return tops(stacks);
}
