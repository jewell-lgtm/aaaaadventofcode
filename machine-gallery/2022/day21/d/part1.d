// Jobs live in a built-in associative array keyed by name; evaluate the tree
// recursively; UFCS lets `jobs.eval("root")` read like a method call.
module part1;

import std.conv, std.string;

struct Job {
    long value;
    string left, right;
    char op; // unused for plain numbers (left is null)
}

Job[string] parse(string input) {
    Job[string] jobs;
    foreach (line; input.strip.splitLines) {
        auto words = line.split; // ["root:", "pppw", "+", "sjmn"] or ["dbpl:", "5"]
        auto name = words[0][0 .. $ - 1];
        jobs[name] = words.length == 4 ? Job(0, words[1], words[3], words[2][0]) : Job(words[1].to!long);
    }
    return jobs;
}

long apply(char op, long a, long b) {
    switch (op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        default: return a / b;
    }
}

long eval(Job[string] jobs, string name) {
    auto j = jobs[name];
    return j.left is null ? j.value : apply(j.op, eval(jobs, j.left), eval(jobs, j.right));
}

auto solve(string input) {
    return parse(input).eval("root");
}
