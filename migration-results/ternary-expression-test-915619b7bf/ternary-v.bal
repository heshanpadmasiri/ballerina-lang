import ballerina/io;

public function main() returns error? {
    io:println(test1(20)); // @output 15
    io:println(test1(4)); // @output 5
    io:println(test2(100)); // @output large
    io:println(test2(2)); // @output small
    io:println(test3(10)); // @output 10.5
    io:println(test3(20)); // @output 9.5
    io:println(test4(20)); // @output if
    io:println(test4(100)); // @output else
    io:println(test5(10)); // @output 10tenfalse
    io:println(test5(100)); // @output 10othertrue
    io:println(test6("admin")); // @output super
    io:println(test6("no user")); // @output tom
    io:println(check test7("one")); // @output 1
    io:println(check test7("two")); // @output 2
    io:println(test8("world")); // @output hello world...!!
    io:println(test8("foo")); // @output hello everyone..!
    io:println(test9("a")); // @output bax
    io:println(test9("b")); // @output bar
    io:println(test10("tom")); // @output {"name":"tom","location":"US"}
    io:println(test10("bob")); // @output {"name":"bob","location":"UK"}

    [string, string] r1 = testNestedTernary1(80);
    io:println(r1[0]); // @output morethan70
    io:println(r1[1]); // @output morethan70
    r1 = testNestedTernary1(50);
    io:println(r1[0]); // @output morethan40
    io:println(r1[1]); // @output morethan40
    r1 = testNestedTernary1(30);
    io:println(r1[0]); // @output morethan20
    io:println(r1[1]); // @output morethan20
    r1 = testNestedTernary1(15);
    io:println(r1[0]); // @output lessthan20
    io:println(r1[1]); // @output lessthan20

    [string, string] r2 = testNestedTernary2(80);
    io:println(r2[0]); // @output morethan70
    io:println(r2[1]); // @output morethan70
    r2 = testNestedTernary2(50);
    io:println(r2[0]); // @output lessthan70
    io:println(r2[1]); // @output lessthan70
    r2 = testNestedTernary2(30);
    io:println(r2[0]); // @output morethan20
    io:println(r2[1]); // @output morethan20
    r2 = testNestedTernary2(15);
    io:println(r2[0]); // @output lessthan20
    io:println(r2[1]); // @output lessthan20

    [string, string] r3 = testNestedTernary3(80);
    io:println(r3[0]); // @output morethan45
    io:println(r3[1]); // @output morethan45
    r3 = testNestedTernary3(35);
    io:println(r3[0]); // @output morethan30
    io:println(r3[1]); // @output morethan30
    r3 = testNestedTernary3(25);
    io:println(r3[0]); // @output lessthan30
    io:println(r3[1]); // @output lessthan30

    [string, string] r4 = testNestedTernary4(80);
    io:println(r4[0]); // @output morethan70
    io:println(r4[1]); // @output morethan70
    r4 = testNestedTernary4(55);
    io:println(r4[0]); // @output morethan50
    io:println(r4[1]); // @output morethan50
    r4 = testNestedTernary4(45);
    io:println(r4[0]); // @output lessthan50
    io:println(r4[1]); // @output lessthan50
    r4 = testNestedTernary4(15);
    io:println(r4[0]); // @output lessthan20
    io:println(r4[1]); // @output lessthan20

    [string, string] r5 = testNestedTernary5(80);
    io:println(r5[0]); // @output morethan50
    io:println(r5[1]); // @output morethan50
    r5 = testNestedTernary5(45);
    io:println(r5[0]); // @output morethan40
    io:println(r5[1]); // @output morethan40
    r5 = testNestedTernary5(35);
    io:println(r5[0]); // @output lessthan40
    io:println(r5[1]); // @output lessthan40
    r5 = testNestedTernary5(25);
    io:println(r5[0]); // @output morethan20
    io:println(r5[1]); // @output morethan20

    io:println(check testErrorInTernary()); // @output 7
    io:println(testPredeclPrefixInTernary()); // @output 11
    testTernaryAsArgument();
    testIfAndThenExprBeingFieldAccess();
    testTernaryWithConfigurableVar();
    testTernaryWithLangValueMethodCallsModuleLevel();
    testTernaryWithLangValueMethodCalls();
    testTernaryWithOtherOperators();
    testTernaryInModuleLevel();
    testTernaryWithQueryWithLocalVariable();
    testTernaryWithQueryWithFunctionParameter();
    testTernaryWithQueryWithTypeDef();
    testTernaryWithQueryWithModuleVariable();
    testTernaryWithQueryForTwoVariables();
    testTernaryWithQueryWithFunctionPointers();
    testTernaryWithQueryWithFunctionAsClosure();
}

function test1(int value) returns int {
    int x = value > 10 ? 15 : 5;
    return x;
}
function test2(int value) returns string {
    var x = 10 <= value ? "large" : "small";
    return x;
}
function test3(int value) returns float {
    float x = value == 10 ? 10.5 : 9.5;
    return x;
}
function test4(int value) returns string {
    if (value == 20 ? true : false) {
        return "if";
    }
    return "else";
}
function test5(int value) returns string => foo(10, value == 10 ? "ten" : "other", value != 10);
function foo(int a, string b, boolean c) returns string => a.toString() + b + c.toString();

type Person record { string name; string location?; };
function test6(string s) returns string { Person p = {name: s == "admin" ? "super" : "tom"}; return p.name; }
function test7(string s) returns int|error { map<any> m = {"data": s == "one" ? 1 : 2}; return <int>m["data"]; }
function test8(string s) returns string => string `hello ${s == "world" ? "world...!!" : "everyone..!"}`;
function test9(string s) returns string => s == "a" ? bax() : bar();
function bax() returns string => "bax";
function bar() returns string => "bar";
function test10(string s) returns Person { Person tom = {name: "tom", location: "US"}; Person bob = {name: "bob", location: "UK"}; return s == "tom" ? tom : bob; }

function testNestedTernary1(int value) returns [string, string] {
    string s1 = value > 70 ? "morethan70" : value > 40 ? "morethan40" : value > 20 ? "morethan20" : "lessthan20";
    string s2 = value > 70 ? "morethan70" : (value > 40 ? "morethan40" : (value > 20 ? "morethan20" : "lessthan20"));
    return [s1, s2];
}
function testNestedTernary2(int value) returns [string, string] {
    string s1 = value > 40 ? value > 70 ? "morethan70" : "lessthan70" : value > 20 ? "morethan20" : "lessthan20";
    string s2 = value > 40 ? (value > 70 ? "morethan70" : "lessthan70") : (value > 20 ? "morethan20" : "lessthan20");
    return [s1, s2];
}
function testNestedTernary3(int value) returns [string, string] {
    string s1 = value < 40 ? value > 20 ? value < 30 ? "lessthan30" : "morethan30" : "lessthan20" : value > 45 ? "morethan45" : "lessthan45";
    string s2 = value < 40 ? (value > 20 ? (value < 30 ? "lessthan30" : "morethan30") : "lessthan20") : (value > 45 ? "morethan45" : "lessthan45");
    return [s1, s2];
}
function testNestedTernary4(int value) returns [string, string] {
    string s1 = value > 40 ? value > 70 ? "morethan70" : value > 50 ? "morethan50" : "lessthan50" : value > 20 ? "morethan20" : "lessthan20";
    string s2 = value > 40 ? (value > 70 ? "morethan70" : (value > 50 ? "morethan50" : "lessthan50")) : (value > 20 ? "morethan20" : "lessthan20");
    return [s1, s2];
}
function testNestedTernary5(int value) returns [string, string] {
    string s1 = value > 50 ? "morethan50" : value > 30 ? value > 40 ? "morethan40" : "lessthan40" : value > 20 ? "morethan20" : "lessthan20";
    string s2 = value > 50 ? "morethan50" : (value > 30 ? (value > 40 ? "morethan40" : "lessthan40") : (value > 20 ? "morethan20" : "lessthan20"));
    return [s1, s2];
}

function testErrorInTernary() returns int|error { int x = 8; return x > 5 ? decrement(x) : increment(x); }
function decrement(int i) returns int|error => i - 1;
function increment(int i) returns int|error => i + 1;
function testPredeclPrefixInTernary() returns int => true ? int:sum(5, 6) : 5;

function testTernaryAsArgument() {
    string[] filters = [];
    boolean trueVal = true;
    boolean falseVal = false;
    string s1 = trueVal ? "str" : "";
    filters.push(s1);
    filters.push(trueVal ? "str" : "");
    string s2 = falseVal ? "str" : "";
    filters.push(s2);
    filters.push(falseVal ? "str" : "");
    byte[] a = [];
    a.push(trueVal ? 0 : 255);
    a.push(falseVal ? 0 : 255);
    assertEquals("str", filters[0]); assertEquals("", filters[2]); assertEquals(filters[0], filters[1]); assertEquals(filters[2], filters[3]); assertEquals(0, a[0]); assertEquals(255, a[1]);
}
boolean bool = true;
configurable string CONFIGURABLE_1 = bool ? "val1" : "val2";
configurable int CONFIGURABLE_2 = bool ? 1 : 0;
configurable string CONFIGURABLE_3 = bool ? !bool ? "val1" : "val2" : "val3";
configurable int|string CONFIGURABLE_4 = bool ? 1 : "invalid";
function testTernaryWithConfigurableVar() { assertEquals("val1", CONFIGURABLE_1); assertEquals(1, CONFIGURABLE_2); assertEquals("val2", CONFIGURABLE_3); assertEquals(1, CONFIGURABLE_4); }

type Point record {| int x; int y; |};
function testIfAndThenExprBeingFieldAccess() { boolean b = true; Point p = {x: 2, y: 4}; assertEquals(2, b ? p.x : p.y); }

int|() x1 = (); int y1 = 3000; boolean cond = true;
string b1 = (cond ? x1 : y1).toBalString(); string b2 = (cond ? y1 : x1).toString();
int x2 = 123; string y2 = "a";
string b3 = (cond ? x2 : y2).toBalString(); string b4 = (cond ? y2 : x2).toString(); string b5 = (cond ? (cond ? (cond ? y2 : x2) : x2) : x2).toString(); string b6 = (cond ? (cond ? x2 : (cond ? x2 : y2)) : (cond ? x2 : y2)).toString();
int x3 = -9223372036854775807; float y3 = 2.12;
string b7 = (cond ? x3 : y3).toBalString(); string b8 = (cond ? y3 : x3).toString();
decimal x4 = 123.12; float y4 = 211.43;
string b9 = (cond ? x4 : y4).toBalString(); string b10 = (cond ? y4 : x4).toString();
int x5 = 123; byte y5 = 250;
string b11 = (cond ? x5 : y5).toBalString(); string b12 = (cond ? y5 : x5).toString();
int x6 = 123; int:Signed16 y6 = -32000;
string b13 = (cond ? x6 : y6).toBalString(); string b14 = (cond ? y6 : x6).toString();
int:Unsigned8 x7 = 223; int:Signed8 y7 = -128;
string b15 = (cond ? x7 : y7).toBalString(); string b16 = (cond ? y7 : x7).toString(); string b17 = (cond ? (cond ? (cond ? y7 : x7) : x7) : x7).toBalString(); string b18 = (cond ? (cond ? x4 : (cond ? y1 : x3)) : (cond ? y7 : x7)).toString();
string x8 = "abc"; string:Char y8 = "a";
string b19 = (cond ? x8 : y8).toString(); string b20 = (cond ? y8 : x8).toString(); string b21 = (cond ? (cond ? (cond ? y1 : x3) : y8) : x8).toBalString(); string b22 = (cond ? (cond ? x3 : (cond ? y6 : x7)) : (cond ? y8 : x8)).toString();
int x9 = 123; json y9 = "a";
string b23 = (cond ? x9 : y9).toBalString(); string b24 = (cond ? y9 : x9).toString();
function testTernaryWithLangValueMethodCallsModuleLevel() {
    assertEquals("()", b1); assertEquals("3000", b2); assertEquals("()", b1); assertEquals("3000", b2); assertEquals("123", b3); assertEquals("a", b4); assertEquals("a", b5); assertEquals("123", b6); assertEquals("-9223372036854775807", b7); assertEquals("2.12", b8); assertEquals("123.12d", b9); assertEquals("211.43", b10); assertEquals("123", b11); assertEquals("250", b12); assertEquals("123", b13); assertEquals("-32000", b14); assertEquals("223", b15); assertEquals("-128", b16); assertEquals("-128", b17); assertEquals("123.12", b18); assertEquals("abc", b19); assertEquals("a", b20); assertEquals("3000", b21); assertEquals("-9223372036854775807", b22); assertEquals("123", b23); assertEquals("a", b24);
}
function testTernaryWithLangValueMethodCalls() {
    int|() x10 = (); int y10 = 3000; assertEquals("()", (cond ? x10 : y10).toBalString()); assertEquals("3000", (cond ? y10 : x10).toString());
    int x11 = 123; string y11 = "a"; assertEquals("123", (cond ? x11 : y11).toBalString()); assertEquals("a", (cond ? y11 : x11).toString()); assertEquals("a", (cond ? (cond ? (cond ? y11 : x11) : x11) : x11).toString()); assertEquals("123", (cond ? (cond ? x11 : (cond ? x11 : y11)) : (cond ? x11 : y11)).toString());
    int x12 = -9223372036854775807; float y12 = 2.12; assertEquals("-9223372036854775807", (cond ? x12 : y12).toBalString()); assertEquals("2.12", (cond ? y12 : x12).toString());
    decimal x13 = 123.12; float y13 = 211.43; assertEquals("123.12d", (cond ? x13 : y13).toBalString()); assertEquals("211.43", (cond ? y13 : x13).toString());
    int x14 = 123; byte y14 = 250; assertEquals("123", (cond ? x14 : y14).toBalString()); assertEquals("250", (cond ? y14 : x14).toString());
    int x15 = 123; int:Signed16 y15 = -32000; assertEquals("123", (cond ? x15 : y15).toBalString()); assertEquals("-32000", (cond ? y15 : x15).toString());
    int:Unsigned8 x16 = 223; int:Signed8 y16 = -128; assertEquals("223", (cond ? x16 : y16).toBalString()); assertEquals("-128", (cond ? y16 : x16).toString()); assertEquals("-128", (cond ? (cond ? (cond ? y16 : x14) : x16) : x16).toBalString()); assertEquals("123", (cond ? (cond ? x15 : (cond ? y12 : x14)) : (cond ? y16 : x16)).toString());
    string x17 = "abc"; string:Char y17 = "a"; assertEquals("abc", (cond ? x17 : y17).toString()); assertEquals("a", (cond ? y17 : x17).toString()); assertEquals("3000", (cond ? (cond ? (cond ? y10 : x12) : y17) : x17).toBalString()); assertEquals("-9223372036854775807", (cond ? (cond ? x12 : (cond ? y15 : x16)) : (cond ? y17 : x17)).toString());
    int x18 = 123; json y18 = "a"; assertEquals("123", (cond ? x18 : y18).toBalString()); assertEquals("a", (cond ? y18 : x18).toString());
}

function testTernaryWithQueryWithLocalVariable() {
    int? i = 3;

    int|int[] thenResult = i is int ?
        from var _ in [1, 2]
        where i + 2 == 5
        select 2 : 2;
    assertEquals([2, 2], thenResult);

    int|int[] elseResult = i is () ? 2 :
        from var _ in [1, 2]
        where i + 2 == 5
        select 2;
    assertEquals([2, 2], elseResult);
}

function testTernaryWithQueryWithFunctionParameter() {
    int? x = 3;
    ternaryWithQueryWithFunctionParameter(x);
}

function ternaryWithQueryWithFunctionParameter(int? i) {
    int|int[] thenResult = i is int ?
        from var _ in [1, 2]
        where i + 2 == 5
        select 2 : 2;
    assertEquals([2, 2], thenResult);

    int|int[] elseResult = i is () ? 2 :
        from var _ in [1, 2]
        where i + 2 == 5
        select 2;
    assertEquals([2, 2], elseResult);
}

int? i = 3;
function testTernaryWithQueryWithModuleVariable() {
    int|int[] thenResult = i is int ?
        from var _ in [1, 2]
        where i + 2 == 5
        select 2 : 2;
    assertEquals([2, 2], thenResult);

    int|int[] elseResult = i is () ? 2 :
        from var _ in [1, 2]
        where i + 2 == 5
        select 2;
    assertEquals([2, 2], elseResult);
}

type A int?;
A a = 3;
function testTernaryWithQueryWithTypeDef() {
    int|int[] thenResult = a is int ?
        from var _ in [1, 2]
        where a + 2 == 5
        select 2 : 2;
    assertEquals([2, 2], thenResult);

    int|int[] elseResult = a is () ? 2 :
        from var _ in [1, 2]
        where a + 2 == 5
        select 2;
    assertEquals([2, 2], elseResult);
}
function testTernaryWithQueryForTwoVariables() { int? a = 3; int? b = (); int|int[] t = a != b ? from var _ in [1, 2] where a + 2 == 5 select 2 : 2; assertEquals([2, 2], t); int|int[] e = a == b ? 2 : from var _ in [1, 2] where a + 2 == 5 select 2; assertEquals([2, 2], e); }
function testTernaryWithQueryWithFunctionPointers() { int? i = 3; var k = function() returns int? { return i; }; int|int[] t = i is int ? from var _ in [1, 2] where k() + 2 == 5 select 2 : 2; assertEquals([2, 2], t); int|int[] e = i is () ? 2 : from var _ in [1, 2] where k() + 2 == 5 select 2; assertEquals([2, 2], e); }
function testTernaryWithQueryWithFunctionAsClosure() { ()|function() returns int fn = function() returns int { return 3; }; int|int[] t = fn !is () ? from var _ in [1, 2] where fn() + 2 == 5 select 2 : 2; assertEquals([2, 2], t); int|int[] e = fn is () ? 2 : from var _ in [1, 2] where fn() + 2 == 5 select 2; assertEquals([2, 2], e); }

boolean cond2 = true; int i1 = 10; byte j1 = 100; int k1 = (cond2 ? i1 : j1) * i1; int k2 = (cond2 ? i1 : j1) * j1; int k3 = (cond2 ? i1 : j1) / i1; int k4 = (cond2 ? j1 : i1) % i1;
function testTernaryWithOtherOperators() { assertEquals(100, k1); assertEquals(1000, k2); assertEquals(1, k3); assertEquals(0, k4); }
boolean bool2 = true; int e1 = 10; int e2 = 1; int t1 = bool2 ? e1 : e2; int t2 = !bool2 ? e1 : e2;
function testTernaryInModuleLevel() { assertEquals(10, t1); assertEquals(1, t2); }
const ASSERTION_ERROR_REASON = "AssertionError";
function assertEquals(anydata expected, anydata actual) { if expected != actual { panic error(ASSERTION_ERROR_REASON, message = "assertion failed"); } }
