var _ = error(""); // @error
error _ = "not an error"; // @error
error _ = error("Custom error"); // @error
int _ = 100;

function testVarNegativeCases() returns int {
    string _ = 100; // @error
    var _ = 200;
    error _ = error("Custom error"); // @error
    var _ = error("Custom error"); // @error
    error _ = "not an error"; // @error
    return 0;
}
