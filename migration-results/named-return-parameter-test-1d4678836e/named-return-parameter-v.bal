import ballerina/io;

function testSingleNamedReturnParam(int a, string b) returns (int) {
    int p = a + 2;
    return p;
}

function testSingleNamedReturnParamZeroReturnArgs(int a, string b) returns (int) {
    int p = a + 2;
    return p;
}

function testTwoNamedReturnParam(int a, string b) returns [int, string] {
    int p = a + 2;
    string name = b + ", john";

    return [p, name];
}

function testTwoNamedReturnParamZeroReturnArgs(int a, string b) returns [int, string] {
    int p = a + 2;
    string name = b + ", john";

    return [p, name];
}

public function main() {
    io:println(testSingleNamedReturnParam(10, "test")); // @output 12
    io:println(testSingleNamedReturnParamZeroReturnArgs(10, "test")); // @output 12

    [int, string] firstPair = testTwoNamedReturnParam(10, "test");
    io:println(firstPair[0]); // @output 12
    io:println(firstPair[1]); // @output test, john

    [int, string] secondPair = testTwoNamedReturnParamZeroReturnArgs(10, "test");
    io:println(secondPair[0]); // @output 12
    io:println(secondPair[1]); // @output test, john
}
