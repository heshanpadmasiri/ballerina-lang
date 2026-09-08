import ballerina/io;

function asyncTest() returns int {
    return 42;
}

public function main() {
    int result = asyncTest();
    io:println(result); // @output 42
}
