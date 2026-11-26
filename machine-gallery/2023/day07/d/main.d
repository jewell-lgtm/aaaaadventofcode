// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
module main;

import std.array : join;
import std.process : environment;
import std.stdio : stdin, writeln;
import std.typecons : Yes;
static import part1;
static import part2;

void main() {
    auto input = stdin.byLineCopy(Yes.keepTerminator).join;
    if (environment.get("AOC_PART") == "2")
        writeln(part2.solve(input));
    else
        writeln(part1.solve(input));
}
