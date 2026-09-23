function basicTupleAssignmentNegative() returns string {
    [int, string, boolean...] t = [1, "s", true, 2, false, "s"]; // @error // @error
    [boolean...] t1 = [1, true, 2, "s", true]; // @error // @error // @error
    return t.toString();
}

function testTupleInUnionReturn() returns [string, int, boolean]|string {
    return ["", 5, true, false]; // @error
}

function testTupleToTupleAssignmentWithIncompatibleMemCount() {
    [int] i = [1];
    [int, int, string...] j = i; // @error

    [int, float, string...] k = [2, 3];
    [int, float, string, string...] l = k; // @error
}

function testInvalidTupleAssignmentWithRestDescriptors() {
    [int, (string|int)...] a = [1, 10, "foo"];

    [int, string|int, string|int...] b = a; // @error
    [int, string...] c = a; // @error
    [int] d = a; // @error

    int[3] e = [1, 2, 3];

    [int, int, int, int, int...] f = e; // @error
    [int, string...] g = e; // @error
    [string, string, string, string] h = e; // @error
}
