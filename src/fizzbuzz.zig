const std = @import("std");
const Allocator = std.mem.Allocator;

/// Remove unnecessary character delimiter data from the OS
fn sanitizeData(data: []u8) []u8 {
    return if (data[data.len - 1] == '\r') return data[0 .. data.len - 1] else data;
}

// Wrapper around std.io.getStdOut().writer().print()
fn print(comptime format: []const u8, args: anytype) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print(format, args);
}

/// Read user string input from the command line
fn readUserInput(message: []const u8) ![]u8 {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [10]u8 = undefined;

    try stdout.print("{s}", .{message});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        return sanitizeData(line);
    } else {
        return error.InvalidParam;
    }
}
/// Read an integer from standard input.
fn readInteger(comptime T: type, message: []const u8) !T {
    const result = try readUserInput(message);
    return try std.fmt.parseInt(T, result, 10);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const n = try readInteger(usize, "Enter a number: ");
    for (1..n + 1) |num| {
        if (num % 3 != 0 and num % 5 != 0) {
            try print("{}", .{num});
        } else {
            if (num % 3 == 0) try print("fizz", .{});
            if (num % 5 == 0) try print("buzz", .{});
        }

        if (num < n) try print(", ", .{});
    }
}

test "sanitize test" {
    const expect = std.testing.expect;
    const eql = std.mem.eql;
    var data = [_]u8{ 'B', 'o', 'o', '\r' };

    const result = sanitizeData(data[0..]);
    try expect(eql(u8, result, "Boo"));
}
