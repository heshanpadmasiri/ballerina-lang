import ballerina/io;

public function main() {
    io:println(testStringFunctionInvocation()); // @output BALLERINA
    io:println(testStringFunctionInvocationInArgument()); // @output Hello BALLERINA
}

function testStringFunctionInvocation() returns string {
    string s = "ballerina".toUpperAscii();
    return s;
}

function testStringFunctionInvocationInArgument() returns string {
    return greet("ballerina".toUpperAscii());
}

function greet(string s) returns string {
    return "Hello " + s;
}
