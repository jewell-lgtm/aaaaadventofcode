//! Same backwards BFS from E; stop at the first square of elevation 'a'.
const std = @import("std");
const Heightmap = @import("part1.zig").Heightmap;

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u32 {
    const map = try Heightmap.parse(gpa, input);
    return map.stepsFromEnd(gpa, isLowest);
}

fn isLowest(map: Heightmap, p: usize) bool {
    return map.cells[p] == 'a';
}
