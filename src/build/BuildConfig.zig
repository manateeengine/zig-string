//! A struct that provides Standardized build configuration to all components of zig-string.

const std = @import("std");

const BuildConfig = @This();

/// Zig build system optimization options.
optimize: std.builtin.OptimizeMode,
/// Zig build system target options.
target: std.Build.ResolvedTarget,

/// Initializes a new BuildConfig struct with Zig's standard optimization and target options.
pub fn init(b: *std.Build) BuildConfig {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    return BuildConfig{
        .optimize = optimize,
        .target = target,
    };
}
