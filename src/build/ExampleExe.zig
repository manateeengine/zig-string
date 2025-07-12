//! A struct that creates and configures an exe used to run a zig-string's example.

const std = @import("std");
const BuildConfig = @import("BuildConfig.zig");
const ZigStringModule = @import("ZigStringModule.zig");

const ExampleExe = @This();

/// The executable for the examples.
exe: *std.Build.Step.Compile,
/// The name of the example to build. This should be 1:1 with a file name in the `examples` dir
/// with the `.zig` extension omitted.
name: []const u8,

/// Initializes a new ExampleExe struct with the provided name, BuildConfig, and ZigStringModule.
///
/// ## Remarks
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

    return ExampleExe{
        .exe = examples_exe,
        .name = name,
    };
}

/// Adds a run command and step, allowing the exe to be run via "zig build example-{name}".
pub fn addRunExampleStep(self: *const ExampleExe) !void {
    const b = self.exe.step.owner;
    const run_example_cmd = b.addRunArtifact(self.exe);
    run_example_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_example_cmd.addArgs(args);
    }

    const step_name = try std.fmt.allocPrint(b.allocator, "run-example-{s}", .{self.name});
    const step_description = try std.fmt.allocPrint(b.allocator, "Run example in \"./examples/{s}/main.zig\"", .{self.name});

    const run_example_step = b.step(step_name, step_description);
    run_example_step.dependOn(&run_example_cmd.step);
}

/// Adds the example to the build's check step.
pub fn addToCheckStep(self: *const ExampleExe, check_step: *std.Build.Step) void {
    check_step.dependOn(&self.exe.step);
}

/// Adds the example to the build's install step.
pub fn addToInstallStep(self: *const ExampleExe) !void {
    const b = self.exe.step.owner;
    b.installArtifact(self.exe);
}
