// humn appears once in the tree. Walk from root towards it, inverting each
// operation against the value of the other (fully known) subtree.
module part2;

import part1 : Job, eval, parse;

bool hasHuman(Job[string] jobs, string name) {
    if (name == "humn") return true;
    auto j = jobs[name];
    return j.left !is null && (jobs.hasHuman(j.left) || jobs.hasHuman(j.right));
}

/// The humn value that makes the subtree at `name` evaluate to `target`.
long solveFor(Job[string] jobs, string name, long target) {
    if (name == "humn") return target;
    auto j = jobs[name];
    if (jobs.hasHuman(j.left)) {
        immutable known = jobs.eval(j.right);
        switch (j.op) {
            case '+': return jobs.solveFor(j.left, target - known);
            case '-': return jobs.solveFor(j.left, target + known);
            case '*': return jobs.solveFor(j.left, target / known);
            default: return jobs.solveFor(j.left, target * known);
        }
    }
    immutable known = jobs.eval(j.left);
    switch (j.op) {
        case '+': return jobs.solveFor(j.right, target - known);
        case '-': return jobs.solveFor(j.right, known - target);
        case '*': return jobs.solveFor(j.right, target / known);
        default: return jobs.solveFor(j.right, known / target);
    }
}

auto solve(string input) {
    auto jobs = parse(input);
    auto root = jobs["root"];
    return jobs.hasHuman(root.left)
        ? jobs.solveFor(root.left, jobs.eval(root.right))
        : jobs.solveFor(root.right, jobs.eval(root.left));
}
