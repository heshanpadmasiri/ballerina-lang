import ballerina/io;

type Person record {
    string name;
};

type Employee record {
    string name;
    boolean intern;
};

Person person1 = {name: "John"};
Employee employee1 = {name: "John", intern: true};

public function main() {
    io:println(basicTupleAssignment()); // @output [1,"s",true,true] [2,"s",true] [3,"s"]
    io:println(tupleAssignmentWithNilRestDescriptor()); // @output [1,"s"] [1,"s",null] [1,"s",null,null] [null,null]
    io:println(tupleAssignmentWithOnlyRestDescriptor()); // @output [1,2] ["s","s"] [null,null]
    io:println(tupleCovarianceWithRestDescriptor().toCodePointInts()); // @output [115,32,123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32,123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32,123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32]
    io:println(tupleCovarianceWithOnlyRestDescriptor().toCodePointInts()); // @output [123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32,123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32,123,34,110,97,109,101,34,58,34,74,111,104,110,34,44,34,105,110,116,101,114,110,34,58,116,114,117,101,125,32]
    io:println(testFunctionInvocation().toCodePointInts()); // @output [121,32,53,46,48,32,116,114,117,101,32,102,97,108,115,101,32]
    io:println(testFunctionReturnValue().toCodePointInts()); // @output [120,32,53,46,48,32,116,114,117,101,32,102,97,108,115,101,32]
    io:println(testIndexBasedAccess().toCodePointInts()); // @output [102,97,108,115,101,32,97,49,32,98,49,32,99,49,32]
    testToStringRepresentation();
    testSubTypingWithRestDescriptorPositive();
    testSubTypingWithRestDescriptorNegative();
    testRestVariablesWithArray();
}

function basicTupleAssignment() returns string {
    [int, string, boolean...] t = [1, "s", true, true];
    [int, string, boolean...] t1 = [2, "s", true];
    [int, string, boolean...] t2 = [3, "s"];
    return t.toString() + " " + t1.toString() + " " + t2.toString();
}

function tupleAssignmentWithNilRestDescriptor() returns string {
    [int, string, ()...] t = [1, "s"];
    [int, string, ()...] t1 = [1, "s", ()];
    [int, string, ()...] t2 = [1, "s", (), ()];
    [(()|())...] t3 = [(), ()];
    return t.toString() + " " + t1.toString() + " " + t2.toString() + " " + t3.toString();
}

function tupleAssignmentWithOnlyRestDescriptor() returns string {
    [int...] t = [1, 2];
    [string...] t1 = ["s", "s"];
    [()...] t2 = [(), ()];
    return t.toString() + " " + t1.toString() + " " + t2.toString();
}

function tupleCovarianceWithRestDescriptor() returns string {
    [string, Employee...] e = ["s", employee1, employee1, employee1];
    [string, Person...] t = e;
    string s = "";
    foreach var i in t {
        s += i.toString() + " ";
    }
    return s;
}

function tupleCovarianceWithOnlyRestDescriptor() returns string {
    [Employee...] e = [employee1, employee1, employee1];
    [Person...] t = e;
    string s = "";
    foreach var i in t {
        s += i.toString() + " ";
    }
    return s;
}

function testFunctionInvocation() returns string {
    [string, float, boolean...] t = ["y", 5.0, true, false];
    return testTuples(t);
}

function testTuples([string, float, boolean...] t) returns string {
    string s = "";
    foreach var i in t {
        s += i.toString() + " ";
    }
    return s;
}

function testFunctionReturnValue() returns string {
    [string, float, boolean...] t = testReturnTuples("x");
    string s = "";
    foreach var i in t {
        s += i.toString() + " ";
    }
    return s;
}

function testReturnTuples(string a) returns [string, float, boolean...] {
    [string, float, boolean...] t = [a, 5.0, true, false];
    return t;
}

function testIndexBasedAccess() returns string {
    [boolean, string...] t = [true, "a", "b", "c"];
    boolean tempBool = t[0];
    string tempStringA = t[1];
    string tempStringB = t[2];
    string tempStringC = t[3];
    t[0] = false;
    t[1] = "a1";
    t[2] = "b1";
    t[3] = "c1";
    string s = "";
    foreach var i in t {
        s += i.toString() + " ";
    }
    return s;
}

function testToStringRepresentation() {
    [string, int, int[]...] t1 = ["records", 100];
    [int, (string|boolean)...] t2 = [1, true];
    [[int...]...] t3 = [[1, 2], [1, 2, 3]];

    assertEquality("typedesc [string,int,int[]...]", (typeof t1).toString());
    assertEquality("typedesc [int,(string|boolean)...]", (typeof t2).toString());
    assertEquality("typedesc [[int...]...]", (typeof t3).toString());
}

function testSubTypingWithRestDescriptorPositive() {
    [int, (string|int)...] a = [1, 10, "foo"];
    any v1 = a;
    [int|boolean, anydata...] b = a;
    [int|string...] c = a;
    (int|string)[] d = a;
    assertTrue(v1 is [int|boolean, anydata...]);
    assertTrue(v1 is [int|string...]);
    assertTrue(v1 is (int|string)[]);

    int[3] e = [1, 2, 3];
    any v2 = e;
    [int, int...] f = e;
    [int, int, int...] g = e;
    [int, int, int, int...] h = e;
    [int, int, int] i = e;
    [int...] j = e;
    assertTrue(v2 is [int, int...]);
    assertTrue(v2 is [int, int, int...]);
    assertTrue(v2 is [int, int, int, int...]);
    assertTrue(v2 is [int, int, int]);
    assertTrue(v2 is [int...]);

    [int...] k = [1, 2, 3];
    any v3 = k;
    int[] l = k;
    assertTrue(v3 is int[]);
}

function testSubTypingWithRestDescriptorNegative() {
    [int, (string|int)...] a = [1, 10, "foo"];
    any v1 = a;
    assertTrue(v1 is [int, (string|int)...]);
    assertFalse(v1 is [int, string|int, string|int...]);
    assertFalse(v1 is [int, string...]);
    assertFalse(v1 is [int]);

    int[3] e = [1, 2, 3];
    any v2 = e;
    assertTrue(v2 is int[3]);
    assertFalse(v2 is [int, int, int, int, int...]);
    assertFalse(v2 is [int, string...]);
    assertFalse(v2 is [string, string, string, string]);
}

function testRestVariablesWithArray() {
    int[] [...a] = [1, 2];
    int[] _ = a;
    assertEquality(a, <int[]>[1, 2]);

    [int...] [...a2] = [1, 2];
    int[] _ = a2;
    assertEquality(a2, <[int...]>[1, 2]);

    int[2] [...a3] = [1, 2];
    assertEquality(a3, <int[2]>[1, 2]);

    string[] [...s] = ["string 1", "string 2"];
    string[] _ = s;
    assertEquality(s, <string[]>["string 1", "string 2"]);

    [string...] [...s2] = ["string 1", "string 2"];
    string[] _ = s2;
    assertEquality(s2, <[string...]>["string 1", "string 2"]);

    string[2] [...s3] = ["string 1", "string 2"];
    assertEquality(s3, <string[2]>["string 1", "string 2"]);
}

function assertTrue(any|error actual) {
    assertEquality(true, actual);
}

function assertFalse(any|error actual) {
    assertEquality(false, actual);
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    panic error("expected '" + (expected is error ? expected.toString() : expected.toString()) + "', found '" +
                    (actual is error ? actual.toString() : actual.toString()) + "'");
}
