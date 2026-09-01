import ballerina/io;

function funcWithNamedParams(int a, int b, string c = "John") returns [int, int, string] {
    return [a, b, c];
}

function testFunctionPointerAssignmentWithNamedParams() returns [int, int, string] {
    function (int, int, string) returns [int, int, string] func = funcWithNamedParams;
    return func(1, 2, "Alex");
}

public function main() {
    [int, int, string] result = testFunctionPointerAssignmentWithNamedParams();
    io:println(result[0]); // @output 1
    io:println(result[1]); // @output 2
    io:println(result[2]); // @output Alex
}
