function duplicateNamedParams(int a, float b, string c = "John", string c = "Doe", int... z) { // @error
}

function functionAnyRestParam(any... z) returns any[] {
    return z;
}

function testInvokeFuncWithAnyRestParam1() returns any[] {
    int[] a = [10, 20, 30];
    return functionAnyRestParam(...a);
}

function foo(string a = "John", string b = "Doe") {
}

function funcInvocWithDuplicateNamedArgs() {
    foo(a = "Alex", a = "Bob"); // @error
}

function funcInvocWithNonExistingNamedArgs() {
    foo(a = "Alex", c = "Bob"); // @error
}

function bar(int a, string b = "John", int... z) {
}

function funcInvocWithInvalidIndividualRestArgWithVarArg() {
    int[] array = [1, 2, 3];
    bar(5, "Alex", 6.0, ...array); // @error
}

function getIntArrayAndStringTuple() returns [int[], string] {
    return [[1, 2, 3, 4], "hello"];
}

function funcWithDefaultParamIncompatibleType(json j = xml `{"name":"John"}`) returns json { // @error
    return j;
}

function funcWithComplexDefaultParamExpr(json j = {"name": "John"}) returns json {
    return j;
}

function functionWithOnlyPositionalParams(int a, boolean b, string c) returns int {
    return a;
}

function functionWithOnlyDefaultableParams(int a = 1, boolean b = true, string c = "string") returns int {
    return a;
}

function testCallingFunctionWithOnlyPositionalParams() {
    _ = functionWithOnlyPositionalParams(); // @error @error @error
    _ = functionWithOnlyPositionalParams(1, true); // @error
    _ = functionWithOnlyPositionalParams(1, "c"); // @error @error
    _ = functionWithOnlyPositionalParams(a = 1, c = "c"); // @error
    _ = functionWithOnlyPositionalParams(1, true, "c", "d"); // @error
    _ = functionWithOnlyPositionalParams(1, true, "c", c = true); // @error
    _ = functionWithOnlyPositionalParams(1, a = 2, b = true, c = "c"); // @error @error @error
}

function testCallingFunctionWithOnlyDefaultableParams() {
    _ = functionWithOnlyDefaultableParams(1, true);
    _ = functionWithOnlyDefaultableParams(1, "c"); // @error
    _ = functionWithOnlyDefaultableParams(a = 1, c = "c");
    _ = functionWithOnlyDefaultableParams(1, true, "c", "d"); // @error
    _ = functionWithOnlyDefaultableParams(1, true, "c", c = true); // @error
    _ = functionWithOnlyDefaultableParams(1, a = 2, b = true, c = "c"); // @error @error
}

function positionalAfterDefaultable(int x, string y = "s", boolean b) { // @error
}

function normalFunction(int x, string y, float f = 1.1, boolean... b) {
}

function restArgTest() {
    boolean[] bArray = [true, false, true];
    normalFunction(1, "A", 2.2, bArray); // @error
    normalFunction(1, "A", 2.2, ...bArray);
    normalFunction(1, "A", bArray); // @error
    normalFunction(1, "A", ...bArray); // @error
    normalFunction(x = 1, y = "A", f = 2.2, bArray); // @error @error
    normalFunction(x = 1, y = "A", f = 2.2, ...bArray); // @error
}

function functionWithNoRestParam(int x, string y, float f = 1.1, boolean b = true) {
}

function requiredParamTest() {
    functionWithNoRestParam(100); // @error
    functionWithNoRestParam("string"); // @error @error
    functionWithNoRestParam("string", 100); // @error @error
    functionWithNoRestParam(100, "string");
    functionWithNoRestParam(100, "string", 2.2);
    functionWithNoRestParam(100, "string", false); // @error
    functionWithNoRestParam(100, "string", 2.2, false);
    functionWithNoRestParam(100, "string", false, 2.2); // @error @error
    functionWithNoRestParam(); // @error @error
    functionWithNoRestParam(f = 1.2); // @error @error
    functionWithNoRestParam(b = false, f = 1.2); // @error @error
}

function testDefaultExprEvaluation() {
    functionWithNoRestParam(1, "2", f = getFloat());
    functionWithNoRestParam(1, f = getFloat()); // @error
    functionWithNoRestParam(1, f = getFloat(2.2)); // @error @error
}

function getFloat() returns float {
    return 25.0;
}

function testForwardReferencingParams1(int x, int y = z, int z = 12) { } // @error
function testForwardReferencingParams2(float y = z * 2, float z = getFloat()) { } // @error

class Foo {
    function testForwardReferencingParams1(int x, int y = z, int z = 12) { } // @error
    function testForwardReferencingParams2(float y = z * 2, float z = getFloat()) { } // @error
}

function foobar(string ') { // @error
}

function returnAnyFunction1() returns function {
    return function () returns int {
        return 1;
    };
}

function returnAnyFunction2() returns function {
    return function (int i) returns boolean {
        return true;
    };
}

function acceptFunction1(function () returns int fn) {
}

function acceptFunction2(function (int i) returns boolean fn) {
}

function testAnyFunctionReturn() {
    var f1 = returnAnyFunction1();
    acceptFunction1(f1); // @error
    var f2 = returnAnyFunction2();
    acceptFunction2(f2); // @error
    var f3 = returnAnyFunction2();
    int[] arr = [1, 2, 3];
    _ = arr.filter(f3); // @error
}
