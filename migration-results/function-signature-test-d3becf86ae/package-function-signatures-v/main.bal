import ballerina/io;
import ballerina/jballerina.java;
import function_signature_migration.d;

public function mockedNativeFuncWithOptionalParams(int a, float b, string c = "John", int d = 5, string e = "Doe")
        returns [int, float, string, int, string] = @java:Method {
    name: "mockedNativeFuncWithOptionalParams",
    'class: "org.ballerinalang.test.functions.FunctionSignatureTest"
} external;

function testInvokePkgFunctionInMixOrder() returns [int, float, string, int, string, int[]] {
    return d:functionWithAllTypesParams(e = "Bob", a = 10, d = 30, c = "Alex", b = 20.0);
}

function testInvokePkgFunctionInOrderWithRestParams() returns [int, float, string, int, string, int[]] {
    return d:functionWithAllTypesParams(10, 20.0, "Alex", 30, "Bob", 40, 50, 60);
}

function testInvokePkgFunctionWithRequiredArgsOnly() returns [int, float, string, int, string, int[]] {
    return d:functionWithAllTypesParams(10, 20.0);
}

function testOptionalArgsInNativeFunc() returns [int, float, string, int, string] {
    return mockedNativeFuncWithOptionalParams(78, 89.0);
}

public function main() {
    var r1 = testInvokePkgFunctionInMixOrder();
    io:println(r1[0]); // @output 10
    io:println(r1[1]); // @output 20.0
    io:println(r1[2]); // @output Alex
    io:println(r1[3]); // @output 30
    io:println(r1[4]); // @output Bob
    var r2 = testInvokePkgFunctionInOrderWithRestParams();
    io:println(r2[0]); // @output 10
    io:println(r2[1]); // @output 20.0
    io:println(r2[2]); // @output Alex
    io:println(r2[3]); // @output 30
    io:println(r2[4]); // @output Bob
    io:println(r2[5]); // @output [40,50,60]
    var r3 = testInvokePkgFunctionWithRequiredArgsOnly();
    io:println(r3[0]); // @output 10
    io:println(r3[1]); // @output 20.0
    io:println(r3[2]); // @output John
    io:println(r3[3]); // @output 5
    io:println(r3[4]); // @output Doe
    io:println(r3[5]); // @output []
    var r4 = testOptionalArgsInNativeFunc();
    io:println(r4[0]); // @output 78
    io:println(r4[1]); // @output 89.0
    io:println(r4[2]); // @output John
    io:println(r4[3]); // @output 5
    io:println(r4[4]); // @output Doe
}
