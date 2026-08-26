import ballerina/io;
import ballerina/lang.'string as strings;

const nameWithoutType = "Ballerina";
const string nameWithType = "Ballerina";
const nilWithoutType = ();
const () nilWithType = ();

function testNilWithoutType() returns () => nilWithoutType;
function testNilWithType() returns () => nilWithType;
function testConstWithTypeInReturn() returns string => nameWithType;
// The original method intentionally returns nameWithType.
function testConstWithoutTypeInReturn() returns string => nameWithType;
function testConstWithTypeAsParam() returns string => testParam(nameWithType);
function testConstWithoutTypeAsParam() returns string => testParam(nameWithoutType);
function testParam(string s) returns string => s;

type Data record {
    string firstName;
};
function testConstInRecord() returns string {
    Data d = {firstName: "Ballerina"};
    return d.firstName;
}

string sgvWithType = nameWithType;
function testConstWithTypeAssignmentToGlobalVariable() returns string => sgvWithType;
function testConstWithTypeAssignmentToLocalVariable() returns string {
    string slv = nameWithType;
    return slv;
}
string sgvWithoutType = nameWithoutType;
function testConstWithoutTypeAssignmentToGlobalVariable() returns string => sgvWithoutType;
function testConstWithoutTypeAssignmentToLocalVariable() returns string {
    string slv = nameWithoutType;
    return slv;
}
function testConstWithTypeConcat() returns string => nameWithType + " rocks";
function testConstWithoutTypeConcat() returns string => nameWithoutType + " rocks";

type ACTION "GET"|"POST";
const GET = "GET";
const POST = "POST";
function testTypeConstants() returns ACTION => GET;
const constActionWithType = "GET";
function testConstWithTypeAssignmentToType() returns ACTION {
    ACTION action = constActionWithType;
    return action;
}
const constActionWithoutType = "GET";
function testConstWithoutTypeAssignmentToType() returns ACTION {
    ACTION action = constActionWithoutType;
    return action;
}
function testConstAndTypeComparison() returns boolean => "GET" == GET;
function testTypeConstAsParam() returns boolean => typeConstAsParam(GET);
function typeConstAsParam(ACTION a) returns boolean => "GET" == a;
function testEqualityWithConstWithType() returns boolean => nameWithType == "Ballerina";

const boolean conditionWithType = true;
function testConstWithTypeInCondition() returns boolean {
    if conditionWithType {
        return true;
    }
}
const conditionWithoutType = true;
function testConstWithoutTypeInCondition() returns boolean {
    if conditionWithoutType {
        return true;
    }
}
const boolean booleanWithType = false;
function testBooleanWithType() returns boolean => booleanWithType;
const booleanWithoutType = true;
function testBooleanWithoutType() returns boolean => booleanWithoutType;
const int intWithType = 40;
function testIntWithType() returns int => intWithType;
const intWithoutType = 20;
function testIntWithoutType() returns int => intWithoutType;
const byte byteWithType = 240;
function testByteWithType() returns byte => byteWithType;
const float floatWithType = 4.0;
function testFloatWithType() returns float => floatWithType;
const floatWithoutType = 2.0;
function testFloatWithoutType() returns float => floatWithoutType;
const decimal decimalWithType = 50.0;
function testDecimalWithType() returns decimal => decimalWithType;
const string stringWithType = "Ballerina is awesome";
function testStringWithType() returns string => stringWithType;
const stringWithoutType = "Ballerina rocks";
function testStringWithoutType() returns string => stringWithoutType;

type FiniteFloatType floatWithType|floatWithoutType;
function testFloatAsFiniteType() returns [FiniteFloatType, FiniteFloatType] {
    FiniteFloatType f1 = 2.0;
    FiniteFloatType f2 = 4.0;
    return [f1, f2];
}

const string key = "key";
const string value = "value";
function testConstInMapKey() returns string? {
    map<string> m = {key: "value"};
    return m["key"];
}
function testConstInMapValue() returns string? {
    map<string> m = {"key": value};
    return m["key"];
}
function testConstInJsonKey() returns json|error {
    json j = {key: "value"};
    return j.key;
}
function testConstInJsonValue() returns json|error {
    json j = {"key": value};
    return j.key;
}

function testBooleanConstInUnion() returns any => booleanWithType;
function testIntConstInUnion() returns any => intWithType;
function testByteConstInUnion() returns any => byteWithType;
function testFloatConstInUnion() returns any => floatWithType;
function testDecimalConstInUnion() returns any => decimalWithType;
function testStringConstInUnion() returns any => stringWithType;
function testBooleanConstInTuple() returns boolean {
    [boolean, int] v = [booleanWithType, 1];
    return v[0];
}
function testIntConstInTuple() returns int {
    [int, boolean] v = [intWithType, true];
    return v[0];
}
function testByteConstInTuple() returns byte {
    [byte, boolean] v = [byteWithType, true];
    return v[0];
}
function testFloatConstInTuple() returns float {
    [float, boolean] v = [floatWithType, true];
    return v[0];
}
function testDecimalConstInTuple() returns decimal {
    [decimal, boolean] v = [decimalWithType, true];
    return v[0];
}
function testStringConstInTuple() returns string {
    [string, boolean] v = [stringWithType, true];
    return v[0];
}

const D = "D";
const E = "E";
const F = "F";
type G D|E|F;
type H D|E;
const h = "D";
function testProperSubset() returns G {
    G g = h;
    return g;
}
const string SHA1 = "SHA1";
function testBuiltinFunctionInvocation() returns boolean => strings:startsWith(SHA1, "SH");
function testBuiltinFunctionInvocationOnArrayElement() returns boolean {
    string[] arr = [SHA1];
    return strings:startsWith(arr[0], "SH");
}
type TestRecord record {
    string 'field;
};
function testBuiltinFunctionInvocationOnField() returns boolean {
    TestRecord tr = {'field: SHA1};
    return strings:startsWith(tr.'field, "SH");
}
type STRING_LABEL string;
const STRING_LABEL labeledString = "Ballerina";
function testLabeling() returns string => labeledString;

type M record { string f; }|Z;
M m1 = {f: "test_project"};
M m2 = "V";
M m3 = "W";
M m4 = "X";
type Y X;
type Z "V"|W|X;
Y y = "X";
Z z1 = "V";
Z z2 = "W";
Z z3 = "X";
const string W = "W";
const string X = "X";

const aBoolean = true;
function testBooleanConcat() returns string => aBoolean.toString() + " rocks";
const aInt = 24;
function testIntConcat() returns string => aInt.toString() + " rocks";
const aByte = 12;
function testByteConcat() returns string => aByte.toString() + " rocks";
const aFloat = 25.5;
function testFloatConcat() returns string => aFloat.toString() + " rocks";
const decimal aDecimal = 25.5;
function testDecimalConcat() returns string => aDecimal.toString() + " rocks";

type Seconds decimal;
const Seconds ZERO = 0;
const Seconds ONE = 1.0;
function testDecimalConstsWithTypeReferenceTypeDescriptorsDefinedWithNumericLiterals() {
    Seconds a = ZERO;
    Seconds b = ONE;
    assertEquality(0d, a);
    assertEquality(1d, b);
    0d _ = ZERO;
    1d _ = ONE;
}
const CONST1 = 200;
const byte CONST2 = CONST1;
const int CONST3 = 200;
const byte CONST4 = CONST3;
function testAssigningConstToByte() {
    assertEquality(200, CONST2);
    assertEquality(200, CONST4);
    byte b = CONST1;
    assertEquality(200, b);
}
function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error(string `expected '${expected.toBalString()}', found '${actual.toBalString()}'`);
}

public function main() {
    // @output true
    io:println(testNilWithoutType() is ());
    // @output true
    io:println(testNilWithType() is ());
    // @output Ballerina
    io:println(testConstWithTypeInReturn());
    // @output Ballerina
    io:println(testConstWithoutTypeInReturn());
    // @output Ballerina
    io:println(testConstWithTypeAsParam());
    // @output Ballerina
    io:println(testConstWithoutTypeAsParam());
    // @output Ballerina
    io:println(testConstInRecord());
    // @output Ballerina
    io:println(testConstWithTypeAssignmentToGlobalVariable());
    // @output Ballerina
    io:println(testConstWithTypeAssignmentToLocalVariable());
    // @output Ballerina
    io:println(testConstWithoutTypeAssignmentToGlobalVariable());
    // @output Ballerina
    io:println(testConstWithoutTypeAssignmentToLocalVariable());
    // @output Ballerina rocks
    io:println(testConstWithTypeConcat());
    // @output Ballerina rocks
    io:println(testConstWithoutTypeConcat());
    // @output GET
    io:println(testTypeConstants());
    // @output GET
    io:println(testConstWithTypeAssignmentToType());
    // @output GET
    io:println(testConstWithoutTypeAssignmentToType());
    // @output true
    io:println(testConstAndTypeComparison());
    // @output true
    io:println(testTypeConstAsParam());
    // @output true
    io:println(testEqualityWithConstWithType());
    // @output true
    io:println(testConstWithTypeInCondition());
    // @output true
    io:println(testConstWithoutTypeInCondition());
    // @output false
    io:println(testBooleanWithType());
    // @output true
    io:println(testBooleanWithoutType());
    // @output 40
    io:println(testIntWithType());
    // @output 20
    io:println(testIntWithoutType());
    // @output 240
    io:println(testByteWithType());
    // @output 4.0
    io:println(testFloatWithType());
    // @output 2.0
    io:println(testFloatWithoutType());
    // @output 50.0
    io:println(testDecimalWithType());
    // @output Ballerina is awesome
    io:println(testStringWithType());
    // @output Ballerina rocks
    io:println(testStringWithoutType());
    [FiniteFloatType, FiniteFloatType] finite = testFloatAsFiniteType();
    // @output 2.0
    io:println(finite[0]);
    // @output 4.0
    io:println(finite[1]);
    // @output value
    io:println(testConstInMapKey());
    // @output value
    io:println(testConstInMapValue());
    // @output value
    io:println(testConstInJsonKey());
    // @output value
    io:println(testConstInJsonValue());
    // @output false
    io:println(testBooleanConstInUnion());
    // @output 40
    io:println(testIntConstInUnion());
    // @output 240
    io:println(testByteConstInUnion());
    // @output 4.0
    io:println(testFloatConstInUnion());
    // @output 50.0
    io:println(testDecimalConstInUnion());
    // @output Ballerina is awesome
    io:println(testStringConstInUnion());
    // @output false
    io:println(testBooleanConstInTuple());
    // @output 40
    io:println(testIntConstInTuple());
    // @output 240
    io:println(testByteConstInTuple());
    // @output 4.0
    io:println(testFloatConstInTuple());
    // @output 50.0
    io:println(testDecimalConstInTuple());
    // @output Ballerina is awesome
    io:println(testStringConstInTuple());
    // @output D
    io:println(testProperSubset());
    // @output true
    io:println(testBuiltinFunctionInvocation());
    // @output true
    io:println(testBuiltinFunctionInvocationOnArrayElement());
    // @output true
    io:println(testBuiltinFunctionInvocationOnField());
    // @output Ballerina
    io:println(testLabeling());
    // @output true rocks
    io:println(testBooleanConcat());
    // @output 24 rocks
    io:println(testIntConcat());
    // @output 12 rocks
    io:println(testByteConcat());
    // @output 25.5 rocks
    io:println(testFloatConcat());
    // @output 25.5 rocks
    io:println(testDecimalConcat());
    testDecimalConstsWithTypeReferenceTypeDescriptorsDefinedWithNumericLiterals();
    // @output ok
    io:println("ok");
    testAssigningConstToByte();
    // @output ok
    io:println("ok");
}
