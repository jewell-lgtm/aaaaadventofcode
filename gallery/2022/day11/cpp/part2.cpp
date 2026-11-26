// No relief, 10000 rounds: keep worry modulo the product of all divisors, which
// preserves every divisibility test and keeps numbers inside 64 bits.
#include <algorithm>
#include <functional>
#include "aoc.hpp"

struct Monkey {
    std::vector<long> items;
    std::function<long(long)> operation;
    long divisor = 1;
    size_t if_true = 0, if_false = 0;
};

std::vector<Monkey> parse_monkeys(std::string_view input) {
    auto lines = aoc::lines(input);
    std::vector<Monkey> monkeys;
    for (size_t i = 0; i + 5 < lines.size(); i += 7) {
        Monkey m;
        for (auto item : aoc::ints(lines[i + 1])) m.items.push_back(item);
        auto expr = lines[i + 2].substr(lines[i + 2].find("old ") + 4);  // "* 19", "+ 6", "* old"
        char op = expr[0];
        bool square = expr.ends_with("old");
        long operand = square ? 0 : aoc::num<long>(expr.substr(2));
        m.operation = [=](long old) {
            long rhs = square ? old : operand;
            return op == '*' ? old * rhs : old + rhs;
        };
        m.divisor = aoc::ints(lines[i + 3])[0];
        m.if_true = aoc::ints(lines[i + 4])[0];
        m.if_false = aoc::ints(lines[i + 5])[0];
        monkeys.push_back(std::move(m));
    }
    return monkeys;
}

long monkey_business(std::vector<Monkey> monkeys, int rounds, const std::function<long(long)>& relief) {
    std::vector<long> inspected(monkeys.size());
    for (int round = 0; round < rounds; round++) {
        for (size_t i = 0; i < monkeys.size(); i++) {
            auto items = std::exchange(monkeys[i].items, {});
            inspected[i] += static_cast<long>(items.size());
            for (long worry : items) {
                worry = relief(monkeys[i].operation(worry));
                monkeys[worry % monkeys[i].divisor == 0 ? monkeys[i].if_true : monkeys[i].if_false].items.push_back(worry);
            }
        }
    }
    std::ranges::sort(inspected, std::greater{});
    return inspected[0] * inspected[1];
}

aoc::Answer solve(std::string_view input) {
    auto monkeys = parse_monkeys(input);
    long modulus = 1;
    for (const auto& m : monkeys) modulus *= m.divisor;
    return monkey_business(std::move(monkeys), 10000, [=](long w) { return w % modulus; });
}
