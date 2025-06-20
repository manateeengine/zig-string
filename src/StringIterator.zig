//! An iterator struct to be used by Strings.
//!
//! ## Remarks
//! Weirdly, `ArrayList` doesn't have a builtin iterator, so we have to build a custom one.

const std = @import("std");
const String = @import("String.zig");

const StringIterator = @This();

string: *String,
index: usize,

pub fn first(self: *StringIterator) []const u8 {
    std.debug.assert(self.index == 0);
    return self.next().?;
}

pub fn next(self: *StringIterator) ?[]const u8 {
    if (self.index == self.string.length()) {
        return null;
    }
    const current_index = self.index;
    const next_index = self.index + 1;
    self.index = next_index;
    return self.string.string_buffer.items[current_index..next_index];
}

pub fn peek(self: *StringIterator) ?[]const u8 {
    if (self.index == self.string.length()) {
        return null;
    }
    const current_index = self.index;
    const next_index = self.index + 1;
    return self.string.string_buffer.items[current_index..next_index];
}

pub fn rest(self: *StringIterator) []const u8 {
    return self.string.string_buffer.items[self.index..self.string.length()];
}

pub fn reset(self: *StringIterator) void {
    self.index = 0;
}
