//! humn appears once in the tree. Walk from root towards it, inverting each
//! operation against the value of the other (fully known) subtree.
const std = @import("std");
const part1 = @import("part1.zig");
const Jobs = part1.Jobs;
const eval = part1.eval;

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !i64 {
    const jobs = try part1.parse(gpa, input);
    const root = jobs.get("root").?.math;
    return if (hasHuman(jobs, root.left))
        solveFor(jobs, root.left, eval(jobs, root.right))
    else
        solveFor(jobs, root.right, eval(jobs, root.left));
}

fn hasHuman(jobs: Jobs, name: []const u8) bool {
    if (std.mem.eql(u8, name, "humn")) return true;
    return switch (jobs.get(name).?) {
        .number => false,
        .math => |m| hasHuman(jobs, m.left) or hasHuman(jobs, m.right),
    };
}

/// The humn value that makes the subtree at `name` evaluate to `target`.
fn solveFor(jobs: Jobs, name: []const u8, target: i64) i64 {
    if (std.mem.eql(u8, name, "humn")) return target;
    const m = jobs.get(name).?.math;
    if (hasHuman(jobs, m.left)) {
        const known = eval(jobs, m.right);
        return solveFor(jobs, m.left, switch (m.op) {
            '+' => target - known,
            '-' => target + known,
            '*' => @divTrunc(target, known),
            else => target * known,
        });
    }
    const known = eval(jobs, m.left);
    return solveFor(jobs, m.right, switch (m.op) {
        '+' => target - known,
        '-' => known - target,
        '*' => @divTrunc(target, known),
        else => @divTrunc(known, target),
    });
}
