// A Hand struct whose member order *is* the ranking: a defaulted operator<=> compares
// the count shape (e.g. {3, 2} = full house) first, then card values. Then ranges::sort.
#include <algorithm>
#include <array>
#include <compare>
#include <functional>
#include <utility>
#include "aoc.hpp"

constexpr std::string_view order = "23456789TJQKA";

struct Hand {
    std::array<int, 5> shape{};   // card counts, largest first, zero-padded
    std::array<int, 5> values{};  // card strengths in hand order
    long bid = 0;
    auto operator<=>(const Hand&) const = default;
};

Hand parse_hand(std::string_view line) {
    Hand hand;
    std::array<int, 13> counts{};
    for (int i = 0; i < 5; i++) counts[hand.values[i] = static_cast<int>(order.find(line[i]))]++;
    int wild = 0;
    std::ranges::sort(counts, std::greater{});
    std::ranges::copy_n(counts.begin(), 5, hand.shape.begin());
    hand.shape[0] += wild;
    hand.bid = aoc::num<long>(line.substr(6));
    return hand;
}

aoc::Answer solve(std::string_view input) {
    auto hands = aoc::lines(input) | std::views::transform(parse_hand) | std::ranges::to<std::vector>();
    std::ranges::sort(hands);
    long total = 0;
    for (auto [rank, hand] : std::views::enumerate(hands)) total += (rank + 1) * hand.bid;
    return total;
}
