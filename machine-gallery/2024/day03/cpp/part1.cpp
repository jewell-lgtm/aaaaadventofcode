// Regex scan with <regex>: sregex_iterator walks every match; wrapping it in a
// ranges::subrange lets a range-for consume it.
#include <ranges>
#include <regex>
#include "aoc.hpp"

aoc::Answer solve(std::string_view input) {
    static const std::regex mul{R"(mul\((\d{1,3}),(\d{1,3})\))"};
    std::string text{input};
    long total = 0;
    for (const auto& m : std::ranges::subrange(std::sregex_iterator(text.begin(), text.end(), mul), std::sregex_iterator()))
        total += std::stol(m[1]) * std::stol(m[2]);
    return total;
}
