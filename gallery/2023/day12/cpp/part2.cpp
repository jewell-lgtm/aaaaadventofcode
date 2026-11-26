// Unfold each record five times, then the same memoised recursion. C++23 "deducing
// this" lets the counting lambda recurse into itself.
#include <algorithm>
#include "aoc.hpp"

long long arrangements(std::string_view springs, const std::vector<long long>& groups) {
    std::vector memo(springs.size() + 1, std::vector<long long>(groups.size() + 1, -1));

    // Can a run of n damaged springs start at i (and be followed by a gap)?
    auto fits = [&](size_t i, size_t n) {
        return i + n <= springs.size() && !springs.substr(i, n).contains('.') &&
               (i + n == springs.size() || springs[i + n] != '#');
    };

    auto count = [&](this auto& self, size_t i, size_t g) -> long long {
        if (i >= springs.size()) return g == groups.size();
        auto& cached = memo[i][g];
        if (cached >= 0) return cached;
        long long ways = 0;
        if (springs[i] != '#') ways += self(i + 1, g);  // operational
        if (springs[i] != '.' && g < groups.size() && fits(i, groups[g]))
            ways += self(i + groups[g] + 1, g + 1);  // start a damaged run here
        return cached = ways;
    };
    return count(0, 0);
}

aoc::Answer solve(std::string_view input) {
    long long total = 0;
    for (auto line : aoc::lines(input)) {
        auto space = line.find(' ');
        std::string springs{line.substr(0, space)};
        auto groups = aoc::ints(line.substr(space));
        std::string folded = springs;
        auto base = groups;
        for (int k = 1; k < 5; k++) {
            springs += "?" + folded;
            groups.insert(groups.end(), base.begin(), base.end());
        }
        total += arrangements(springs, groups);
    }
    return total;
}
