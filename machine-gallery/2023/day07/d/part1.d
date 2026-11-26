// Ranges do the hand typing: sort the cards, `group` them, take the counts and sort
// those descending. D arrays compare lexicographically, so multiSort ranks
// by shape, then card values.
module part1;

import std.algorithm, std.array, std.conv, std.range, std.string;

struct Hand { int[] shape, values; long bid; }

Hand parseHand(string line, string order, bool jokers) {
    auto parts = line.split;
    auto cards = parts[0];
    auto shape = cards.filter!(c => !jokers || c != 'J').array.sort.group.map!(g => cast(int) g[1]).array.sort!"a > b".release;
    if (jokers) {
        if (shape.empty) shape = [0]; // JJJJJ
        shape[0] += cast(int) cards.count('J');
    }
    auto values = cards.map!(c => cast(int) order.indexOf(c)).array;
    return Hand(shape, values, parts[1].to!long);
}

long totalWinnings(string input, string order, bool jokers) {
    auto hands = input.strip.splitLines.map!(l => parseHand(l, order, jokers)).array;
    hands.multiSort!("a.shape < b.shape", "a.values < b.values");
    return hands.enumerate(1).map!(e => e.index * e.value.bid).sum;
}

auto solve(string input) {
    return totalWinnings(input, "23456789TJQKA", false);
}
