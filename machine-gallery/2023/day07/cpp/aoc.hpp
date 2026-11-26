// Harness helpers.
#pragma once
#include <cctype>
#include <charconv>
#include <concepts>
#include <ranges>
#include <cstdlib>
#include <string>
#include <string_view>
#include <vector>

namespace aoc {

// What solve() returns: any integer or string converts implicitly.
struct Answer {
    std::string text;
    Answer(std::integral auto n) : text(std::to_string(n)) {}
    Answer(std::string s) : text(std::move(s)) {}
    Answer(const char* s) : text(s) {}
};

// True when running an example (aoc test).
inline const bool example = [] {
    const char* e = std::getenv("AOC_EXAMPLE");
    return e && std::string_view(e) == "1";
}();

// Example-specific constant from examples.toml `args`, else the real-input default.
// AOC_ARGS is a flat JSON object like {"size": 7}; numbers and true/false are supported.
template <std::integral T>
T arg(std::string_view name, T fallback) {
    const char* env = std::getenv("AOC_ARGS");
    std::string_view json = env ? env : "";
    auto at = json.find("\"" + std::string(name) + "\"");
    if (at == json.npos) return fallback;
    at = json.find(':', at);
    if (at == json.npos) return fallback;
    auto value = json.substr(json.find_first_not_of(" \"", at + 1));
    if (value.starts_with("true")) return 1;
    if (value.starts_with("false")) return 0;
    T out = fallback;
    std::from_chars(value.data(), value.data() + value.size(), out);
    return out;
}

// Lines of the input, blank lines kept, trailing newline dropped.
inline std::vector<std::string_view> lines(std::string_view input) {
    while (input.ends_with('\n')) input.remove_suffix(1);
    std::vector<std::string_view> out;
    for (auto part : input | std::views::split('\n')) out.emplace_back(part.begin(), part.end());
    return out;
}

// Number at the start of s: aoc::num<int>("42") == 42.
template <std::integral T = long long>
T num(std::string_view s) {
    T out{};
    std::from_chars(s.data(), s.data() + s.size(), out);
    return out;
}

// Every integer in s, in order: aoc::ints("move 3 from -1 to 2") == {3, -1, 2}.
inline std::vector<long long> ints(std::string_view s) {
    std::vector<long long> out;
    for (size_t i = 0; i < s.size(); i++) {
        bool neg = s[i] == '-' && i + 1 < s.size() && std::isdigit(static_cast<unsigned char>(s[i + 1]));
        if (!neg && !std::isdigit(static_cast<unsigned char>(s[i]))) continue;
        long long v = 0;
        auto [end, _] = std::from_chars(s.data() + i, s.data() + s.size(), v);
        out.push_back(v);
        i = static_cast<size_t>(end - s.data()) - 1;
    }
    return out;
}

}  // namespace aoc

aoc::Answer solve(std::string_view input);
