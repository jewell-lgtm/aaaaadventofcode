//! Jobs are a tagged union (number or math) in a StringHashMap, evaluated
//! recursively. Zig makes you pick division semantics: @divTrunc for i64.
const std = @import("std");

pub const Job = union(enum) {
    number: i64,
    math: struct { left: []const u8, op: u8, right: []const u8 },
};

pub const Jobs = std.StringHashMap(Job);

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !i64 {
    const jobs = try parse(gpa, input);
    return eval(jobs, "root");
}

pub fn parse(gpa: std.mem.Allocator, input: []const u8) !Jobs {
    var jobs = Jobs.init(gpa);
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        // "root: pppw + sjmn" or "dbpl: 5"
        const rest = line[6..];
        const job: Job = if (std.ascii.isAlphabetic(rest[0]))
            .{ .math = .{ .left = rest[0..4], .op = rest[5], .right = rest[7..11] } }
        else
            .{ .number = try std.fmt.parseInt(i64, rest, 10) };
        try jobs.put(line[0..4], job);
    }
    return jobs;
}

pub fn eval(jobs: Jobs, name: []const u8) i64 {
    return switch (jobs.get(name).?) {
        .number => |n| n,
        .math => |m| apply(m.op, eval(jobs, m.left), eval(jobs, m.right)),
    };
}

pub fn apply(op: u8, a: i64, b: i64) i64 {
    return switch (op) {
        '+' => a + b,
        '-' => a - b,
        '*' => a * b,
        '/' => @divTrunc(a, b),
        else => unreachable,
    };
}
