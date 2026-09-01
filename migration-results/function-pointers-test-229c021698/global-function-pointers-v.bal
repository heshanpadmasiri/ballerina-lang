import ballerina/io;

function (string, int) returns string glf1 = foo;
function (string, boolean) returns string glf2 = function (string a, boolean b) returns string => a + b.toString();
type F1 function (int) returns function (int) returns int;
F1 f1 = function (int a) returns function (int) returns int => function (int b) returns int => a + b;
type F2 function (int) returns function (int) returns function (int) returns int;
F2 f2 = function (int a) returns function (int) returns function (int) returns int =>
    function (int b) returns function (int) returns int => function (int c) returns int => a + b + c;
function (string, int) returns string glf3 = function (string a, int b) returns string => "llll";

public function main() {
    io:println(test1()); // @output test1
    io:println(test2()); // @output test2true
    [string, string, string] values = test3();
    io:println(values.length()); // @output 3
    io:println(values[0]); // @output test3
    io:println(values[1]); // @output test3
    io:println(values[2]); // @output 3test
    io:println(test5()); // @output falsetest5
    io:println(test6()); // @output truetest6
    testGlobalFunctionTypeDefWithClosures();
}
function foo(string x, int y) returns string => x + y.toString();
function fooReverse(string x, int y) returns string => y.toString() + x;
function test1() returns string => glf1("test", 1);
function test2() returns string => glf2("test2", true);
function test3() returns [string, string, string] {
    glf3 = foo;
    string x = glf3("test", 3);
    string y = foo("test", 3);
    glf3 = fooReverse;
    return [x, y, glf3("test", 3)];
}
function bar(string x, boolean y) returns string => y.toString() + x;
function test5() returns string {
    function (string, boolean) returns string glf4 = bar;
    return glf4("test5", false);
}
function test6() returns string {
    function (string, boolean) returns string glf4 = bar;
    glf2 = glf4;
    return glf2("test6", true);
}
var getIntArray = function () returns int[] => [1, 2, 3, 4];
int[] salaries = getSalaries(getIntArray);
function getSalaries(function () returns int[] arrayFunc) returns int[] => arrayFunc();
function testGlobalFunctionTypeDefWithClosures() {
    function (int) returns int a = f1(2);
    assertEquality(5, a(3));
    function (int) returns function (int) returns int b = f2(5);
    function (int) returns int c = b(6);
    assertEquality(18, c(7));
    assertEquality([1, 2, 3, 4], salaries);
}
function assertEquality(anydata expected, anydata actual) {
    if expected == actual { return; }
    panic error("AssertionError");
}
