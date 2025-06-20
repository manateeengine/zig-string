//! A struct that creates and configures an exe used to run zig-string's tests.

const std = @import("std");
const BuildConfig = @import("BuildConfig.zig");
const ZigStringModule = @import("ZigStringModule.zig");

const TestsExe = @This();

/// The executable for all zig-string tests.
exe: *std.Build.Step.Compile,

/// Initializes a new TestsExe struct with the provided BuildConfig and ZigStringModule.
pub fn init(b: *std.Build, config: *const BuildConfig, module: *const ZigStringModule) TestsExe {
    const tests_module = b.createModule(.{
        .optimize = config.optimize,
        .root_source_file = module.module.root_source_file,
        .strip = false,
        .target = config.target,
    });
    const tests_exe = b.addTest(.{
        .name = "zig-string-tests",
        .root_module = tests_module,
    });

    return TestsExe{
        .exe = tests_exe,
    };
}

/// Adds a build command and step, allowing the exe to be run via "zig build test".
pub fn addRunStep(self: *const TestsExe) void {
    const b = self.exe.step.owner;
    const run_tests_cmd = b.addRunArtifact(self.exe);
    run_tests_cmd.step.dependOn(b.getInstallStep());

    const run_tests_step = b.step("test", "Run unit tests");
    run_tests_step.dependOn(&run_tests_cmd.step);
}
