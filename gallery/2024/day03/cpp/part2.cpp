// One alternation regex yields mul/do/don't in order; a flag toggles as we walk.
// Raw string literals R"(...)" keep the pattern free of double escaping.
#include <ranges>
#include <regex>
#include "aoc.hpp"

aoc::Answer solve(std::string_view input) {
    static const std::regex instruction{R"(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))"};
    std::string text{input};
    long total = 0;
    bool enabled = true;
    for (const auto& m : std::ranges::subrange(std::sregex_iterator(text.begin(), text.end(), instruction), std::sregex_iterator())) {
        if (m[0] == "do()") enabled = true;
        else if (m[0] == "don't()") enabled = false;
        else if (enabled) total += std::stol(m[1]) * std::stol(m[2]);
    }
    return total;
}
