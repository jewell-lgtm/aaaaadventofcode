// Each monkey's job is a std::variant: a number or an Expr. std::visit with an
// "overloaded" set of lambdas evaluates the tree recursively.
#include <unordered_map>
#include <variant>
#include "aoc.hpp"

struct Expr {
    std::string left;
    char op;
    std::string right;
};
using Job = std::variant<long long, Expr>;
using Jobs = std::unordered_map<std::string, Job>;

template <class... Fs>
struct overloaded : Fs... {
    using Fs::operator()...;
};

long long eval(const Jobs& jobs, const std::string& name) {
    return std::visit(overloaded{
                          [](long long n) { return n; },
                          [&](const Expr& e) {
                              long long a = eval(jobs, e.left), b = eval(jobs, e.right);
                              switch (e.op) {
                                  case '+': return a + b;
                                  case '-': return a - b;
                                  case '*': return a * b;
                                  default: return a / b;
                              }
                          },
                      },
                      jobs.at(name));
}

aoc::Answer solve(std::string_view input) {
    Jobs jobs;
    for (auto line : aoc::lines(input)) {
        // "root: pppw + sjmn" or "dbpl: 5"
        std::string name{line.substr(0, 4)};
        auto rest = line.substr(6);
        if (std::isalpha(static_cast<unsigned char>(rest[0])))
            jobs[name] = Expr{std::string(rest.substr(0, 4)), rest[5], std::string(rest.substr(7, 4))};
        else
            jobs[name] = aoc::num(rest);
    }
    return eval(jobs, "root");
}
