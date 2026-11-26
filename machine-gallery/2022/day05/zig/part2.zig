//! The CrateMover 9001 lifts several crates at once: appendSlice the top of the
//! source, then shrink it in place.
const std = @import("std");
const part1 = @import("part1.zig");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) ![]const u8 {
    const cargo = try part1.parse(gpa, input);
    for (cargo.moves) |m| {
        const source = &cargo.stacks[m.from];
        const at = source.items.len - m.count;
        try cargo.stacks[m.to].appendSlice(gpa, source.items[at..]);
        source.shrinkRetainingCapacity(at);
    }
    return part1.tops(gpa, cargo.stacks);
}
