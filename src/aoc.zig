const std = @import("std");

const Part = enum { one, two };
pub fn getPartFromCmdlineArgs() Part {
    var args = std.process.args();
    _ = args.next(); // first argument is the program itself
    const arg = args.next() orelse unreachable;

    if (std.mem.eql(u8, arg, "part1")) {
        return Part.one;
    } else if (std.mem.eql(u8, arg, "part2")) {
        return Part.two;
    }
    std.debug.panic("must provide exactly one argument 'part1' or 'part2')", .{});
}

pub fn run(
    comptime part1: fn (buffer: []const u8, allocator: std.mem.Allocator) anyerror![]const u8,
    comptime part2: fn (buffer: []const u8, allocator: std.mem.Allocator) anyerror![]const u8,
) !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const buffer = try stdin.readAllAlloc(allocator, 100000);
    const input = std.mem.trimRight(u8, buffer[0..], "\n");

    const out = switch (getPartFromCmdlineArgs()) {
        .one => try part1(input, allocator),
        .two => try part2(input, allocator),
    };

    try stdout.print("{s}", .{out});
}

fn wrapNumericFn(
    comptime T: type,
    comptime f: fn ([]const u8, std.mem.Allocator) anyerror!T,
) fn ([]const u8, std.mem.Allocator) anyerror![]const u8 {
    return struct {
        pub fn call(buffer: []const u8, allocator: std.mem.Allocator) anyerror![]const u8 {
            const out = try f(buffer, allocator);
            return std.fmt.allocPrint(allocator, "{d}", .{out});
        }
    }.call;
}

pub fn runNumeric(
    comptime T: type,
    comptime part1: fn ([]const u8, std.mem.Allocator) anyerror!T,
    comptime part2: fn ([]const u8, std.mem.Allocator) anyerror!T,
) !void {
    const wrapped1 = wrapNumericFn(T, part1);
    const wrapped2 = wrapNumericFn(T, part2);
    try run(wrapped1, wrapped2);
}
