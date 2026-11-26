//! Memoised recursion over (position, group index). The memo is a flat slice of
//! optionals (null = not computed yet) held in a small struct with the input.
const std = @import("std");

pub fn solve(gpa: std.mem.Allocator, input: []const u8) !u64 {
    var total: u64 = 0;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const record = try parse(gpa, line);
        total += try arrangements(gpa, record.springs, record.groups);
    }
    return total;
}

pub const Record = struct { springs: []const u8, groups: []usize };

pub fn parse(gpa: std.mem.Allocator, line: []const u8) !Record {
    const space = std.mem.indexOfScalar(u8, line, ' ') orelse return error.BadLine;
    var groups: std.ArrayList(usize) = .empty;
    var nums = std.mem.tokenizeScalar(u8, line[space + 1 ..], ',');
    while (nums.next()) |n| try groups.append(gpa, try std.fmt.parseInt(usize, n, 10));
    return .{ .springs = line[0..space], .groups = groups.items };
}

pub fn arrangements(gpa: std.mem.Allocator, springs: []const u8, groups: []const usize) !u64 {
    const memo = try gpa.alloc(?u64, (springs.len + 1) * (groups.len + 1));
    @memset(memo, null);
    var counter = Counter{ .springs = springs, .groups = groups, .memo = memo };
    return counter.count(0, 0);
}

const Counter = struct {
    springs: []const u8,
    groups: []const usize,
    memo: []?u64,

    fn count(self: *Counter, i: usize, g: usize) u64 {
        if (i >= self.springs.len) return @intFromBool(g == self.groups.len);
        const slot = &self.memo[i * (self.groups.len + 1) + g];
        if (slot.*) |cached| return cached;
        var ways: u64 = 0;
        if (self.springs[i] != '#') ways += self.count(i + 1, g); // operational
        if (self.springs[i] != '.' and g < self.groups.len and self.fits(i, self.groups[g]))
            ways += self.count(i + self.groups[g] + 1, g + 1); // start a damaged run here
        slot.* = ways;
        return ways;
    }

    /// Can a run of n damaged springs start at i (and be followed by a gap)?
    fn fits(self: Counter, i: usize, n: usize) bool {
        const s = self.springs;
        if (i + n > s.len or std.mem.indexOfScalar(u8, s[i .. i + n], '.') != null) return false;
        return i + n == s.len or s[i + n] != '#';
    }
};
