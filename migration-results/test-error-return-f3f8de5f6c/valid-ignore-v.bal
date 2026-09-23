import ballerina/io;

public function main() {
    string a1;
    float b1;
    [a1, b1] = test1();
    io:println(a1); // @output a
    io:println(b1); // @output 2.0
    string a2;
    string b2;
    [a2, b2] = test2();
    io:println(a2); // @output a
    io:println(b2); // @output b
    io:println(test3()); // @output 1.0
    _ = test4();
    test5();
}

function test1() returns [string, float] {
    string a;
    float b;
    [a, _, b] = testMultiReturn1();
    return [a, b];
}

function testMultiReturn1() returns [string, int, float] {
    return ["a", 1, 2.0];
}

function test2() returns [string, string] {
    string[] x;
    [x, _] = testMultiReturn2();
    return [x[0], x[1]];
}

function testMultiReturn2() returns [string[], float] {
    string[] a = ["a", "b", "c"];
    return [a, 1.0];
}

function test3() returns float {
    float x;
    [_, x] = testMultiReturn2();
    return x;
}

function test4() returns [string, float] {
    string a = "a";
    float b = 0.0;
    [_, _, _] = testMultiReturn4();
    return [a, b];
}

function testMultiReturn4() returns [string, int, float] {
    return ["a", 1, 2.0];
}

function test5() {
    _ = testMultiReturn5();
}

function testMultiReturn5() returns string {
    return "a";
}
