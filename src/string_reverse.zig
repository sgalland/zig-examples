const std = @import("std");

fn findArrayMid(comptime T: type, original: []const T) T {
    var mid: f32 = @intToFloat(f32, original.len) / 2;
    return @floatToInt(T, @round(mid));
}

/// Optimally reverses a string.
fn optimizedStringReverse(allocator: std.mem.Allocator, string: []const u8) ![]u8 {
    var i: usize = 0;
    var data: []u8 = try allocator.alloc(u8, string.len);

    while (i < findArrayMid(u8, string)) : (i += 1) {
        var temp = string[i];
        data[i] = string[data.len - 1 - i];
        data[data.len - 1 - i] = temp;
    }

    return data;
}

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const original_string = "sdrawkcab os leef I";
    std.debug.print("original: {s}\n", .{original_string});

    const result = try optimizedStringReverse(allocator, original_string);
    std.debug.print("reversed: {s}\n", .{result});
}

test "test optimizedStringReverse" {
    const expect = std.testing.expect;
    const eql = std.mem.eql;

    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const result = try optimizedStringReverse(allocator, "sdrawkcab os leef I");
    try expect(eql(u8, result, "I feel so backwards"));

    const result2 = try optimizedStringReverse(allocator, ".smaerd ruoy naht retteb yllanif si ytilaer esuaceb peelsa llaf t'nac uoy nehw evol ni er'uoy wonk uoY");
    try expect(eql(u8, result2, "You know you're in love when you can't fall asleep because reality is finally better than your dreams."));
}
