//! Three-sum: sort in place, then two pointers per first entry. `switch` on
//! std.math.order makes the three cases exhaustive.
const std = @import("std");
const part1 = @import("part1.zig");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    const entries = try part1.parseEntries(gpa, input);
    std.mem.sort(u64, entries, {}, std.sort.asc(u64));
    for (entries, 0..) |a, i| {
        var lo = i + 1;
        var hi = entries.len - 1;
        while (lo < hi) {
            switch (std.math.order(a + entries[lo] + entries[hi], 2020)) {
                .eq => return a * entries[lo] * entries[hi],
                .lt => lo += 1,
                .gt => hi -= 1,
            }
        }
    }
    return error.NoTriple;
}
