function testAssigningValuesToFinalVars() {
    [string, float] t1 = ["hello", 1.0];
    final var [s1, f1] = t1; // @error
    [s1, f1] = t1; // @error

    [string?, [float, boolean], int...] t2 = ["hi", [1.0, true], 1, 2];
    final [string?, [float, boolean], int...] [s2, [f2, b2], ...n2] = t2; // @error
    [s2, [f2, b2], ...n2] = t2; // @error
    s2 = "hello"; // @error
    [f2, b2] = [2.0, false]; // @error
}
