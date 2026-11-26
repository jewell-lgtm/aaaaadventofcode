// Two-sum with std::unordered_set: for each entry, check whether its complement was seen.
// C++20's contains() finally makes set membership read like it means.
#include <unordered_set>
#include "aoc.hpp"

aoc::Answer solve(std::string_view input) {
    std::unordered_set<int> seen;
    for (auto line : aoc::lines(input)) {
        int n = aoc::num<int>(line);
        if (seen.contains(2020 - n)) return n * (2020 - n);
        seen.insert(n);
    }
    return "no pair";
}
