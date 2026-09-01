import ballerina/io;

type Groups string|int;
type ReplacerFunction function (Groups groups) returns string;
type Replacement ReplacerFunction|string;

public function main() {
    io:println(test1()); // @output 3
    io:println(test2()); // @output sum is 3
    io:println(test3()); // @output 4
    testFuncInvocationWithinTypeNarrowingExpr();
    io:println(test4()); // @output hello world.
    io:println(test5()); // @output test5 string1.0
    testUnionLambdaAsReturnParameter();
    io:println(test6()); // @output test6 test6 1.0
    io:println(testFuncWithArrayParams()); // @output 0
    io:println(testInTypeGuard()); // @output 0
    testGetMemberFunctionAsAField();
    testMemberTakenAsAFieldWithRestArgs();
    [int, string] values = testFunctionPointerAsFuncParam();
    io:println(values[0]); // @output 13
    io:println(values[1]); // @output Total: 6 USD
    io:println(checkpanic testAnyToFuncPointerConversion_1()); // @output 5
    io:println(testFuncPointerConversion()); // @output 40
    io:println(testSubTypingWithAny()); // @output 12
    io:println(testGlobalFunctionPointerVar()); // @output f1
    io:println(testGlobalFunctionPointerTyped()); // @output f2
    io:println(testVoidFunctionAsUnionReturnFunction()); // @output value - updated through lambda
    testDefaultParams();
}

function test1() returns int {
    function (int, int) returns int addFunction = func1;
    return addFunction(1, 2);
}
function func1(int a, int b) returns int => a + b;

function test2() returns string {
    function (int, int) returns string sumFunction = function (int a, int b) returns string {
        return "sum is " + (a + b).toString();
    };
    return sumFunction(1, 2);
}

function test3() returns int => test3Callee(1, func1);
function test3Callee(int a, function (int, int) returns int func) returns int => a + func(1, 2);

function test4() returns string {
    function (string, string) returns string foo = test4Callee();
    return foo("hello ", "world.");
}
function test4Callee() returns function (string, string) returns string {
    return function (string x, string y) returns string => x + y;
}

function testUnionLambdaAsReturnParameter() {
    function (string) returns string func = checkpanic testUnionLambdaAsReturnParameterCallee();
    assertEquality(func("Waruna"), "Union lambda as return type with Waruna");
}
function testUnionLambdaAsReturnParameterCallee() returns (function (string) returns string)|error {
    return function (string s) returns string => "Union lambda as return type with " + s;
}

function test5() returns string {
    function (string, float) returns string bar = test5Callee();
    return "test5 " + bar("string", 1.0);
}
function test5Callee() returns function (string, float) returns string => test5Ref;
function test5Ref(string a, float b) returns string => a + b.toString();

function test6() returns string {
    function (string, function (string, float) returns string) returns string foo = test6Callee();
    return foo("test6 ", test5Ref);
}
function test6Callee() returns function (string, function (string, float) returns string) returns string => test6Ref;
function test6Ref(string a, function (string, float) returns string b) returns string => a + b(a, 1.0);

function testFuncWithArrayParams() returns int {
    function (string[]) returns int f = funcWithArrayParams;
    return f(["me", "myself"]);
}
function funcWithArrayParams(string[] a) returns int => 0;

public function getCount(function (int, int) returns int sumFunction, string first, string last) returns string {
    return first + ": " + sumFunction(4, 2).toString() + " " + last;
}
function testFunctionPointerAsFuncParam() returns [int, string] {
    function (int, int) returns int sumFunction = function (int a, int b) returns int => a + b;
    return [sumFunction(5, 8), getCount(sumFunction, "Total", "USD")];
}
function testAnyToFuncPointerConversion_1() returns int|error {
    any anyFunc = function (int a, int b) returns int => a + b;
    function (int, int) returns int sumFunction = <function (int, int) returns int> anyFunc;
    return sumFunction(3, 2);
}

class Person {
    int age;
    function init(int age) { self.age = age; }
    function getAge() returns int => self.age;
}
class Student {
    int age = 40;
    private int marks = 0;
    function getAge() returns int => self.age;
}
function testFuncPointerConversion() returns int {
    function (Person) returns int personFunc = function (Person p) returns int => p.getAge();
    function (Student) returns int studentFunc = personFunc;
    Student s = new;
    return studentFunc(s);
}

function bar() returns string => "12";
function testSubTypingWithAny() returns any {
    function () returns any ff = bar;
    return ff();
}
var f1 = function () returns string => "f1";
public function testGlobalFunctionPointerVar() returns string => f1();
function () returns string f2 = function () returns string => "f2";
public function testGlobalFunctionPointerTyped() returns string => f2();

public function testVoidFunctionAsUnionReturnFunction() returns string {
    string s = "value";
    xyz(function () { s += " - updated through lambda"; });
    return s;
}
function xyz(function () returns any|error func) {
    any|error result = func();
    if result is error { panic result; }
}

function getName(string n) returns string => n;
function getDetails(string n, function (string) returns string fn = (x) => "John") returns string => fn(n);
public function testDefaultParams() {
    assertEquality(getDetails("Anne", getName), "Anne");
    assertEquality(getDetails("Bobby"), "John");
}

class A {
    int i;
    function init(int i) { self.i = i; }
    function getI(int k) returns int => self.i;
}
public function testGetMemberFunctionAsAField() {
    A a = new(1);
    function (int) returns int func = a.getI;
    assertEquality(1, func(0));
    var aFactory = function () returns A => new(2);
    function (int) returns int func2 = aFactory().getI;
    assertEquality(2, func2(0));
    var c = createA(3).getI;
    assertEquality(3, c(2));
}
function createA(int i) returns A => new(i);

class B {
    int i;
    function init(int i) { self.i = i; }
    function accumulate(int... args) returns int {
        foreach int arg in args { self.i += arg; }
        return self.i;
    }
    function get() returns int => self.i;
}
public function testMemberTakenAsAFieldWithRestArgs() {
    B b = new(0);
    assertEquality(0, b.get());
    _ = b.accumulate(1); assertEquality(1, b.get());
    _ = b.accumulate(1, 2); assertEquality(4, b.get());
    _ = b.accumulate(10, 20); assertEquality(34, b.get());
    var f = b.accumulate;
    var g = b.get;
    int f0 = f(-34); assertEquality(0, g()); assertEquality(0, f0);
    _ = f(1); assertEquality(1, g());
    _ = f(1); assertEquality(2, g());
    _ = f(10, 100); assertEquality(112, g());
}

function funcInvocationWithinTypeNarrowingExpr(Replacement replacement) returns string {
    Groups k = "chiran";
    if replacement is ReplacerFunction { return replacement(k); }
    return "";
}
function testFuncInvocationWithinTypeNarrowingExpr() {
    assertEquality("chiran", funcInvocationWithinTypeNarrowingExpr(mat));
}
function mat(Groups x) returns string => "chiran";

function testInTypeGuard() returns int {
    (function (string[]) returns int)|error func = funcWithArrayParams;
    if (func is (function (string[]) returns int)) { return func([""]); }
    return 1;
}
function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual { return; }
    if expected === actual { return; }
    panic error("AssertionError");
}
