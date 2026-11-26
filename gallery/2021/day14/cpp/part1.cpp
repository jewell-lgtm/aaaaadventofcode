// Count pairs, not the polymer: each step maps pair AB (rule AB -> C) to AC and CB.
// unordered_map<string, long long> does the bookkeeping; ranges::minmax finishes it.
#include <algorithm>
#include <ranges>
#include <unordered_map>
#include "aoc.hpp"

constexpr int steps = 10;

aoc::Answer solve(std::string_view input) {
    auto lines = aoc::lines(input);
    std::string_view polymer = lines[0];
    std::unordered_map<std::string, char> rules;
    for (auto line : lines | std::views::drop(2)) rules[std::string(line.substr(0, 2))] = line[6];

    std::unordered_map<std::string, long long> pairs;
    for (size_t i = 0; i + 1 < polymer.size(); i++) pairs[std::string(polymer.substr(i, 2))]++;
    for (int step = 0; step < steps; step++) {
        std::unordered_map<std::string, long long> next;
        for (const auto& [pair, n] : pairs) {
            if (auto rule = rules.find(pair); rule != rules.end()) {
                next[{pair[0], rule->second}] += n;
                next[{rule->second, pair[1]}] += n;
            } else {
                next[pair] += n;
            }
        }
        pairs = std::move(next);
    }

    // Every element is the first letter of exactly one pair, except the last one.
    std::unordered_map<char, long long> counts{{polymer.back(), 1}};
    for (const auto& [pair, n] : pairs) counts[pair[0]] += n;
    auto [least, most] = std::ranges::minmax(counts | std::views::values);
    return most - least;
}
