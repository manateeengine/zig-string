//! An example showing basic string manipulation.

const String = @import("string");
const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var my_string = try String.init(allocator, "Hello, World!");
    defer my_string.deinit();

    std.log.info("Initial Value: {s}", .{my_string.asStringLiteral()});

    my_string.toUpperCase();
    std.log.info("Upper Case: {s}", .{my_string.asStringLiteral()});

    my_string.toLowerCase();
    std.log.info("Lower Case: {s}", .{my_string.asStringLiteral()});

    my_string.toCapitalized();
    std.log.info("Capitalized: {s}", .{my_string.asStringLiteral()});

    _ = try my_string.replaceAll("world", "Manatee Engine");
    std.log.info("Replaced Word: {s}", .{my_string.asStringLiteral()});
}
