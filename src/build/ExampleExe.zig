//! A struct that creates and configures an exe used to run zig-string's examples.

const std = @import("std");
const BuildConfig = @import("BuildConfig.zig");
const ZigStringModule = @import("ZigStringModule.zig");

const ExampleExe = @This();

/// The executable for all zig-string examples.
exe: *std.Build.Step.Compile,
/// The install step for the zig-string examples executable.
install_step: *std.Build.Step.InstallArtifact,
/// The name of the example to build. This should be 1:1 with a file name in the `examples` dir
/// with the `.zig` extension omitted.
name: []const u8,

/// Initializes a new ExampleExe struct with the provided name, BuildConfig, and ZigStringModule.
///
/// This also adds the provided ZigStringModule as an import with the alias "string" to the newly
/// initialized exe.
pub fn init(b: *std.Build, build_config: *const BuildConfig, module: *const ZigStringModule, name: []const u8) ExampleExe {
    const examples_exe = b.addExecutable(.{
        .name = name,
        .optimize = build_config.optimize,
        .root_source_file = b.path(b.pathJoin(&.{ "examples", name, "main.zig" })),
        .target = build_config.target,
    });
    examples_exe.root_module.addImport("string", module.module);

    const examples_install_step = b.addInstallArtifact(examples_exe, .{});

    return ExampleExe{
        .exe = examples_exe,
        .install_step = examples_install_step,
        .name = name,
    };
}

/// Adds a build command and step, allowing the exe to be run via "zig build run-example".
pub fn addRunStep(self: *const ExampleExe) !void {
    const b = self.exe.step.owner;
    const run_examples_cmd = b.addRunArtifact(self.exe);
    run_examples_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_examples_cmd.addArgs(args);
    }

    const step_name = try std.fmt.allocPrint(b.allocator, "example-{s}", .{self.name});
    const step_description = try std.fmt.allocPrint(b.allocator, "Run example with name \"{s}\"", .{self.name});

    const run_example_step = b.step(step_name, step_description);
    run_example_step.dependOn(&run_examples_cmd.step);
}

/// Adds the examples exe to the build's install target.
pub fn install(self: *const ExampleExe) void {
    const b = self.install_step.step.owner;
    b.installArtifact(self.exe);
}
