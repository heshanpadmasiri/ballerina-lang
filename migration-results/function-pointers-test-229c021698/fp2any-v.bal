import ballerina/io;

public function main() {
    io:println(checkpanic test1()); // @output test1
}
function test1() returns string|error {
    function (string, int) returns string fp = function (string a, int b) returns string => a + b.toString();
    any value = fp;
    return test2(value);
}
function test2(any value) returns string|error {
    function (string, int) returns string fp = <function (string, int) returns string> value;
    return fp("test", 1);
}
