// humn appears once in the tree. Walk from root towards it, inverting each operation
// against the value of the other (fully known) subtree. Jobs are a std::variant.
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

bool has_human(const Jobs& jobs, const std::string& name) {
    if (name == "humn") return true;
    auto expr = std::get_if<Expr>(&jobs.at(name));
    return expr && (has_human(jobs, expr->left) || has_human(jobs, expr->right));
}

// The humn value that makes the subtree at name evaluate to target.
long long solve_for(const Jobs& jobs, const std::string& name, long long target) {
    if (name == "humn") return target;
    auto [left, op, right] = std::get<Expr>(jobs.at(name));
    if (has_human(jobs, left)) {
        long long known = eval(jobs, right);
        switch (op) {
            case '+': return solve_for(jobs, left, target - known);
            case '-': return solve_for(jobs, left, target + known);
            case '*': return solve_for(jobs, left, target / known);
            default: return solve_for(jobs, left, target * known);
        }
    }
    long long known = eval(jobs, left);
    switch (op) {
        case '+': return solve_for(jobs, right, target - known);
        case '-': return solve_for(jobs, right, known - target);
        case '*': return solve_for(jobs, right, target / known);
        default: return solve_for(jobs, right, known / target);
    }
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
    const auto& root = std::get<Expr>(jobs.at("root"));
    return has_human(jobs, root.left) ? solve_for(jobs, root.left, eval(jobs, root.right))
                                      : solve_for(jobs, root.right, eval(jobs, root.left));
}
