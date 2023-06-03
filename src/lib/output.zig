const std = @import("std");

// Wrapper around std.io.getStdOut().writer().print()
pub fn print(comptime format: []const u8, args: anytype) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print(format, args);
}
