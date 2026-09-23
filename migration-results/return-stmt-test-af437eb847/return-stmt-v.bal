import ballerina/io;

function testReturn() {
    return;
}

function testReturnOneVarDcl() {
    int x = 0;

    return;
}

function testReturnOneReturnArg() returns (int) {
    return 5;
}

function testReturnOneParam(int a) {
    return;
}

function testReturnOneParamOneReturnArg(int a) returns (int) {
    return a;
}

function testReturnOneParamOneVarDclOneReturnArg(int a) returns (int) {
    int b = 10;

    return a + b;
}

function testReturnNoParamTwoVarDclsTwoReturnArgs() returns [int, string] {
    int b = 10;
    string t = "john";

    return [b, t];
}

function testReturnTwoVarDclsTwoReturnArgs(int a, int q) returns [int, string] {
    int b = a + q;
    string t = "john";

    return [a + b, t];
}

function testReturnThreeVarDclsThreeReturnArgs(int a, int q) returns [int, string, float] {
    int b = a + q;
    string t = "john";
    float f = 0.5 * 2.0;

    return [a + b, t, f];
}

function splitUtil(string s) returns [string, string, string] {
    return ["section1", "section2", "section3"];
}

function testSplitString() returns [string, string, string] {
    string section = "Ballerina is a programming language";
    return splitUtil(section);
}

function testToUpperUtil(string s) returns (string) {
    return "SECTION";
}

function testToUpperUtilDouble(string s1, string s2) returns [string, string] {
    string s3 = "NAME1";
    string s4 = "NAME2";
    return [s3, s4];
}

function testToUpper(string s) returns (string) {
    return testToUpperUtil(s);
}

function testToUpper1(string s1, string s2) returns [string, string] {
    return [testToUpperUtil(s1), s2];
}

function testToUpper2(string s1, string s2) returns [string, string] {
    return [s1, testToUpperUtil(s2)];
}

function testToUpper3(string s1, string s2) returns [string, string] {
    return [testToUpperUtil(s1), testToUpperUtil(s2)];
}

function testToUpper4(string s1, string s2) returns [string, string] {
    return testToUpperUtilDouble(s1, s2);
}

function testReturnWithThreeArguments() returns [int, string, int] {
    int x = 10;

    return [x, foo(1, 4), bar(5, "john", 6)];
}

function foo(int a, int b) returns (string) {
    return "foo";
}

function bar(int a, string s, int b) returns (int) {
    return 4;
}

public function main() {
    testReturn();
    io:println(()); // @output
    testReturnOneVarDcl();
    io:println(()); // @output
    io:println(testReturnOneReturnArg()); // @output 5
    testReturnOneParam(10);
    io:println(()); // @output
    io:println(testReturnOneParamOneReturnArg(10)); // @output 10
    io:println(testReturnOneParamOneVarDclOneReturnArg(10)); // @output 20

    [int, string] twoReturns = testReturnNoParamTwoVarDclsTwoReturnArgs();
    io:println(twoReturns[0]); // @output 10
    io:println(twoReturns[1]); // @output john
    [int, string, float] threeReturns = testReturnThreeVarDclsThreeReturnArgs(10, 30);
    io:println(threeReturns[0]); // @output 50
    io:println(threeReturns[1]); // @output john
    io:println(threeReturns[2]); // @output 1.0

    [string, string, string] splitReturns = testSplitString();
    io:println(splitReturns[0]); // @output section1
    io:println(splitReturns[1]); // @output section2
    io:println(splitReturns[2]); // @output section3
    io:println(testToUpperUtil("section")); // @output SECTION
    [string, string] upperUtilDoubleReturns = testToUpperUtilDouble("name1", "name2");
    io:println(upperUtilDoubleReturns[0]); // @output NAME1
    io:println(upperUtilDoubleReturns[1]); // @output NAME2
    io:println(testToUpper("section")); // @output SECTION

    [string, string] upper1Returns = testToUpper1("name1", "name2");
    io:println(upper1Returns[0]); // @output SECTION
    io:println(upper1Returns[1]); // @output name2
    [string, string] upper2Returns = testToUpper2("name1", "name2");
    io:println(upper2Returns[0]); // @output name1
    io:println(upper2Returns[1]); // @output SECTION
    [string, string] upper3Returns = testToUpper3("name1", "name2");
    io:println(upper3Returns[0]); // @output SECTION
    io:println(upper3Returns[1]); // @output SECTION
    [string, string] upper4Returns = testToUpper4("name1", "name2");
    io:println(upper4Returns[0]); // @output NAME1
    io:println(upper4Returns[1]); // @output NAME2

    [int, string, int] threeArgumentReturns = testReturnWithThreeArguments();
    io:println(threeArgumentReturns[0]); // @output 10
    io:println(threeArgumentReturns[1]); // @output foo
    io:println(threeArgumentReturns[2]); // @output 4
}
