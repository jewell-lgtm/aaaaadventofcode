// Each stack is a std::string, filled bottom-up from the drawing. The CrateMover 9001
// lifts the top `count` crates at once: append a substr, then shrink the source.
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
        auto& source = stacks[from - 1];
        stacks[to - 1] += source.substr(source.size() - count);
        source.resize(source.size() - count);
    }

    std::string tops;
    for (const auto& s : stacks)
        if (!s.empty()) tops += s.back();
    return tops;
}
