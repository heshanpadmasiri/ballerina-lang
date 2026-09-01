import ballerina/io;
import ab/function_pointers_project.a.b;
import ab/function_pointers_project.foo;
import ab/function_pointers_project.bar;

public function main() {
    io:println(test1()); // @output 3
    io:println(test2()); // @output 3
    io:println(getCombinedString()); // @output foo bar
}
function test1() returns int {
    function (int, int) returns int addFunction = b:Fn1();
    return addFunction(1, 2);
}
function test2() returns int {
    function (int, int) returns int addFunction = b:Fn2();
    return addFunction(1, 2);
}
public function getCombinedString() returns string {
    var sampleMethod = function (function () returns string get) returns string => get();
    return sampleMethod(foo:data) + " " + sampleMethod(bar:data);
}
