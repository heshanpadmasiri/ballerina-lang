import ballerina/io;
import ballerina/jballerina.java;

public function main() {
    testStringUtils();
    testStringValue();
}

function testStringUtils() {
    error v = <error>trap foo();
    var val = v.stackTrace();
    io:println(val.toString()); // @output [callableName: baz  fileName: string-utils-v.bal lineNumber: 24,callableName: bar  fileName: string-utils-v.bal lineNumber: 20,callableName: foo  fileName: string-utils-v.bal lineNumber: 16,callableName: testStringUtils  fileName: string-utils-v.bal lineNumber: 10,callableName: main  fileName: string-utils-v.bal lineNumber: 5]
}

function foo() {
    bar();
}

function bar() {
    baz();
}

function baz() {
    panic error("Op Failed");
}

function fromString(handle value) returns string = @java:Method {
    'class: "io/ballerina/runtime/api/utils/StringUtils"
} external;

function testStringValue() {
    string val = "ascii~?" + "£ßóµ¥" + "ęЯλĢŃ" + "☃✈௸ऴᛤ" + "😀🄰🍺";
    val = fromString(java:fromString(val));
    io:println(val); // @output ascii~?£ßóµ¥ęЯλĢŃ☃✈௸ऴᛤ😀🄰🍺
}
