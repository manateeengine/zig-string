//! A struct used to represent and manipulate a sequence of UTF-8 characters.
//!
//! ## Example
//! ```zig
//! var my_string = try String.init("foo");
//! defer my_string.deinit();
//!
//! my_string.toCapitalized();
//! ```
//!
//! ## Remarks
//! This is effectively a wrapper around Zig's `std.ArrayList(u8)` with some extra utility methods
//! to make string literal manipulation easier. Depending on your use case, this may be less
//! performant than simply manipulating a `[]const u8` yourself. Please use your own discretion and
//! remember to benchmark your code!

const std = @import("std");

const String = @This();

allocator: std.mem.Allocator,
string_buffer: std.ArrayList(u8),

/// Creates a String with the provided value.
///
/// ## Example
/// ```zig
/// var my_string = try String.init("Hello, world!");
/// ```
///
/// ## Remarks
/// To prevent memory leaks, Strings created with this method **must** be de-initialized. This can
/// be done by calling `deinit()` on the resulting String.
pub fn init(allocator: std.mem.Allocator, initial_value: []const u8) !String {
    var string_buffer = std.ArrayList(u8).init(allocator);
    try string_buffer.insertSlice(0, initial_value);
    return .{
        .allocator = allocator,
        .string_buffer = string_buffer,
    };
}

/// Creates an empty String with the provided capacity.
///
/// ## Example
/// ```zig
/// var my_string = try String.initFromCapacity(256);
/// ```
///
/// ## Remarks
/// To prevent memory leaks, Strings created with this method **must** be de-initialized. This can
/// be done by calling `deinit()` on the resulting String.
pub fn initFromCapacity(allocator: std.mem.Allocator, initial_capacity: usize) !String {
    const string_buffer = try std.ArrayList(u8).initCapacity(allocator, initial_capacity);
    return .{
        .allocator = allocator,
        .string_buffer = string_buffer,
    };
}

/// De-allocates memory used by the string and sets its pointer to `undefined`.
///
/// ## Example
/// ```zig
/// defer deinit(my_string);
/// ```
pub fn deinit(self: *String) void {
    self.string_buffer.deinit();
    self.* = undefined;
}

/// Gets the String's value as a string literal.
///
/// ## Example
/// ```zig
/// const my_string_value = my_string.asStringLiteral();
/// ```
///
/// ## Remarks
/// This function returns a copy of the String's value. To directly manipulate the String's value
/// without using one of the struct's methods, you should manipulate the `string_buffer` field.
pub fn asStringLiteral(self: *String) []const u8 {
    return self.string_buffer.items;
}

/// Gets the String's total capacity in bytes.
///
/// ## Example
/// ```zig
/// const my_string_capacity = my_string.capacity();
/// ```
pub fn capacity(self: *String) usize {
    return self.string_buffer.capacity;
}

/// Gets the character at the provided index, given the index is within range.
///
/// ## Example
/// ```zig
/// const my_string_capacity = my_string.capacity();
///
/// ## Remarks
/// When an index outside of the range of the String is provided, `null` will be returned. The
/// `index` parameter can be either a positive or negative integer. When `index` is negative, this
/// method will search the string in reverse order.
/// ```
pub fn charAt(self: *String, index: isize) ?u8 {
    const max_index: isize = @intCast(self.length() - 1);
    var clamped_index = index;

    // Counting from a negative number should start at 1 instead of 0, so we'll add the 1 back when
    // we calculate the index
    if (index < 0) {
        clamped_index = max_index + 1 + index;
    }

    if (clamped_index < 0 or clamped_index > max_index) {
        return null;
    }
    return self.string_buffer.items.ptr[@intCast(clamped_index)];
}

/// Determines whether the String matches the provided string literal.
///
/// ## Example
/// ```zig
/// const is_equal = my_string.compare("Hello, World!");
/// ```
pub fn compare(self: *String, value: []const u8) bool {
    return std.mem.eql(u8, self.asStringLiteral(), value);
}

/// Determines whether the String matches the provided String.
///
/// ## Example
/// ```zig
/// const is_equal = my_string.compareString(&my_other_string);
/// ```
pub fn compareString(self: *String, value: *String) bool {
    return self.compare(value.asStringLiteral());
}

/// Determines whether the String includes the provided string literal.
///
/// ## Example
/// ```zig
/// const is_found = my_string.contains("Hello");
/// ```
pub fn contains(self: *String, search: []const u8) bool {
    return self.find(search, 0) != null;
}

/// Determines whether the String includes the provided String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.containsString(&my_other_string);
/// ```
pub fn containsString(self: *String, search: *String) bool {
    return self.contains(search.asStringLiteral());
}

/// Determines whether the String ends with the provided string literal.
///
/// ## Example
/// ```zig
/// const is_found = my_string.endsWith("World!");
/// ```
pub fn endsWith(self: *String, search: []const u8) bool {
    return std.mem.endsWith(u8, self.asStringLiteral(), search);
}

/// Determines whether the String ends with the provided String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.endsWithString(&my_other_string);
/// ```
pub fn endsWithString(self: *String, value: *String) bool {
    return self.endsWith(value.asStringLiteral());
}

/// Gets the index of the last occurrence of the provided string literal in the String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.findLast("World!");
/// ```
///
/// ## Remarks
/// If the provided string literal is not found within the String, this method will return `null`.
pub fn findLast(self: *String, search: []const u8) ?usize {
    return std.mem.lastIndexOf(u8, self.string_buffer.items, search);
}

/// Gets the index of the last occurrence of the provided String in the String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.findLastString(&my_other_string);
/// ```
///
/// ## Remarks
/// If the provided String is not found within the String, this method will return `null`.
pub fn findLastString(self: *String, search: *String) ?usize {
    return self.findLast(search.asStringLiteral());
}

/// Gets the index of the first occurrence of the provided string literal in the String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.find("Hello");
/// ```
///
/// ## Remarks
/// If the provided string literal is not found within the String, this method will return `null`.
pub fn find(self: *String, search: []const u8, position: isize) ?usize {
    const max_position: isize = @intCast(self.length() - 1);
    var clamped_position = position;

    // Counting from a negative number should start at 1 instead of 0, so we'll add the 1 back when
    // we calculate the position
    if (position < 0) {
        clamped_position = max_position + 1 + position;
    }

    if (clamped_position < 0 or clamped_position > max_position) {
        return null;
    }
    return std.mem.indexOfPos(u8, self.string_buffer.items, @intCast(clamped_position), search);
}

/// Gets the index of the first occurrence of the provided String in the String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.findString(&my_other_string);
/// ```
///
/// ## Remarks
/// If the provided String is not found within the String, this method will return `null`.
pub fn findString(self: *String, search: *String, position: isize) ?usize {
    return self.find(search.asStringLiteral(), position);
}

/// Gets the length of the String.
///
/// ## Example
/// ```zig
/// const my_length = my_string.length();
/// ```
pub fn length(self: *String) usize {
    return self.string_buffer.items.len;
}

/// Resizes the String to the provided length, filling any empty space after the String's value
/// with the provided string literal.
///
/// ## Example
/// ```zig
/// try my_string.padEnd(32, "-");
/// ```
///
/// ## Remarks
/// The String will be truncated to the specified target length, regardless of the length of the
/// padding.
pub fn padEnd(self: *String, target_length: usize, padding: []const u8) !void {
    if (target_length <= self.length()) {
        return;
    }

    while (self.string_buffer.items.len < target_length) {
        const next_length = self.string_buffer.items.len + padding.len;
        if (next_length > target_length) {
            const max_slice_end = padding.len - (next_length - target_length);
            try self.string_buffer.appendSlice(padding[0..max_slice_end]);
            return;
        }
        try self.string_buffer.appendSlice(padding);
    }
}

/// Resizes the String to the provided length, filling any empty space after the String's value
/// with the provided String.
///
/// ## Example
/// ```zig
/// try my_string.padEndString(32, &my_other_string);
/// ```
///
/// ## Remarks
/// The String will be truncated to the specified target length, regardless of the length of the
/// padding.
pub fn padEndString(self: *String, target_length: usize, padding: *String) !void {
    try self.padEnd(target_length, padding.asStringLiteral());
}

/// Resizes the String to the provided length, filling any empty space before the String's value
/// with the provided string literal.
///
/// ## Example
/// ```zig
/// try my_string.padStart(32, "-");
/// ```
///
/// ## Remarks
/// The String will be truncated to the specified target length, regardless of the length of the
/// padding.
pub fn padStart(self: *String, target_length: usize, padding: []const u8) !void {
    if (target_length <= self.length()) {
        return;
    }

    var num_iterations: usize = 0;
    while (self.string_buffer.items.len < target_length) {
        const next_length = self.string_buffer.items.len + padding.len;
        const starting_index = num_iterations * padding.len;
        if (next_length > target_length) {
            const max_slice_end = padding.len - (next_length - target_length);
            try self.string_buffer.insertSlice(starting_index, padding[0..max_slice_end]);
            return;
        }
        try self.string_buffer.insertSlice(starting_index, padding);
        num_iterations += 1;
    }
}

/// Resizes the String to the provided length, filling any empty space before the String's value
/// with the provided String.
///
/// ## Example
/// ```zig
/// try my_string.padStartString(32, &my_other_string);
/// ```
///
/// ## Remarks
/// The String will be truncated to the specified target length, regardless of the length of the
/// padding.
pub fn padStartString(self: *String, target_length: usize, value: *String) !void {
    try self.padStart(target_length, value.asStringLiteral());
}

/// Updates the String's value, duplicating it by the provided count.
///
/// ## Example
/// ```zig
/// try my_string.repeat(3);
/// ```
pub fn repeat(self: *String, count: usize) !void {
    const initial_value = self.asStringLiteral();

    // The initial value always counts as the first iteration
    var completed_repetitions: usize = 1;
    while (completed_repetitions < count) {
        try self.string_buffer.appendSlice(initial_value);
        completed_repetitions += 1;
    }
}

/// Replaces all instances of the provided string literal within the String.
///
/// ## Example
/// ```zig
/// try my_string.replaceAll("World", "Manatee");
/// ```
pub fn replaceAll(self: *String, search: []const u8, replacement: []const u8) !usize {
    const new_size = std.mem.replacementSize(u8, self.asStringLiteral(), search, replacement);
    const output = try self.allocator.alloc(u8, new_size);
    defer self.allocator.free(output);

    const num_replacements = std.mem.replace(u8, self.asStringLiteral(), search, replacement, output);
    try self.string_buffer.replaceRange(0, self.length(), output);

    return num_replacements;
}

/// Replaces all instances of the provided String within the String.
///
/// ## Example
/// ```zig
/// try my_string.replaceAllString(&my_search_string, &my_replacement_string);
/// ```
pub fn replaceAllString(self: *String, search: *String, replacement: *String) !usize {
    return try self.replaceAll(search.asStringLiteral(), replacement.asStringLiteral());
}

/// Creates an `ArrayList` of Strings delimited by the provided string literal.
///
/// ## Example
/// ```zig
/// const my_strings = try my_string.split(" ");
///
/// // Remember to de-initialize!
/// defer my_strings.deinit();
///
/// defer for (my_strings.items) |*split_string| {
///     split_string.deinit();
/// };
/// ```
///
/// ## Remarks
/// To prevent memory leaks, the `ArrayList` created with this method **must** be de-initialized.
/// This can be done by calling `deinit()` on the resulting `ArrayList`. Remember to de-initialize
/// each String within the `ArrayList` as well. See the above example for complete usage.
pub fn split(self: *String, delimiter: []const u8) !std.ArrayList(String) {
    var split_strings = std.ArrayList(String).init(self.allocator);

    var split_slices = std.mem.splitSequence(u8, self.asStringLiteral(), delimiter);
    while (split_slices.next()) |slice| {
        const new_string = try String.init(self.allocator, slice);
        try split_strings.append(new_string);
    }

    return split_strings;
}

/// Creates an `ArrayList` of Strings delimited by the provided String.
///
/// ## Example
/// ```zig
/// const my_strings = try my_string.splitString(&my_delimiter);
///
/// // Remember to de-initialize!
/// defer my_strings.deinit();
///
/// defer for (my_strings.items) |*split_string| {
///     split_string.deinit();
/// };
/// ```
///
/// ## Remarks
/// To prevent memory leaks, the `ArrayList` created with this method **must** be de-initialized.
/// This can be done by calling `deinit()` on the resulting `ArrayList`. Remember to de-initialize
/// each String within the `ArrayList` as well. See the above example for complete usage.
pub fn splitString(self: *String, delimiter: *String) !std.ArrayList(String) {
    return try self.split(delimiter.asStringLiteral());
}

/// Determines whether the String starts with the provided string literal.
///
/// ## Example
/// ```zig
/// const is_found = my_string.startsWith("Hello");
/// ```
pub fn startsWith(self: *String, search: []const u8) bool {
    return std.mem.startsWith(u8, self.asStringLiteral(), search);
}

/// Determines whether the String starts with the provided String.
///
/// ## Example
/// ```zig
/// const is_found = my_string.startsWithString(&my_other_string);
/// ```
pub fn startsWithString(self: *String, search: *String) bool {
    return self.startsWith(search.asStringLiteral());
}

/// Creates a new String based off of the String's value and the provided start and end indices.
///
/// ## Example
/// ```zig
/// const sub_string = try my_string.substring(0, 5);
/// ```
///
/// ## Remarks
/// To prevent memory leaks, Strings created with this method **must** be de-initialized. This can
/// be done by calling `deinit()` on the resulting String.
pub fn substring(self: *String, index_start: usize, index_end: usize) !String {
    const substring_value = self.asStringLiteral()[index_start..index_end];
    return try String.init(self.allocator, substring_value);
}

/// Converts the first character in the String to its ASCII uppercase value.
///
/// ## Example
/// ```zig
/// my_string.toCapitalized();
/// ```
pub fn toCapitalized(self: *String) void {
    if (self.string_buffer.items.len < 1) {
        return;
    }
    self.string_buffer.items[0] = std.ascii.toUpper(self.string_buffer.items[0]);
}

/// Converts all characters in the String to their ASCII lowercase values.
///
/// ## Example
/// ```zig
/// my_string.toLowerCase();
/// ```
pub fn toLowerCase(self: *String) void {
    _ = std.ascii.lowerString(self.string_buffer.items, self.string_buffer.items);
}

/// Converts all characters in the String to their ASCII uppercase values.
///
/// ## Example
/// ```zig
/// my_string.toUpperCase();
/// ```
pub fn toUpperCase(self: *String) void {
    _ = std.ascii.upperString(self.string_buffer.items, self.string_buffer.items);
}

/// Removes all white space from both sides of the String.
///
/// ## Example
/// ```zig
/// try my_string.trim();
/// ```
pub fn trim(self: *String) !void {
    const trimmed_value = std.mem.trim(u8, self.asStringLiteral(), &[_]u8{' '});
    for (trimmed_value, 0..trimmed_value.len) |char, idx| {
        self.string_buffer.items[idx] = char;
    }
    try self.string_buffer.resize(trimmed_value.len);
}

/// Removes all white space from the end of the String.
///
/// ## Example
/// ```zig
/// try my_string.trimEnd();
/// ```
pub fn trimEnd(self: *String) !void {
    const trimmed_value = std.mem.trimEnd(u8, self.asStringLiteral(), &[_]u8{' '});
    for (trimmed_value, 0..trimmed_value.len) |char, idx| {
        self.string_buffer.items[idx] = char;
    }
    try self.string_buffer.resize(trimmed_value.len);
}

/// Removes all white space from the start of the String.
///
/// ## Example
/// ```zig
/// try my_string.trimStart();
/// ```
pub fn trimStart(self: *String) !void {
    const trimmed_value = std.mem.trimStart(u8, self.asStringLiteral(), &[_]u8{' '});
    for (trimmed_value, 0..trimmed_value.len) |char, idx| {
        self.string_buffer.items[idx] = char;
    }
    try self.string_buffer.resize(trimmed_value.len);
}

test init {
    // It should create a String struct with a string_buffer containing provided UTF-8 slice
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();
    try std.testing.expect(my_string.compare("foo"));
}

test initFromCapacity {
    // It should create a String struct with an empty string buffer and a capacity equal to the provided usize
    var my_string = try String.initFromCapacity(std.testing.allocator, 5);
    defer my_string.deinit();
    try std.testing.expect(my_string.capacity() == 5);
    try std.testing.expect(my_string.compare(""));
}

test deinit {
    // It should not leak memory if deinit is called.
    var my_string = try String.init(std.testing.allocator, "foo");
    // I'd like to assert that this is true, however there's currently an open Zig issue where
    // calling std.log.err (which detectLeaks happens to do) causes tests to fail. The below line
    // can be uncommented once that issue is resolved, but I'm not sure when that'll happen. See:
    // https://github.com/ziglang/zig/issues/5738
    // try std.testing.expect(std.testing.allocator_instance.detectLeaks() == true);
    my_string.deinit();
    try std.testing.expect(std.testing.allocator_instance.detectLeaks() == false);
}

test asStringLiteral {
    // It should return a string literal representing the string's internal buffer's value
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();
    try std.testing.expect(std.mem.eql(u8, my_string.asStringLiteral(), "foo"));
}

test capacity {
    // It should return the string's internal buffer's capacity
    var my_string = try String.initFromCapacity(std.testing.allocator, 10);
    defer my_string.deinit();
    try std.testing.expect(my_string.capacity() == 10);
}

test charAt {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    // It should return the character with the given index counting from the beginning if the index
    // is positive
    try std.testing.expect(my_string.charAt(0) == 'f');
    try std.testing.expect(my_string.charAt(1) == 'o');

    // It should return the character with the given index counting from the end if the index is
    // negative
    try std.testing.expect(my_string.charAt(-3) == 'f');
    try std.testing.expect(my_string.charAt(-2) == 'o');

    // It should return null if the index is out of bounds
    try std.testing.expect(my_string.charAt(4) == null);
    try std.testing.expect(my_string.charAt(-4) == null);
}

test compare {
    // It should return true if the string's internal buffer's value matches the provided string
    // literal
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();
    try std.testing.expect(my_string.compare("foo"));
    try std.testing.expect(my_string.compare("bar") == false);
}

test compareString {
    // It should return true if the string's internal buffer's value matches the provided string's
    // internal value
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();
    var my_other_string = try String.init(std.testing.allocator, "bar");
    defer my_other_string.deinit();
    var my_third_string = try String.init(std.testing.allocator, "foo");
    defer my_third_string.deinit();
    try std.testing.expect(my_string.compareString(&my_string));
    try std.testing.expect(my_string.compareString(&my_other_string) == false);
    try std.testing.expect(my_string.compareString(&my_third_string));
}

test contains {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    // It should return true if string literal is found within the String's value
    try std.testing.expect(my_string.contains("fo"));
    try std.testing.expect(my_string.contains("o"));

    // It should return false if string literal is not found within the String's value
    try std.testing.expect(my_string.contains("b") == false);
}

test containsString {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "fo");
    defer first_string.deinit();

    var second_string = try String.init(std.testing.allocator, "o");
    defer second_string.deinit();

    var third_string = try String.init(std.testing.allocator, "b");
    defer third_string.deinit();

    // It should return true if String is found within the String's value
    try std.testing.expect(my_string.containsString(&first_string));
    try std.testing.expect(my_string.containsString(&second_string));

    // It should return false if String is not found within the String's value
    try std.testing.expect(my_string.containsString(&third_string) == false);
}

test endsWith {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    try std.testing.expect(my_string.endsWith("f") == false);
    try std.testing.expect(my_string.endsWith("oo"));
}

test endsWithString {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "f");
    defer first_string.deinit();
    var second_string = try String.init(std.testing.allocator, "oo");
    defer second_string.deinit();

    try std.testing.expect(my_string.endsWithString(&first_string) == false);
    try std.testing.expect(my_string.endsWithString(&second_string));
}

test find {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    // It should return the index of the string literal's first character if found in the String's
    // value
    try std.testing.expect(my_string.find("fo", 0) == 0);
    try std.testing.expect(my_string.find("o", 0) == 1);
    try std.testing.expect(my_string.find("o", 2) == 2);
    try std.testing.expect(my_string.find("f", -3) == 0);

    // It should return null if string literal is not found within the String's value
    try std.testing.expect(my_string.find("b", 0) == null);
    try std.testing.expect(my_string.find("f", 3) == null);
    try std.testing.expect(my_string.find("f", -4) == null);
}

test findString {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "fo");
    defer first_string.deinit();

    var second_string = try String.init(std.testing.allocator, "o");
    defer second_string.deinit();

    var third_string = try String.init(std.testing.allocator, "b");
    defer third_string.deinit();

    // It should return the index of the String's first character if found in the String's value
    try std.testing.expect(my_string.findString(&first_string, 0) == 0);
    try std.testing.expect(my_string.findString(&second_string, 0) == 1);
    try std.testing.expect(my_string.findString(&second_string, 2) == 2);
    try std.testing.expect(my_string.findString(&first_string, -3) == 0);

    // It should return null if String is not found within the String's value
    try std.testing.expect(my_string.findString(&third_string, 0) == null);
    try std.testing.expect(my_string.findString(&first_string, 3) == null);
    try std.testing.expect(my_string.findString(&first_string, -4) == null);
}

test findLast {
    var my_string = try String.init(std.testing.allocator, "foo_foo_Foo");
    defer my_string.deinit();

    // It should return the last index of the string literal's first character if found in the
    // String's value
    try std.testing.expect(my_string.findLast("fo") == 4);

    // It should return null if string literal is not found within the String's value
    try std.testing.expect(my_string.findLast("b") == null);
}

test findLastString {
    var my_string = try String.init(std.testing.allocator, "foo_foo_Foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "fo");
    defer first_string.deinit();

    var second_string = try String.init(std.testing.allocator, "b");
    defer second_string.deinit();

    // It should return the last index of the String's first character if found in the String's
    // value
    try std.testing.expect(my_string.findLastString(&first_string) == 4);

    // It should return null if String is not found within the String's value
    try std.testing.expect(my_string.findLastString(&second_string) == null);
}

test length {
    // It should return the string's internal buffer's length
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();
    try std.testing.expect(my_string.length() == 3);
}

test padEnd {
    var my_string = try String.init(std.testing.allocator, "foo_");
    defer my_string.deinit();

    try my_string.padEnd(11, "bar_");
    try std.testing.expect(my_string.compare("foo_bar_bar"));
}

test padEndString {
    var my_string = try String.init(std.testing.allocator, "foo_");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "bar_");
    defer first_string.deinit();

    try my_string.padEndString(11, &first_string);
    try std.testing.expect(my_string.compare("foo_bar_bar"));
}

test padStart {
    var my_string = try String.init(std.testing.allocator, "_foo");
    defer my_string.deinit();

    try my_string.padStart(11, "bar_");
    try std.testing.expect(my_string.compare("bar_bar_foo"));
}

test padStartString {
    var my_string = try String.init(std.testing.allocator, "_foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "bar_");
    defer first_string.deinit();

    try my_string.padStartString(11, &first_string);
    try std.testing.expect(my_string.compare("bar_bar_foo"));
}

test repeat {
    var my_string = try String.init(std.testing.allocator, "foo_");
    defer my_string.deinit();

    try my_string.repeat(4);
    try std.testing.expect(my_string.compare("foo_foo_foo_foo_"));
}

test replaceAll {
    var my_string = try String.init(std.testing.allocator, "foo_bar_foo");
    defer my_string.deinit();

    // It should replace all instances of the provided string literal with the new string literal
    const num_replacements = try my_string.replaceAll("foo", "quux");
    try std.testing.expect(my_string.compare("quux_bar_quux"));
    try std.testing.expect(num_replacements == 2);
}

test replaceAllString {
    var my_string = try String.init(std.testing.allocator, "foo_bar_foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "foo");
    defer first_string.deinit();

    var second_string = try String.init(std.testing.allocator, "quux");
    defer second_string.deinit();

    // It should replace all instances of the provided string literal with the new string literal
    const num_replacements = try my_string.replaceAllString(&first_string, &second_string);
    try std.testing.expect(my_string.compare("quux_bar_quux"));
    try std.testing.expect(num_replacements == 2);
}

test split {
    var my_string = try String.init(std.testing.allocator, "foo::bar::baz:qux");
    defer my_string.deinit();

    var split_strings = try my_string.split("::");
    defer split_strings.deinit();

    defer for (split_strings.items) |*split_string| {
        split_string.deinit();
    };

    try std.testing.expect(split_strings.items.len == 3);
    try std.testing.expect(split_strings.items[0].compare("foo"));
    try std.testing.expect(split_strings.items[1].compare("bar"));
    try std.testing.expect(split_strings.items[2].compare("baz:qux"));
}

test splitString {
    var my_string = try String.init(std.testing.allocator, "foo::bar::baz:qux");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "::");
    defer first_string.deinit();

    var split_strings = try my_string.splitString(&first_string);
    defer split_strings.deinit();

    defer for (split_strings.items) |*split_string| {
        split_string.deinit();
    };

    try std.testing.expect(split_strings.items.len == 3);
    try std.testing.expect(split_strings.items[0].compare("foo"));
    try std.testing.expect(split_strings.items[1].compare("bar"));
    try std.testing.expect(split_strings.items[2].compare("baz:qux"));
}

test startsWith {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    try std.testing.expect(my_string.startsWith("fo"));
    try std.testing.expect(my_string.startsWith("o") == false);
}

test startsWithString {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    var first_string = try String.init(std.testing.allocator, "fo");
    defer first_string.deinit();
    var second_string = try String.init(std.testing.allocator, "o");
    defer second_string.deinit();

    try std.testing.expect(my_string.startsWithString(&first_string));
    try std.testing.expect(my_string.startsWithString(&second_string) == false);
}

test substring {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    var my_substring = try my_string.substring(0, 2);
    defer my_substring.deinit();
    try std.testing.expect(my_substring.compare("fo"));
}

test toCapitalized {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    // It should convert the first ASCII character to its upper case form
    my_string.toCapitalized();
    try std.testing.expect(my_string.compare("Foo"));
    try std.testing.expect(my_string.length() == 3);
}

test toLowerCase {
    var my_string = try String.init(std.testing.allocator, "FOO");
    defer my_string.deinit();

    // It should convert all ASCII characters to their lower case form
    my_string.toLowerCase();
    try std.testing.expect(my_string.compare("foo"));
    try std.testing.expect(my_string.length() == 3);
}

test toUpperCase {
    var my_string = try String.init(std.testing.allocator, "foo");
    defer my_string.deinit();

    // It should convert all ASCII characters to their upper case form
    my_string.toUpperCase();
    try std.testing.expect(my_string.compare("FOO"));
    try std.testing.expect(my_string.length() == 3);
}

test trim {
    var my_string = try String.init(std.testing.allocator, "        foo        ");
    defer my_string.deinit();

    // It should remove all white space from the both sides of the string
    try my_string.trim();
    try std.testing.expect(my_string.compare("foo"));
    try std.testing.expect(my_string.length() == 3);
}

test trimEnd {
    var my_string = try String.init(std.testing.allocator, "foo        ");
    defer my_string.deinit();

    // It should remove all white space from the end of the string
    try my_string.trimEnd();
    try std.testing.expect(my_string.compare("foo"));
    try std.testing.expect(my_string.length() == 3);
}

test trimStart {
    var my_string = try String.init(std.testing.allocator, "        foo");
    defer my_string.deinit();

    // It should remove all white space from the beginning of the string
    try my_string.trimStart();
    try std.testing.expect(my_string.compare("foo"));
    try std.testing.expect(my_string.length() == 3);
}
