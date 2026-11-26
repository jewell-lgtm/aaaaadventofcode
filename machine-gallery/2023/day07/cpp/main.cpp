// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
// Each part is its own binary (main + partN), so both parts define `solve`.
#include <iostream>
#include <iterator>
#include <print>
#include "aoc.hpp"

int main() {
    std::string input{std::istreambuf_iterator<char>(std::cin), {}};
    std::println("{}", solve(input).text);
}
