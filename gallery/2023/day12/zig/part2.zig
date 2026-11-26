//! Unfold each record five times; the same memoised count absorbs the blow-up.
const std = @import("std");
const part1 = @import("part1.zig");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    var total: u64 = 0;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const record = try part1.parse(gpa, line);
        var springs: std.ArrayList(u8) = .empty;
        var groups: std.ArrayList(usize) = .empty;
        for (0..5) |k| {
            if (k > 0) try springs.append(gpa, '?');
            try springs.appendSlice(gpa, record.springs);
            try groups.appendSlice(gpa, record.groups);
        }
        total += try part1.arrangements(gpa, springs.items, groups.items);
    }
    return total;
}
