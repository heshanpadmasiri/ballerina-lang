import ballerina/io;
import ballerina/lang.regexp;

public function main() {
    io:println(testElvisValueTypePositive()); // @output 120
    io:println(testElvisValueTypeNegative()); // @output 111
    io:println(testElvisValueTypeNested()); // @output 3000
    int|string refPositive = testElvisRefTypePositive();
    assertTrue(refPositive is int);
    io:println(refPositive); // @output 2300
    int|string refNegative = testElvisRefTypeNegative();
    assertTrue(refNegative is int);
    io:println(refNegative); // @output 111
    int|string refNested = testElvisRefTypeNested();
    assertTrue(refNested is int);
    io:println(refNested); // @output 4000
    io:println(testElvisRefTypeNestedCaseTwo()); // @output kevin
    [string, int] recordPositive = testElvisRecordTypePositive();
    io:println(recordPositive[0]); // @output Jim
    io:println(recordPositive[1]); // @output 100
    [string, int] recordNegative = testElvisRecordTypeNegative();
    io:println(recordNegative[0]); // @output default
    io:println(recordNegative[1]); // @output 0
    [string, int, string] objectPositive = testElvisObjectTypePositive();
    io:println(objectPositive[0]); // @output Alice
    io:println(objectPositive[1]); // @output 15
    io:println(objectPositive[2]); // @output Maths
    [string, int, string] objectNegative = testElvisObjectTypeNegative();
    io:println(objectNegative[0]); // @output Bob
    io:println(objectNegative[1]); // @output 18
    io:println(objectNegative[2]); // @output Science
    [string, int] tuplePositive = testElvisTupleTypePositive();
    io:println(tuplePositive[0]); // @output Jack
    io:println(tuplePositive[1]); // @output 23
    [string, int] tupleNegative = testElvisTupleTypeNegative();
    io:println(tupleNegative[0]); // @output default
    io:println(tupleNegative[1]); // @output 0
    [string, int] nestedTupleOne = testElvisNestedTupleTypeCaseOne();
    io:println(nestedTupleOne[0]); // @output Jack
    io:println(nestedTupleOne[1]); // @output 23
    [string, int] nestedTupleTwo = testElvisNestedTupleTypeCaseTwo();
    io:println(nestedTupleTwo[0]); // @output Jill
    io:println(nestedTupleTwo[1]); // @output 77
    [string, int] nestedTupleThree = testElvisNestedTupleTypeCaseThree();
    io:println(nestedTupleThree[0]); // @output default
    io:println(nestedTupleThree[1]); // @output 0
    testElvisAsArgumentPositive();
    testElvisWithConfigurableVar();
    testElvisWithLangValueMethodCallsModuleLevel();
    testElvisWithLangValueMethodCalls();
    testNestedElvisWithoutParenthesisModuleLevel();
    testNestedElvisWithoutParenthesis();
    testElvisExprWithTypeRefType();
    testElvisExprWithIntersectionTypes();
    testElvisExprWithBuiltInNilableUnion();
    testElvisExprWithJson();
    testElvisExprWithAnydata();
    testElvisExprWithFiniteType();
    testElvisExprWithUnionWithFiniteTypeContainingNull();
    testElvisExprWithQuery();
}

function testElvisValueTypePositive() returns int { int|() x = 120; return x ?: 111; }
function testElvisValueTypeNegative() returns int { int|() x = (); return x ?: 111; }
function testElvisValueTypeNested() returns int { int|() x = (); int|() y = 3000; return x ?: (y ?: 1300); }
function testElvisRefTypePositive() returns int|string { int|string|() x = 2300; return x ?: 111; }
function testElvisRefTypeNegative() returns int|string { int|string|() x = (); return x ?: 111; }
function testElvisRefTypeNested() returns int|string { int|string|() x = (); int|string|() y = (); int|string c = 4000; return x ?: (y ?: c); }
function testElvisRefTypeNestedCaseTwo() returns int|string { int|string|() x = (); int|string|() y = "kevin"; int|string c = 4000; return x ?: (y ?: c); }

type Person record { string name; int age; };
function testElvisRecordTypePositive() returns [string, int] { Person|() x = {name: "Jim", age: 100}; Person d = {name: "default", age: 0}; Person b = x ?: d; return [b.name, b.age]; }
function testElvisRecordTypeNegative() returns [string, int] { Person|() x = (); Person d = {name: "default", age: 0}; Person b = x ?: d; return [b.name, b.age]; }

class Student {
    public string name;
    public int age;
    public string favSubject;
    function init(string n, int a, string favSub = "Maths") { self.name = n; self.age = a; self.favSubject = favSub; }
}
function testElvisObjectTypePositive() returns [string, int, string] { Student|() first = new Student("Alice", 15); Student second = new ("Bob", 18, favSub = "Science"); Student student = first ?: second; return [student.name, student.age, student.favSubject]; }
function testElvisObjectTypeNegative() returns [string, int, string] { Student|() first = (); Student second = new ("Bob", 18, favSub = "Science"); Student student = first ?: second; return [student.name, student.age, student.favSubject]; }

function testElvisTupleTypePositive() returns [string, int] { [string, int]|() x = ["Jack", 23]; [string, int] d = ["default", 0]; return x ?: d; }
function testElvisTupleTypeNegative() returns [string, int] { [string, int]|() x = (); [string, int] d = ["default", 0]; return x ?: d; }
function testElvisNestedTupleTypeCaseOne() returns [string, int] { [string, int]|() x = ["Jack", 23]; [string, int]|() y = ["Jill", 77]; [string, int] d = ["default", 0]; return x ?: (y ?: d); }
function testElvisNestedTupleTypeCaseTwo() returns [string, int] { [string, int]|() x = (); [string, int]|() y = ["Jill", 77]; [string, int] d = ["default", 0]; return x ?: (y ?: d); }
function testElvisNestedTupleTypeCaseThree() returns [string, int] { [string, int]|() x = (); [string, int]|() y = (); [string, int] d = ["default", 0]; return x ?: (y ?: d); }

function testElvisAsArgumentPositive() {
    string[] filters = []; string? first = (); string s1 = first ?: ""; filters.push(s1); filters.push(first ?: "");
    string? second = "str"; string s2 = second ?: ""; filters.push(s2); filters.push(second ?: "");
    byte[] values = []; byte? value = (); values.push(value ?: 255); values.push(value ?: 0);
    assertEquals(filters[0], ""); assertEquals(filters[2], "str"); assertEquals(filters[0], filters[1]); assertEquals(filters[2], filters[3]); assertEquals(values[0], 255); assertEquals(values[1], 0);
}

int? nilVal = (); string? stringOrNilVal = "dummyStr"; int? intOrNilVal = 1;
configurable string CONFIGURABLE_1 = stringOrNilVal ?: "val2";
configurable int CONFIGURABLE_2 = intOrNilVal ?: -1;
configurable int|string CONFIGURABLE_3 = nilVal ?: stringOrNilVal ?: "val2";
configurable int|string CONFIGURABLE_4 = stringOrNilVal ?: -1;
function testElvisWithConfigurableVar() { assertEquals(CONFIGURABLE_1, "dummyStr"); assertEquals(CONFIGURABLE_2, 1); assertEquals(CONFIGURABLE_3, "dummyStr"); assertEquals(CONFIGURABLE_4, "dummyStr"); }

int|() x1 = (); int|() y1 = 3000; string a1 = (x1 ?: y1).toBalString();
int|() y2 = (); string a2 = (x1 ?: y2).toBalString(); string y3 = "a"; string a3 = (x1 ?: y3).toString();
int|() x2 = 1; string a4 = (x2 ?: y3).toBalString(); int:Signed8 y4 = 127; string a5 = (x2 ?: y4).toString(); string a6 = (x1 ?: y4).toString();
byte y5 = 255; string a7 = (x1 ?: y5).toString(); int|() x3 = -9223372036854775807; string a8 = (x3 ?: y5).toString(); float y6 = 123.12; string a9 = (x3 ?: y6).toString(); string a10 = (x1 ?: y6).toString();
decimal|() x4 = (); float y7 = -12.312; string a11 = (x4 ?: y7).toBalString(); decimal|() x5 = 1.12321; string a12 = (x5 ?: y7).toString();
string:Char|() x6 = (); string y8 = "b"; string a13 = (x6 ?: y8).toString(); string:Char|() x7 = "a"; string a14 = (x7 ?: y8).toString(); boolean? x8 = (); int[]|() y9 = [1, 3]; string a15 = (x8 ?: y9).toBalString(); boolean? x9 = true; string a16 = (x9 ?: y9).toBalString();
function testElvisWithLangValueMethodCallsModuleLevel() { assertEquals("3000", a1); assertEquals("()", a2); assertEquals("a", a3); assertEquals("1", a4); assertEquals("1", a5); assertEquals("127", a6); assertEquals("255", a7); assertEquals("-9223372036854775807", a8); assertEquals("-9223372036854775807", a9); assertEquals("123.12", a10); assertEquals("-12.312", a11); assertEquals("1.12321", a12); assertEquals("b", a13); assertEquals("a", a14); assertEquals("[1,3]", a15); assertEquals("true", a16); }
function testElvisWithLangValueMethodCalls() {
    int|() x = (); int|() y = 3000; string b = (x ?: y).toBalString(); assertEquals("3000", b); y = (); b = (x ?: y).toBalString(); assertEquals("()", b); string text = "a"; b = (x ?: text).toString(); assertEquals("a", b); x = 1; b = (x ?: text).toBalString(); assertEquals("1", b); int:Signed8 signed = 127; b = (x ?: signed).toString(); assertEquals("1", b); x = (); b = (x ?: signed).toString(); assertEquals("127", b); byte bytes = 255; b = (x ?: bytes).toString(); assertEquals("255", b); x = -9223372036854775807; b = (x ?: bytes).toString(); assertEquals("-9223372036854775807", b); float floatValue = 123.12; b = (x ?: floatValue).toString(); assertEquals("-9223372036854775807", b); x = (); b = (x ?: floatValue).toString(); assertEquals("123.12", b); decimal|() decimalValue = (); float negative = -12.312; b = (decimalValue ?: negative).toBalString(); assertEquals("-12.312", b); decimalValue = 1.12321; b = (decimalValue ?: negative).toString(); assertEquals("1.12321", b); string:Char|() character = (); string fallback = "b"; b = (character ?: fallback).toString(); assertEquals("b", b); character = "a"; b = (character ?: fallback).toString(); assertEquals("a", b); boolean? bool = (); int[]|() array = [1, 3]; b = (bool ?: array).toBalString(); assertEquals("[1,3]", b); bool = true; b = (bool ?: array).toBalString(); assertEquals("true", b);
}

string? x14 = (); string? y18 = (); string:Char? z1 = "v"; string? elvisOutput1 = x14 ?: y18 ?: z1; string? x15 = "a"; string? elvisOutput2 = x15 ?: y18 ?: z1; string? x16 = (); string? y19 = "b"; string? elvisOutput3 = x16 ?: y19 ?: z1; string? x17 = "a"; string? elvisOutput4 = x17 ?: y19 ?: z1; string? elvisOutput5 = x17 ?: y19 ?: z1 ?: x14 ?: y19 ?: x15; string? elvisOutput6 = x16 ?: y18 ?: x14 ?: y18 ?: z1 ?: x15; int? x18 = (); byte? y20 = 255; () z2 = (); int? elvisOutput7 = x18 ?: y20 ?: z2; int? x19 = (); int:Unsigned8? y21 = 255; int:Signed8? z3 = -128; int? elvisOutput8 = x19 ?: y21 ?: z3; decimal? x20 = (); float? y22 = 1.213123; int:Signed8? z4 = -128; float|decimal|int:Signed8? elvisOutput9 = x20 ?: y22 ?: z4;
function testNestedElvisWithoutParenthesisModuleLevel() { assertEquals("v", elvisOutput1); assertEquals("a", elvisOutput2); assertEquals("b", elvisOutput3); assertEquals("a", elvisOutput4); assertEquals("a", elvisOutput5); assertEquals("v", elvisOutput6); assertEquals(255, elvisOutput7); assertEquals(255, elvisOutput8); assertEquals(1.213123, elvisOutput9); }
function testNestedElvisWithoutParenthesis() {
    string? x = (); string? y = (); string:Char? z = "v"; string? o1 = x ?: y ?: z;
    string? a = "a"; string? b = "b"; string? o2 = a ?: y ?: z; string? o3 = x ?: b ?: z;
    string? o4 = a ?: b ?: z; string? o5 = a ?: b ?: z ?: x ?: b ?: a; string? o6 = x ?: y ?: x ?: y ?: z ?: a;
    int? number = (); byte? byteValue = 255; () nil = (); int? o7 = number ?: byteValue ?: nil;
    int? number2 = (); int:Unsigned8? unsigned = 255; int:Signed8? signed = -128; int? o8 = number2 ?: unsigned ?: signed;
    decimal? decimalValue = (); float? floatValue = 1.213123; int:Signed8? signed2 = -128; float|decimal|int:Signed8? o9 = decimalValue ?: floatValue ?: signed2;
    assertEquals("v", o1); assertEquals("a", o2); assertEquals("b", o3); assertEquals("a", o4); assertEquals("a", o5); assertEquals("v", o6); assertEquals(255, o7); assertEquals(255, o8); assertEquals(1.213123, o9);
}

type OptionalInt int?;
function getInt(OptionalInt value) returns int { return value ?: 0; }
function testElvisExprWithTypeRefType() { OptionalInt a = 1; assertEquals(1, getInt(a)); OptionalInt b = (); assertEquals(0, getInt(b)); }
function getIntArray(int[]? & readonly value) returns int[] { return value ?: [1, 2, 3]; }
type OptionalReadOnlyIntArray int[]? & readonly;
function getIntArray2(OptionalReadOnlyIntArray value) returns int[] { return value ?: [30, 21]; }
function testElvisExprWithIntersectionTypes() { assertEquals([1, 2], getIntArray([1, 2])); assertEquals([1, 2, 3], getIntArray(())); assertEquals([11], getIntArray2([11])); assertEquals([30, 21], getIntArray2(())); }
function testElvisExprWithBuiltInNilableUnion() {
    json j1 = 1; json j2 = j1 ?: "nil"; assertEquals(1, j2);
    json j3 = (); json j4 = j3 ?: "nil"; assertEquals("nil", j4);
    anydata a1 = j3 ?: xml `text`; assertEquals(xml `text`, a1);
    anydata k1 = 12; anydata k2 = k1 ?: 123; assertEquals(12, k2);
    anydata k3 = (); anydata k4 = k3 ?: 123; assertEquals(123, k4);
    any k5 = k3 ?: "nil value 2"; assertEquals("nil value 2", <anydata> k5);
    any l1 = 3; any l2 = l1 ?: "empty"; assertEquals(3, <anydata> l2);
    any l3 = (); any l4 = l3 ?: "empty"; assertEquals("empty", <anydata> l4);
}
type JsonWithoutNil boolean|int|float|decimal|string|json[]|map<json>;
function testElvisExprWithJson() { json value = 1; JsonWithoutNil first = value ?: 10; assertEquals(1, first); value = (); JsonWithoutNil second = value ?: 10; assertEquals(10, second); json|xml mixed = 12; JsonWithoutNil|xml third = mixed ?: xml `test`; assertEquals(12, third); mixed = (); JsonWithoutNil|xml fourth = mixed ?: xml `test`; assertEquals(xml `test`, fourth); }
type AnydataWithoutNil boolean|int|float|decimal|string|xml|regexp:RegExp|anydata[]|map<anydata>|table<map<anydata>>;
function testElvisExprWithAnydata() { anydata value = "hello"; AnydataWithoutNil first = value ?: 10; assertEquals("hello", first); value = (); AnydataWithoutNil second = value ?: 10; assertEquals(10, second); error err = error("Oops"); error|anydata mixed = 234; error|AnydataWithoutNil result = mixed ?: err; assertEquals(234, checkpanic result); mixed = (); result = mixed ?: err; assertTrue(result is error); assertTrue(result === err); }
function testElvisExprWithFiniteType() { 1|null value = 1; int result = value ?: 2; assertEquals(1, result); value = (); result = value ?: 2; assertEquals(2, result); }
function testElvisExprWithUnionWithFiniteTypeContainingNull() {
    1|null|string a = 1; string|1 first = a ?: "hello"; assertEquals(1, first);
    1|null|string b = (); string|1 second = b ?: "hello"; assertEquals("hello", second);
    1|null|string c = (); int|string third = c ?: 23; assertEquals(23, third);
}
function testElvisExprWithQuery() { int? value = (); int|int[] result = value ?: from var _ in [1, 2] where value == () select 2; assertEquals([2, 2], result); }

function assertTrue(anydata actual) { assertEquals(true, actual); }
function assertEquals(anydata expected, anydata actual) { if expected == actual { return; } typedesc<anydata> expT = typeof expected; typedesc<anydata> actT = typeof actual; panic error("AssertionError", message = "expected [" + expected.toString() + "] of type [" + expT.toString() + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]"); }
