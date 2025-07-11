const std = @import("std");
const build_module = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    // Build Setup
    const build_config = build_module.BuildConfig.init(b);

    // Module
    const zig_string_module = build_module.ZigStringModule.init(b, &build_config);

    // Test Step
    const tests_exe = build_module.TestsExe.init(b, &build_config, &zig_string_module);
    tests_exe.addTestStep();

    // Example Steps
    const basic_example_exe = build_module.ExampleExe.init(b, &build_config, &zig_string_module, "basic");
    basic_example_exe.install();
    try basic_example_exe.addRunStep();

    // Check Step
    const check_step = b.step("check", "Check if the project compiles");
    basic_example_exe.addToCheckStep(check_step); // Ensure examples compile
    tests_exe.addToCheckStep(check_step); // Required since example doesn't touch all code paths
}
