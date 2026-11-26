//! Harness helpers.
const std = @import("std");

/// True when running an example (aoc test).
pub fn example() bool {
    const e = std.posix.getenv("AOC_EXAMPLE") orelse return false;
    return std.mem.eql(u8, e, "1");
}

/// Example-specific constant from examples.toml `args`, else the real-input default.
/// Supports integer, float and bool fallbacks.
pub fn arg(comptime T: type, name: []const u8, fallback: T) T {
    const json = std.posix.getenv("AOC_ARGS") orelse return fallback;
    const parsed = std.json.parseFromSlice(std.json.Value, std.heap.page_allocator, json, .{}) catch return fallback;
    const value = parsed.value.object.get(name) orelse return fallback;
    return switch (@typeInfo(T)) {
        .int => switch (value) {
            .integer => |i| @intCast(i),
            else => fallback,
        },
        .float => switch (value) {
            .float => |f| @floatCast(f),
            .integer => |i| @floatFromInt(i),
            else => fallback,
        },
        .bool => switch (value) {
            .bool => |b| b,
            else => fallback,
        },
        else => @compileError("aoc.arg: unsupported type " ++ @typeName(T)),
    };
}
