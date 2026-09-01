import ballerina/io;
import ballerina/jballerina.java;

function testCreateNullHandle() returns handle {
    handle nullHandle = java:createNull();
    return nullHandle;
}

function testIsNull(handle value) returns boolean {
    return java:isNull(value);
}

public function main() {
    io:println(testCreateNullHandle()); // @output null

    handle nullHandle = java:createNull();
    io:println(testIsNull(nullHandle)); // @output true
}
