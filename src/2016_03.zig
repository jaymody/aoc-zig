const std = @import("std");
const aoc = @import("./aoc.zig");

fn parseLine(line: []const u8) !struct { u64, u64, u64 } {
    var numbers = std.mem.tokenizeScalar(u8, line, ' ');
    return .{
        try std.fmt.parseInt(u64, numbers.next().?, 10),
        try std.fmt.parseInt(u64, numbers.next().?, 10),
        try std.fmt.parseInt(u64, numbers.next().?, 10),
    };
}

fn isPossible(a: u64, b: u64, c: u64) bool {
    return ((a + b) > c) and ((a + c) > b) and ((b + c) > a);
}

const Part1 = struct {
    fn solve(buffer: []const u8, _: std.mem.Allocator) !u64 {
        var lines = std.mem.splitScalar(u8, buffer, '\n');

        var total: u64 = 0;
        while (lines.next()) |line| {
            const a, const b, const c = try parseLine(line);
            total += @intFromBool(isPossible(a, b, c));
        }
        return total;
    }
};

const Part2 = struct {
    fn solve(buffer: []const u8, _: std.mem.Allocator) !u64 {
        var lines = std.mem.splitScalar(u8, buffer, '\n');

        var total: u64 = 0;
        while (lines.next()) |line1| {
            const line2 = lines.next().?;
            const line3 = lines.next().?;

            const a1, const a2, const a3 = try parseLine(line1);
            const b1, const b2, const b3 = try parseLine(line2);
            const c1, const c2, const c3 = try parseLine(line3);

            total += @intFromBool(isPossible(a1, b1, c1));
            total += @intFromBool(isPossible(a2, b2, c2));
            total += @intFromBool(isPossible(a3, b3, c3));
        }

        return total;
    }
};

pub fn main() !void {
    try aoc.runNumeric(u64, Part1.solve, Part2.solve);
}
