//! No relief, 10000 rounds: keep worry modulo the product of all divisors, which
//! preserves every divisibility test and keeps the numbers inside u64.
const std = @import("std");
const part1 = @import("part1.zig");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    const monkeys = try part1.parse(gpa, input);
    var modulus: u64 = 1;
    for (monkeys) |m| modulus *= m.divisor;
    return part1.monkeyBusiness(gpa, monkeys, 10_000, .{ .modulo = modulus });
}
