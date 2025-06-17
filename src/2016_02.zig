const std = @import("std");
const aoc = @import("./aoc.zig");

fn addClipped(x: i64, y: i64) i64 {
    return @max(0, @min(2, x + y));
}

fn part1(buffer: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    var lines = std.mem.splitSequence(u8, buffer, "\n");

    var row: i64 = 1;
    var col: i64 = 1;

    var out = std.ArrayList(u8).init(allocator);
    while (lines.next()) |line| {
        for (line) |dir| {
            switch (dir) {
                'U' => row = addClipped(row, -1),
                'R' => col = addClipped(col, 1),
                'D' => row = addClipped(row, 1),
                'L' => col = addClipped(col, -1),
                else => std.debug.panic("char must be one of 'U', 'R', 'L', 'D' but found '{c}'", .{dir}),
            }
        }

        const key: u8 = @intCast(row * 3 + col + 1);
        try out.append('0' + key);
    }

    return out.items;
}

fn incr(x: i64, y: i64) i64 {
    if (@abs(x + 1) + @abs(y) <= 2) {
        return x + 1;
    } else {
        return x;
    }
}

fn decr(x: i64, y: i64) i64 {
    if (@abs(x - 1) + @abs(y) <= 2) {
        return x - 1;
    } else {
        return x;
    }
}

fn part2(buffer: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    var lines = std.mem.splitSequence(u8, buffer, "\n");

    var row: i64 = 0;
    var col: i64 = 0;

    const values = [_]struct { i64, i64, u8 }{
        .{ -2, 0, '1' },
        .{ -1, -1, '2' },
        .{ -1, 0, '3' },
        .{ -1, 1, '4' },
        .{ 0, -2, '5' },
        .{ 0, -1, '6' },
        .{ 0, 0, '7' },
        .{ 0, 1, '8' },
        .{ 0, 2, '9' },
        .{ 1, -1, 'A' },
        .{ 1, 0, 'B' },
        .{ 1, 1, 'C' },
        .{ 2, 0, 'D' },
    };
    var tbl = std.AutoHashMap(struct { i64, i64 }, u8).init(allocator);
    for (values) |entry| {
        try tbl.put(.{ entry[0], entry[1] }, entry[2]);
    }

    var out = std.ArrayList(u8).init(allocator);
    while (lines.next()) |line| {
        for (line) |dir| {
            switch (dir) {
                'U' => row = decr(row, col),
                'R' => col = incr(col, row),
                'D' => row = incr(row, col),
                'L' => col = decr(col, row),
                else => std.debug.panic("char must be one of 'U', 'R', 'L', 'D' but found '{c}'", .{dir}),
            }
        }

        const key: u8 = tbl.get(.{ row, col }) orelse std.debug.panic("invalid position", .{});
        try out.append(key);
    }

    return out.items;
}

pub fn main() !void {
    try aoc.run(part1, part2);
}
