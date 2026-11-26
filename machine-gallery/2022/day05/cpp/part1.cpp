// Each stack is a std::string (push_back/pop_back/back), filled bottom-up from the
// drawing. The CrateMover 9000 moves crates one at a time.
#include <algorithm>
#include <ranges>
#include "aoc.hpp"

aoc::Answer solve(std::string_view input) {
    auto lines = aoc::lines(input);
    auto blank = std::ranges::find(lines, std::string_view{});
    auto labels = *(blank - 1);

    std::vector<std::string> stacks((labels.size() + 2) / 4);
    for (auto row : std::ranges::subrange(lines.begin(), blank - 1) | std::views::reverse) {
        for (size_t i = 0; i < stacks.size(); i++) {
            size_t col = 1 + 4 * i;
            if (col < row.size() && row[col] != ' ') stacks[i].push_back(row[col]);
        }
    }

    for (auto line : std::ranges::subrange(blank + 1, lines.end())) {
        auto nums = aoc::ints(line);
        auto [count, from, to] = std::tuple(nums[0], nums[1], nums[2]);
        for (long long k = 0; k < count; k++) {
            stacks[to - 1].push_back(stacks[from - 1].back());
            stacks[from - 1].pop_back();
        }
    }

    std::string tops;
    for (const auto& s : stacks)
        if (!s.empty()) tops += s.back();
    return tops;
}
