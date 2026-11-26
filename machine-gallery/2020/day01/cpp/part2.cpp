// Three-sum: parse with a ranges pipeline into a sorted vector, then sweep two
// pointers for each first entry.
#include <algorithm>
#include <ranges>
#include "aoc.hpp"

aoc::Answer solve(std::string_view input) {
    auto entries = aoc::lines(input) | std::views::transform(aoc::num<int>) | std::ranges::to<std::vector>();
    std::ranges::sort(entries);
    for (size_t i = 0; i + 2 < entries.size(); i++) {
        size_t lo = i + 1, hi = entries.size() - 1;
        while (lo < hi) {
            int sum = entries[i] + entries[lo] + entries[hi];
            if (sum == 2020) return entries[i] * entries[lo] * entries[hi];
            sum < 2020 ? lo++ : hi--;
        }
    }
    return "no triple";
}
