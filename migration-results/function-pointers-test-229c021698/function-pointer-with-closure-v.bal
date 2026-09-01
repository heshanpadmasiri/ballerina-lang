import ballerina/io;

public function main() {
    io:println(testArrayFunctionInfer()); // @output abccde
    io:println(invokeApplyFunction()); // @output 6
}
function testArrayFunctionInfer() returns string {
    string word = "";
    var concat = function (string value) { word += value; };
    function (string) lambda = (value) => concat(value);
    lambda("abc"); lambda("cde");
    return word;
}
function apply(function (int) returns int f1, function (int) returns any f2) returns function (int) returns any {
    return function (int arg) returns any => f2(f1(arg));
}
public function invokeApplyFunction() returns any {
    function (int) returns int add1 = a => a + 1;
    function (int) returns int mult2 = a => a * 2;
    function (int) returns any composed = apply(add1, mult2);
    return composed(2);
}
