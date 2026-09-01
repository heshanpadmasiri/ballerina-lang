import ballerina/io;

public function main() {
    io:println(test1()); // @output foobar
}
function concatString(string a, string b) returns string => a + b;
function test1() returns string {
    function (string, string) returns string concatFunction = concatString;
    return concatFunction("foo", "bar");
}
