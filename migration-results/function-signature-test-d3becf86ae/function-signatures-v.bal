import ballerina/io;

const ASSERTION_ERROR_REASON = "AssertionError";

function functionWithAllTypesParams(int a, float b, string c = "John", int d = 5, string e = "Doe", int... z)
        returns [int, float, string, int, string, int[]] {
    return [a, b, c, d, e, z];
}

function testInvokeFunctionInOrder1() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0, c = "Alex", d = 30, e = "Bob");
}

function testInvokeFunctionInOrder2() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0, c = "Alex", d = 30, e = "Bob");
}

function testInvokeFunctionInMixOrder1() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(e = "Bob", b = 20.0, c = "Alex", a = 10, d = 30);
}

function testInvokeFunctionInMixOrder2() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, c = "Alex", e = "Bob", d = 30, b = 20.0);
}

function testInvokeFunctionWithoutSomeNamedArgs() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0, c = "Alex");
}

function testInvokeFunctionWithRequiredArgsOnly() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0);
}

function testInvokeFunctionWithAllParamsAndRestArgs() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0, "John1", 6, "Doe1", 40, 50, 60);
}

function funcInvocAsRestArgs() returns [int, float, string, int, string, int[]] {
    return functionWithAllTypesParams(10, 20.0, "Alex", 30, "Bob", ...getIntArray());
}

function getIntArray() returns int[] {
    return [1, 2, 3, 4];
}

function functionWithoutRestParams(int a, float b, string c = "John", int d = 5, string e = "Doe")
        returns [int, float, string, int, string] {
    return [a, b, c, d, e];
}

function testInvokeFuncWithoutRestParamsAndMissingDefaultableParam() returns [int, float, string, int, string] {
    return functionWithoutRestParams(10, b = 20.0, d = 30, e = "Bob");
}

function functionWithOnlyNamedParams(int a = 5, float b = 6.0, string c = "John", int d = 7, string e = "Doe")
        returns [int, float, string, int, string] {
    return [a, b, c, d, e];
}

function testInvokeFuncWithOnlyNamedParams1() returns [int, float, string, int, string] {
    return functionWithOnlyNamedParams(b = 20.0, e = "Bob", d = 30, a = 10, c = "Alex");
}

function testInvokeFuncWithOnlyNamedParams2() returns [int, float, string, int, string] {
    return functionWithOnlyNamedParams(e = "Bob", d = 30, c = "Alex");
}

function testInvokeFuncWithOnlyNamedParams3() returns [int, float, string, int, string] {
    return functionWithOnlyNamedParams();
}

function functionWithOnlyRestParam(int... z) returns int[] {
    return z;
}

function testInvokeFuncWithOnlyRestParam1() returns int[] {
    return functionWithOnlyRestParam();
}

function testInvokeFuncWithOnlyRestParam2() returns int[] {
    return functionWithOnlyRestParam(10, 20, 30);
}

function testInvokeFuncWithOnlyRestParam3() returns int[] {
    int[] a = [10, 20, 30];
    return functionWithOnlyRestParam(...a);
}

function functionAnyRestParam(any... z) returns any[] {
    return z;
}

function testInvokeFuncWithAnyRestParam1() returns any[] {
    int[] a = [10, 20, 30];
    json j = {"name": "John"};
    return functionAnyRestParam(a, j);
}

function funcWithUnionTypedDefaultParam(string|int? s = "John") returns string|int? {
    return s;
}

function testFuncWithUnionTypedDefaultParam() returns json {
    return funcWithUnionTypedDefaultParam();
}

function funcWithNilDefaultParamExpr1(string? s = ()) returns string? {
    return s;
}

type Student record {|
    int a = 0;
    anydata...;
|};

function funcWithNilDefaultParamExpr2(Student? s = ()) returns Student? {
    return s;
}

function testFuncWithNilDefaultParamExpr() returns [any, any] {
    return [funcWithNilDefaultParamExpr1(), funcWithNilDefaultParamExpr2()];
}

public class Employee {
    public string name = "";
    public int salary = 0;

    function init(string name = "supun", int salary = 100) {
        self.name = name;
        self.salary = salary;
    }

    public function getSalary(string n, int b = 0) returns int {
        return self.salary + b;
    }
}

function testAttachedFunction() returns [int, int] {
    Employee emp = new;
    return [emp.getSalary("Alex"), emp.getSalary("Alex", b = 10)];
}

function testDefaultableParamInnerFunc() returns [int, string] {
    Person p = new;
    return p.test1(a = 50);
}

class Person {
    public int age = 0;

    function test1(int a = 77, string n = "inner default") returns [int, string] {
        return [a + 10, n + " world"];
    }
}

function functionOfFunctionTypedParamWithRest(int[] x, function (int...) returns int bar) returns [int, int] {
    return [x[0], bar(x[0])];
}

function sampleFunctionTypedParam(int... a) returns int {
    if a.length() > 0 {
        return a[0];
    }
    return 0;
}

function testFunctionOfFunctionTypedParamWithRest1() {
    int[] x = [4];
    int[] y = functionOfFunctionTypedParamWithRest(x, sampleFunctionTypedParam);
    assertEquality(x[0], y[0]);
    assertEquality(x[0], y[1]);
}

function testFunctionOfFunctionTypedParamWithRest2() {
    int[] x = [10, 20, 30];
    int[] y = functionOfFunctionTypedParamWithRest(x, sampleFunctionTypedParam);
    assertEquality(x[0], y[0]);
    assertEquality(x[0], y[1]);
}

function testFuncWithActualNeverReturn() {
    int|error x = trap blowUp();
    assertEquality(true, x is error);
}

function blowUp() returns int {
    panic error("do not call me");
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
                message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    var r1 = testInvokeFunctionInOrder1();
    io:println(r1[0]); // @output 10
    io:println(r1[1]); // @output 20.0
    io:println(r1[2]); // @output Alex
    io:println(r1[3]); // @output 30
    io:println(r1[4]); // @output Bob
    var r2 = testInvokeFunctionInOrder2();
    io:println(r2[0]); // @output 10
    io:println(r2[1]); // @output 20.0
    io:println(r2[2]); // @output Alex
    io:println(r2[3]); // @output 30
    io:println(r2[4]); // @output Bob
    var r3 = testInvokeFunctionInMixOrder1();
    io:println(r3[0]); // @output 10
    io:println(r3[1]); // @output 20.0
    io:println(r3[2]); // @output Alex
    io:println(r3[3]); // @output 30
    io:println(r3[4]); // @output Bob
    var r4 = testInvokeFunctionInMixOrder2();
    io:println(r4[0]); // @output 10
    io:println(r4[1]); // @output 20.0
    io:println(r4[2]); // @output Alex
    io:println(r4[3]); // @output 30
    io:println(r4[4]); // @output Bob
    var r5 = testInvokeFunctionWithoutSomeNamedArgs();
    io:println(r5[0]); // @output 10
    io:println(r5[1]); // @output 20.0
    io:println(r5[2]); // @output Alex
    io:println(r5[3]); // @output 5
    io:println(r5[4]); // @output Doe
    io:println(r5[5]); // @output []
    var r6 = testInvokeFunctionWithRequiredArgsOnly();
    io:println(r6[0]); // @output 10
    io:println(r6[1]); // @output 20.0
    io:println(r6[2]); // @output John
    io:println(r6[3]); // @output 5
    io:println(r6[4]); // @output Doe
    io:println(r6[5]); // @output []
    var r7 = testInvokeFunctionWithAllParamsAndRestArgs();
    io:println(r7[0]); // @output 10
    io:println(r7[1]); // @output 20.0
    io:println(r7[2]); // @output John1
    io:println(r7[3]); // @output 6
    io:println(r7[4]); // @output Doe1
    io:println(r7[5]); // @output [40,50,60]
    var r8 = testInvokeFuncWithoutRestParamsAndMissingDefaultableParam();
    io:println(r8[0]); // @output 10
    io:println(r8[1]); // @output 20.0
    io:println(r8[2]); // @output John
    io:println(r8[3]); // @output 30
    io:println(r8[4]); // @output Bob
    var r9 = testInvokeFuncWithOnlyNamedParams1();
    io:println(r9[0]); // @output 10
    io:println(r9[1]); // @output 20.0
    io:println(r9[2]); // @output Alex
    io:println(r9[3]); // @output 30
    io:println(r9[4]); // @output Bob
    var r10 = testInvokeFuncWithOnlyNamedParams2();
    io:println(r10[0]); // @output 5
    io:println(r10[1]); // @output 6.0
    io:println(r10[2]); // @output Alex
    io:println(r10[3]); // @output 30
    io:println(r10[4]); // @output Bob
    var r11 = testInvokeFuncWithOnlyNamedParams3();
    io:println(r11[0]); // @output 5
    io:println(r11[1]); // @output 6.0
    io:println(r11[2]); // @output John
    io:println(r11[3]); // @output 7
    io:println(r11[4]); // @output Doe
    io:println(testInvokeFuncWithOnlyRestParam1()); // @output []
    io:println(testInvokeFuncWithOnlyRestParam2()); // @output [10,20,30]
    io:println(testInvokeFuncWithOnlyRestParam3()); // @output [10,20,30]
    var r15 = testInvokeFuncWithAnyRestParam1();
    io:println(r15[0]); // @output [10,20,30]
    var r16 = funcInvocAsRestArgs();
    io:println(r16[0]); // @output 10
    io:println(r16[1]); // @output 20.0
    io:println(r16[2]); // @output Alex
    io:println(r16[3]); // @output 30
    io:println(r16[4]); // @output Bob
    io:println(r16[5]); // @output [1,2,3,4]
    io:println(testFuncWithUnionTypedDefaultParam()); // @output John
    var r18 = testFuncWithNilDefaultParamExpr();
    io:println(r18[0]); // @output
    io:println(r18[1]); // @output
    var r19 = testAttachedFunction();
    io:println(r19[0]); // @output 100
    io:println(r19[1]); // @output 110
    var r20 = testDefaultableParamInnerFunc();
    io:println(r20.length()); // @output 2
    io:println(r20[0]); // @output 60
    io:println(r20[1]); // @output inner default world
    testFunctionOfFunctionTypedParamWithRest1();
    testFunctionOfFunctionTypedParamWithRest2();
    testFuncWithActualNeverReturn();
}
