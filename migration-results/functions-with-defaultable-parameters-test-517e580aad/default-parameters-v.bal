import ballerina/io;
import ballerina/lang.runtime;

int GLB = 0;

function getInt() returns int => 100;
function getFloat() returns float => 1.1;
function getString() returns string => "default";
function getBoolean() returns boolean => true;
function getRecord() returns FooRecord => {a: "default2", b: 150, c: true, d: 33.3};

type FooRecord record {
    string a;
    int b;
    boolean c;
    float d;
};

class FooObject {
    string a;
    int b;

    function init(string a, int b) {
        self.a = a;
        self.b = b;
    }

    function getValues() returns [string, int] => [self.a, self.b];
}

function getIntOrError(int a) returns int|error {
    if a == 0 {
        return error("Generated Error");
    }
    return 100;
}

function getStringOrNil() returns string? {
    if GLB == 0 {
        return "string";
    }
    return ();
}

function testFunctionCallAsDefaultExpr() returns [[int, string, float, boolean], [int, string, float, boolean], [int, string, float, boolean]] {
    return [foo(), foo(a = 200, b = "given", c = 4.4, d = false), foo(a = 500, c = 5.5)];
}

function foo(int a = getInt(), string b = getString(), float c = getFloat(), boolean d = getBoolean()) returns [int, string, float, boolean] => [a, b, c, d];

function testRecordAsDefaultExpr() returns [FooRecord, FooRecord, FooRecord, FooRecord] {
    FooRecord fRec1 = {a: "f1", b: 100, c: true, d: 22.2};
    FooRecord fRec2 = {a: "f2", b: 200, c: false, d: 44.4};
    [FooRecord, FooRecord] x = bar(fRec2 = fRec2);
    [FooRecord, FooRecord] y = bar(fRec1 = fRec1);
    return [x[0], x[1], y[0], y[1]];
}

function bar(FooRecord fRec1 = {a: "default", b: 50, c: false, d: 11.1}, FooRecord fRec2 = getRecord()) returns [FooRecord, FooRecord] => [fRec1, fRec2];

function testDefaultExprInFunctionPointers() returns [int, string, float, boolean] {
    function (int, string, float, boolean) returns [int, string, float, boolean] fp1 = foo;
    return fp1(200, "given", 4.4, false);
}

function testCombinedExprAsDefaultValue() returns [[int, string, float], [int, string, float], [int, string, float]] {
    return [foo2(), foo2(a = 50), foo2(b = "given" + getString(), c = 9.9)];
}

function foo2(int a = getInt() + 5 + getInt(), string b = "def" + getString(), float c = getFloat() + <float>getInt()) returns [int, string, float] => [a, b, c];

function testDefaultValueWithError() {
    GLB = 0;
    error e1 = foo3();
    GLB = 1;
    error e2 = foo3();
    error e3 = foo3(a = 2);
    assertEquality(e1.message(), "Generated Error");
    assertEquality(e2.message(), "Not Error 100");
    assertEquality(e3.message(), "Not Error 2");
}

function foo3(int|error a = getIntOrError(GLB)) returns error {
    if a is error {
        return a;
    }
    return error("Not Error " + a.toString());
}

function testDefaultValueWithTernary() returns [[float, string], [float, string], [float, string]] {
    GLB = 0;
    [float, string] a = foo4();
    GLB = 1;
    [float, string] b = foo4();
    return [a, b, foo4(f = 3.3, s = "given")];
}

function foo4(float f = (GLB == 0 ? 1.1 : 2.2), string s = getStringOrNil() ?: "empty") returns [float, string] => [f, s];

function testDefaultObject() returns [[string, int], [string, int]] {
    [string, float, FooObject] a = foo7("fp");
    [string, float, FooObject] b = foo7("fp", o = new ("given", 200));
    return [a[2].getValues(), b[2].getValues()];
}

function foo7(string s, float b = 1.1, FooObject o = new ("default", 100)) returns [string, float, FooObject] => [s, b, o];

function testFuncWithDefaultByteValue() {
    assertEquality(funcWithDefaultByteValue(), 10);
    assertEquality(funcWithDefaultByteValue(15), 15);
}

function testDefaultByteValueInFunctionPointers() {
    function (byte b = 5) returns byte fp = funcWithDefaultByteValue;
    assertEquality(fp(15), 15);
    assertEquality(fp(funcWithDefaultByteValue()), 10);
    assertEquality(fp(), 5);
}

function funcWithDefaultByteValue(byte b = 10) returns byte => b;

function testFuncWithAsyncDefaultParamExpression() returns string => funcWithAsyncDefaultParamExpression() + funcWithAsyncDefaultParamExpression("world") + funcWithAsyncDefaultParamExpression("sample", "value");
function funcWithAsyncDefaultParamExpression(string a1 = asyncRet(), string a2 = asyncRet()) returns string => a1 + a2;
function asyncRet() returns string {
    sleep(50);
    return "hello";
}
function asyncRetWithVal(string a = "sample") returns string {
    sleep(50);
    return a + "async";
}
function sleep(int millis) {
    runtime:sleep(<decimal> millis / 1000);
}

function testUsingParamValues() returns string => usingParamValues() + usingParamValues("world") + usingParamValues("sample", "value");
function usingParamValues(string a1 = asyncRet(), string a2 = asyncRetWithVal(a1)) returns string => a1 + a2;

public class Person {
    function funcWithAsyncDefaultParamExpression(string a1 = asyncRet(), string a2 = asyncRet()) returns string => a1 + a2;
    function usingParamValues(string a1 = asyncRet(), string a2 = asyncRetWithVal(a1)) returns string => a1 + a2;
}

client class MyClient {
    resource function get [string... path](map<string|string[]>? headers = ()) returns string => path[0];
}

final MyClient clientEP = new ();
function testResourceFunctionDefaultParam() returns string {
    return clientEP->/foo/bar.get();
}

function testAttachedAsyncDefaultParam() returns string {
    Person p = new;
    return p.funcWithAsyncDefaultParamExpression() + p.funcWithAsyncDefaultParamExpression("world") + p.funcWithAsyncDefaultParamExpression("sample", "value");
}

function testUsingParamValuesInAttachedFunc() returns string {
    Person p = new;
    return p.usingParamValues() + p.usingParamValues("world") + p.usingParamValues("sample", "value");
}

function testFuncWithVariableNameFieldInMappingConstructorForDefaultValue() {
    int a = 10;
    _ = a;
    function (record {|int a;|} x = {a}) returns int y = value1;
    assertEquality(y(), 10);
}

function testFuncWithComputedNameFieldInMappingConstructorForDefaultValue() {
    int a = 100;
    string b = "a";
    _ = a;
    _ = b;
    function (record {|int a;|} x = {a: 10, [b]: a}) returns int y = value1;
    assertEquality(y(), 100);
}

function value1(record {|int a;|} x) returns int => x.a;

function testFuncWithSpreadFieldInMappingConstructorForDefaultValue() {
    int a = 10;
    int b = 20;
    record {|int a; int b;|} r = {a: a, b: b};
    _ = r;
    function (record {|int a; int b;|} x = {...r}) returns int y = value2;
    assertEquality(y(), 30);
}

function value2(record {|int a; int b;|} x) returns int => x.a + x.b;

type F1 function() returns int;
type F2 function() returns function() returns int;
function baz(int a, F1 b = function() returns int { return a + 1; }) returns int => a + b();
function baz1(int a, F2 b = function() returns function() returns int {
    return function() returns int { return a; };
}) returns int {
    F1 f = b();
    return a + f();
}
function baz2(int a, function() returns int b = function() returns int {
    function (int x = a) returns int f = function(int p) returns int => p + 1;
    return f();
}) returns int => a + b();
function baz3(int a, int c, function() returns int b = function() returns int {
    function (int x = a + c) returns int f = function(int p) returns int => p + 1;
    return f();
}) returns int => a + b() + c;
function baz4(int a, function() returns int b = function() returns int {
    function (int x = a) returns int f = function(int p) returns int => p + 1 + a;
    return f();
}) returns int => a + b();

function testUsingParamInAnonFuncDefaultValueOfSubsequentParam() {
    assertEquality(baz(10), 21);
    assertEquality(baz1(100), 200);
    assertEquality(baz2(10), 21);
    assertEquality(baz3(10, 20), 61);
    assertEquality(baz4(10), 31);
}

isolated function intOrErrorError() returns int|error => error("err!");
isolated function intOrErrorInt() returns int|error => 4;
function functionWithIndirectUsageOfCheckInParamDefault(function () returns int|error fn = function () returns int|error {
    int intResult = check intOrErrorError();
    return intResult + 1;
}) returns int|error => fn();

function testValidCheckUsageViaDefaults() {
    int|error res = functionWithIndirectUsageOfCheckInParamDefault();
    assertEquality(true, res is error);
    error err = <error> res;
    assertEquality("err!", err.message());
    record {|
        function (int intP = checkpanic intOrErrorError()) returns int|error x = function (int intP) returns int|error {
            int val = check intOrErrorInt();
            return val + intP;
        };
        string y;
    |} rec = {y: "test"};
    function (int intP = 1 + checkpanic intOrErrorInt()) returns int|error x = rec.x;
    assertEquality(9, x());
    assertEquality("test", rec.y);
}

public type Employee record {|
    string firstName;
    string lastName;
|};
public type RT object {
    *object:RawTemplate;
    public string[] & readonly strings;
    public [Employee] insertions;
};
function funcWithRawTemplate(Employee e, RT fullName = `${e}`) returns string => fullName.insertions[0].firstName + " " + fullName.insertions[0].lastName;
function testFuncWithRawTemplate() {
    assertEquality("Chiran Sachintha", funcWithRawTemplate({firstName: "Chiran", lastName: "Sachintha"}));
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    panic error("AssertionError");
}

public function main() returns error? {
    var functionCall = testFunctionCallAsDefaultExpr();
    io:println(functionCall[0][0]); // @output 100
    io:println(functionCall[0][1]); // @output default
    io:println(functionCall[0][2]); // @output 1.1
    io:println(functionCall[0][3]); // @output true
    io:println(functionCall[1][0]); // @output 200
    io:println(functionCall[1][1]); // @output given
    io:println(functionCall[1][2]); // @output 4.4
    io:println(functionCall[1][3]); // @output false
    io:println(functionCall[2][0]); // @output 500
    io:println(functionCall[2][1]); // @output default
    io:println(functionCall[2][2]); // @output 5.5
    io:println(functionCall[2][3]); // @output true

    var records = testRecordAsDefaultExpr();
    io:println(records[0].a); // @output default
    io:println(records[0].b); // @output 50
    io:println(records[0].c); // @output false
    io:println(records[0].d); // @output 11.1
    io:println(records[1].a); // @output f2
    io:println(records[1].b); // @output 200
    io:println(records[1].c); // @output false
    io:println(records[1].d); // @output 44.4
    io:println(records[2].a); // @output f1
    io:println(records[2].b); // @output 100
    io:println(records[2].c); // @output true
    io:println(records[2].d); // @output 22.2
    io:println(records[3].a); // @output default2
    io:println(records[3].b); // @output 150
    io:println(records[3].c); // @output true
    io:println(records[3].d); // @output 33.3

    var functionPointer = testDefaultExprInFunctionPointers();
    io:println(functionPointer[0]); // @output 200
    io:println(functionPointer[1]); // @output given
    io:println(functionPointer[2]); // @output 4.4
    io:println(functionPointer[3]); // @output false

    var combined = testCombinedExprAsDefaultValue();
    io:println(combined[0][0]); // @output 205
    io:println(combined[0][1]); // @output defdefault
    io:println(combined[0][2]); // @output 101.1
    io:println(combined[1][0]); // @output 50
    io:println(combined[1][1]); // @output defdefault
    io:println(combined[1][2]); // @output 101.1
    io:println(combined[2][0]); // @output 205
    io:println(combined[2][1]); // @output givendefault
    io:println(combined[2][2]); // @output 9.9

    testDefaultValueWithError();
    var ternary = testDefaultValueWithTernary();
    io:println(ternary[0][0]); // @output 1.1
    io:println(ternary[0][1]); // @output string
    io:println(ternary[1][0]); // @output 2.2
    io:println(ternary[1][1]); // @output empty
    io:println(ternary[2][0]); // @output 3.3
    io:println(ternary[2][1]); // @output given

    var objectValues = testDefaultObject();
    io:println(objectValues[0][0]); // @output default
    io:println(objectValues[0][1]); // @output 100
    io:println(objectValues[1][0]); // @output given
    io:println(objectValues[1][1]); // @output 200

    testFuncWithDefaultByteValue();
    testDefaultByteValueInFunctionPointers();
    io:println(testFuncWithAsyncDefaultParamExpression()); // @output hellohelloworldhellosamplevalue
    io:println(testUsingParamValues()); // @output hellohelloasyncworldworldasyncsamplevalue
    io:println(testAttachedAsyncDefaultParam()); // @output hellohelloworldhellosamplevalue
    io:println(testResourceFunctionDefaultParam()); // @output foo
    io:println(testUsingParamValuesInAttachedFunc()); // @output hellohelloasyncworldworldasyncsamplevalue
    testFuncWithComputedNameFieldInMappingConstructorForDefaultValue();
    testFuncWithVariableNameFieldInMappingConstructorForDefaultValue();
    testFuncWithSpreadFieldInMappingConstructorForDefaultValue();
    testFuncWithRawTemplate();
    testUsingParamInAnonFuncDefaultValueOfSubsequentParam();
    testValidCheckUsageViaDefaults();
}
