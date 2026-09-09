import ballerina/lang.'int as ints;

function testMapElementIncrement() returns int|error {
    map<any> namesMap = {fname: 1};
    namesMap["fname"] += 1; // @error
    int x = check trap <int> namesMap["fname"];
    return x;
}

function testMapElementDecrement() returns int|error {
    map<any> namesMap = {fname: 1};
    namesMap["fname"] -= 1; // @error
    int x = check trap <int> namesMap["fname"];
    return x;
}

function testInvalidExpressionIncrement() returns int {
    getInt() += 1; // @error
    return getInt();
}
function testInvalidExpressionDecrement() returns int {
    getInt() -= 1; // @error
    return getInt();
}
function getInt() returns int { return 3; }

function testStringVarRefIncrement() returns string {
    string x = "compound";
    x += 1; // @error
    return x;
}
function testStringVarRefDecrement() returns string {
    string x = "compound";
    x -= 1; // @error
    return x;
}
function testMultiReturnWithCompound() returns int {
    int x = 4;
    x += ints:fromString("NotAInteger"); // @error
    return x;
}
function testInvalidRefExpressionWithCompound() returns int {
    int x = 5;
    getInt() += x; // @error
    return x;
}
function testInvalidTypeJsonStringCompound() returns json {
    json j = {"test": "test"};
    j += "sdasdasd"; // @error
    return j;
}
function testInvalidTypeIntStringCompound() returns int {
    int x = 5;
    x += "sdasd"; // @error
    return x;
}
function testIntFloatDivision() returns float {
    int x = 5;
    float d = 2.5;
    x /= <int>d;
    return x; // @error
}
function testCompoundAssignmentAdditionWithFunctionInvocation() returns int {
    int x = 5;
    x += getMultiIncrement(); // @error
    return x;
}
function getMultiIncrement() returns [int, int] { return [200, 100]; }

function testCompoundAssignmentBitwiseAND() returns int {
    int x = 15;
    x &= "Ballerina"; // @error
    return x;
}
function testCompoundAssignmentBitwiseOR() returns int {
    int x = 15;
    x |= "Ballerina"; // @error
    return x;
}
function testCompoundAssignmentBitwiseXOR() returns int {
    int x = 15;
    x ^= "Ballerina"; // @error
    return x;
}
function testCompoundAssignmentLeftShift() returns int {
    int x = 8;
    x <<= "Ballerina"; // @error
    return x;
}
function testCompoundAssignmentRightShift() returns int {
    int x = 8;
    x >>= "Ballerina"; // @error
    return x;
}
function testCompoundAssignmentLogicalShift() returns int {
    int x = 8;
    x >>>= "Ballerina"; // @error
    return x;
}

function testFunctionInvocation() returns int {
    Bar bar = {};
    foo(bar).bar += 10; // @error
}
function foo(Bar b) returns Bar { b.bar += 1; return b; }
type Bar record { int bar = 0; };

function invalidUsageOfCompoundAssignmentAsExpr() {
    int a = 5;
    int f = a <<= 3; // @error
    int g = a >>= 3; // @error
}

type SomeType int|string;
type SomeType2 12|"A";
function incompatibleTypesInBinaryBitwiseOpInCompoundAssignment() {
    int|string a = 5;
    int b = 12;
    a &= b; // @error
    a |= b; // @error
    a ^= b; // @error
    SomeType c = 12;
    a &= c; // @error
    a |= c; // @error
    a ^= c; // @error
    SomeType2 d = 12;
    a &= d; // @error
    a |= d; // @error
    a ^= d; // @error
}

function testCompoundAssignmentNotAllowedWithNullableOperands() {
    map<int>? m = {x: 2};
    m["x"] += 1; // @error
    map<int> n = {x: 2};
    n["x"] += 1; // @error
    int? a = ();
    a += 2; // @error
    record {|int name?; int? age;|} b = {age: ()};
    b.name += 4; // @error
    b.age += 4; // @error
    ()|int c = 5;
    c += 4; // @error
    int? x = 4;
    int? y = 5;
    x += y; // @error
}

type MyNill ();
type MyMap map<int>;
type MyUnion MyMap|MyNill;
function testCompoundAssignmentNotAllowedWithNullableOperandsUsingTypeRef() {
    MyMap x = {"w": 33};
    x["w"] += 1; // @error
    MyUnion y = {"w": 33};
    y["w"] += 1; // @error
}
