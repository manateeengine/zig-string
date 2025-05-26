//! A struct that creates and configures a Zig module for zig-string.

const std = @import("std");
const BuildConfig = @import("BuildConfig.zig");

const ZigStringModule = @This();

/// The primary zig-string module
module: *std.Build.Module,

/// Initializes a new ZigStringModule struct with the provided BuildConfig.
pub fn init(b: *std.Build, build_config: *const BuildConfig) ZigStringModule {
    const module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .optimize = build_config.optimize,
        .target = build_config.target,
    });

    return ZigStringModule{
        .module = module,
    };
}
