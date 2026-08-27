import ballerina/io;
import ballerina/lang.value;

function testIntAssignStmt(int a) returns int {
    int x;
    x = a;
    return x;
}

function testFloatAssignStmt(float a) returns float {
    float x;
    x = a;
    return x;
}

function testBooleanAssignStmt(boolean a) returns boolean {
    boolean x;
    x = a;
    return x;
}

function testStringAssignStmt(string a) returns string {
    string x;
    x = a;
    return x;
}

function testIntToArrayAssignStmt(int a) returns int {
    int[] arr = [];
    arr[0] = a;
    return arr[0];
}

function testArrayIndexToIntAssignStmt(int[] arr) returns int {
    int a;
    a = arr[0];
    return a;
}

function testMultiReturn() returns [int, string, int] {
    int a;
    string name;
    int b;
    [a, name, b] = testMultiReturnInternal();
    return [a, name, b];
}

function testMultiReturnInternal() returns [int, string, int] {
    return [5, "john", 6];
}

function testIntCastFloatStmt(int a) returns float {
    float x;
    x = <float>a;
    return x;
}

public type CustomError error<record {|value:Cloneable failedAttempts;|}>;

public client class Client {
    remote function foo() returns [int, int] {
        return [0, 0];
    }

    remote function foo1() returns record { string a; } {
        return {a: "a"};
    }

    remote function foo2() returns error {
        return error("the error reason");
    }

    remote function foo3() returns CustomError {
        return error("foo3 error", failedAttempts = 3);
    }
}

function restActionResultAssignment() returns [int, int, string, string, string, value:Cloneable] {
    Client c = new();
    var [a, b] = c->foo();
    var {a: d} = c->foo1();
    var error(r) = c->foo2();
    var error(r2, failedAttempts = failedAttempts) = c->foo3();
    return [a, b, d, r, r2, failedAttempts];
}

function testAssignErrorArrayToAny() {
    string errorReason = "TestError";
    error testError = error(errorReason);
    error[] errorArray = [testError];
    any anyVal = errorArray;
    error[] errorArrayBack = <error[]>anyVal;
    assertEquality(errorReason, errorArrayBack[0].message());
}

function testAssignIntArrayToJson() {
    int[*] intArray = [1, 2];
    json jsonVar = intArray;
    assertTrue(jsonVar is int[2]);
    int[2] arr = <int[2]>jsonVar;
    assertEquality(1, arr[0]);
    assertEquality(2, arr[1]);
}

function testAssignIntOrStringArrayIntOrFloatOrStringUnionArray() {
    int[]|string[] arr1 = <int[]>[1, 2];
    (int|float)[]|string[] arr2 = arr1;
    assertEquality(1, arr2[0]);
    assertEquality(2, arr2[1]);
}

function testAssignAnyToUnionWithErrorAndAny() {
    any x = 4;
    any|error y = x;
    assertEquality(4, y);
}

type Topt1 record {
    int x?;
    int y?;
};

function testOptionalFieldAssignment1() {
    Topt1 t = {x: 2, y: 4};
    t.x = ();
    assertEquality(t.x, ());
    assertEquality(t.y, 4);
    t.y = ();
    assertEquality(t.x, ());
    assertEquality(t.y, ());
}

type Topt2 record {
    int a;
    record {
        int b?;
    }[1] c;
};

function testOptionalFieldAssignment2() {
    Topt2 t = {a: 2, c: [{b: 4}]};
    (t.c)[0].b = ();
    assertEquality(t.a, 2);
    assertEquality((t.c)[0].b, ());
}

type Topt3 record {
    int x?;
    int? y?;
};

function testOptionalFieldAssignment3() {
    Topt3 t3 = {x: 2, y: 4};
    t3.y = ();
    assertEquality(t3.toString(), "{\"x\":2,\"y\":null}");
    Topt1 t1 = {x: 21, y: 41};
    t1.y = ();
    assertEquality(t1.toString(), "{\"x\":21}");
}

type INTNIL int?;

type Topt4 record {
    int x?;
    INTNIL y?;
};

function testOptionalFieldAssignment4() {
    Topt4 t = {x: 2, y: 4};
    t.y = ();
    assertEquality(t.toString(), "{\"x\":2,\"y\":null}");
    Topt1 t1 = {x: 21, y: 41};
    t1.y = ();
    assertEquality(t1.toString(), "{\"x\":21}");
}

type ValueRecord record {|
    string value;
|};

type TestStream stream<string, error?>;

class TestGenerator {
    public isolated function next() returns ValueRecord|error? {
        return {value: "Ballerina"};
    }
}

function testAssignVarInQueryExpression() {
    xml x1 = xml `<book><a>The Lost World</a><b>Clean Code</b></book>`;
    var x2 = from xml element in x1 select element;
    assertTrue(x2 is xml);
    xml x3 = x2;
    assertEquality(x3, xml `<book><a>The Lost World</a><b>Clean Code</b></book>`);
    var x4 = from xml element in x1/<a> select element;
    assertTrue(x4 is xml<xml:Element>);
    xml x5 = x4;
    assertEquality(x5, xml `<a>The Lost World</a>`);
    var x6 = "string";
    var x7 = from string element in x6 select element;
    assertTrue(x7 is string);
    string x8 = x7;
    assertEquality(x8, "string");
    var x9 = from string element in x6 select "a";
    assertTrue(x9 is string);
    string x10 = x9;
    assertEquality(x10, "aaaaaa");
    var x11 = [1, 2];
    var x12 = [x1, x1];
    var x13 = from int element in x11 select element;
    assertTrue(x13 is int[]);
    int[] x14 = x13;
    assertEquality(x14, <int[]>[1, 2]);
    var x15 = from int element in x11 select 1;
    assertTrue(x15 is int[]);
    int[] x16 = x15;
    assertEquality(x16, <int[]>[1, 1]);
    var x17 = from int element in x11 select string `string ${element}`;
    assertTrue(x17 is string[]);
    string[] x18 = x17;
    assertEquality(x18, <string[]>["string 1", "string 2"]);
    var x19 = from xml element in x12 select element;
    assertTrue(x19 is xml[]);
    xml[] x20 = x19;
    assertEquality(x20, <xml[]>[x1, x1]);
    var x21 = [1, "string 1", true, x1];
    var x22 = from var element in x21 select element;
    assertTrue(x22 is (int|string|boolean|xml)[]);
    (int|string|boolean|xml)[] x23 = x22;
    assertEquality(x23, x21);
    var x24 = from int element in 1...4 select element;
    assertTrue(x24 is int[]);
    int[] x25 = x24;
    assertEquality(x25, <int[]>[1, 2, 3, 4]);
    TestGenerator generator = new();
    TestStream testStream = new(generator);
    var x26 = stream from var _ in testStream select "A";
    assertTrue(x26 is stream<string, error?>);
    var x27 = stream from var _ in testStream select 1;
    assertTrue(x27 is stream<int, error?>);
    var x28 = stream from var _ in testStream select "A";
    assertTrue(x28 is stream<string, error?>);
    var x29 = stream from var _ in testStream select 1;
    assertTrue(x29 is stream<int, error?>);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
        message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

function assertTrue(any|error actual) {
    assertEquality(true, actual);
}

public function main() {
    io:println(testIntAssignStmt(100)); // @output 100
    io:println(testFloatAssignStmt(2.299999952316284)); // @output 2.299999952316284
    io:println(testBooleanAssignStmt(true)); // @output true
    io:println(testStringAssignStmt("Test Value")); // @output Test Value
    io:println(testArrayIndexToIntAssignStmt([150])); // @output 150
    io:println(testIntToArrayAssignStmt(250)); // @output 250
    [int, string, int] multiReturns = testMultiReturn();
    io:println(multiReturns[0]); // @output 5
    io:println(multiReturns[1]); // @output john
    io:println(multiReturns[2]); // @output 6
    io:println(testIntCastFloatStmt(100)); // @output 100.0
    [int, int, string, string, string, value:Cloneable] restResults = restActionResultAssignment();
    io:println(restResults[0]); // @output 0
    io:println(restResults[1]); // @output 0
    io:println(restResults[2]); // @output a
    io:println(restResults[3]); // @output the error reason
    io:println(restResults[4]); // @output foo3 error
    io:println(restResults[5]); // @output 3
    testAssignErrorArrayToAny();
    testAssignIntArrayToJson();
    testAssignIntOrStringArrayIntOrFloatOrStringUnionArray();
    testAssignAnyToUnionWithErrorAndAny();
    testAssignVarInQueryExpression();
    testOptionalFieldAssignment1();
    testOptionalFieldAssignment2();
    testOptionalFieldAssignment3();
    testOptionalFieldAssignment4();
}
