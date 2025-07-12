const std = @import("std");
const build_module = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    // Build Setup
    const build_config = build_module.BuildConfig.init(b);

    // Module Setup
    const zig_string_module = build_module.ZigStringModule.init(b, &build_config);

    // Examples Setup
    const basic_example_exe = build_module.ExampleExe.init(b, &build_config, &zig_string_module, "basic");

    // Test Setup
    const tests_exe = build_module.TestsExe.init(b, &build_config, &zig_string_module);

    // Check Step
    const check_step = b.step("check", "Check if the project compiles");
    basic_example_exe.addToCheckStep(check_step); // Ensure examples compile
    tests_exe.addToCheckStep(check_step); // Required since example doesn't touch all code paths

    // Install Step
    try basic_example_exe.addToInstallStep();

    // Run Example Steps
    try basic_example_exe.addRunExampleStep();

    // Test Step
    tests_exe.addTestStep();
}
