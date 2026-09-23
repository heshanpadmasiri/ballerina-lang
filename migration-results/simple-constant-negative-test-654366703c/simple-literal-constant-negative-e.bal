const boolean someBoolean = 10; // @error
const int someInt = "ABC"; // @error
const byte someByte = 500; // @error
const float someFloat = true; // @error
const decimal someDeciaml = true; // @error
const string someString = 120; // @error

const string _ = "PUT"; // @error
const _ = 11; // @error

const invalidType someValue = 1; // @error // @error

string s = "Ballerina";
public const string name2 = "";
int a = 10;

const x = 10;
const int y = 20;

function testAssignment() {
    x = 1; // @error
    y = 2; // @error
}

function testWorkerInteractions() {
    worker w1 {
        x = <- w2; // @error
    }
    worker w2 {
        30 -> w1;
    }
}

const string sVar = 10; // @error
const string m = { name: "Ballerina" }; // @error

const abc = "abc";
const abc = "abc"; // @error
const abc = "Ballerina"; // @error // @error

const def = "def";
function test() {
    string def = "def";
}

type ACTION "GET";
type XYZ "XYZ";
const xyz = "XYZ";
function testInvalidTypes() returns ACTION {
    ACTION action = xyz; // @error
    return action;
}

const byteWithoutType = 120;
function testByteWithoutType() returns byte {
    return byteWithoutType;
}

const D = "D";
const E = "E";
const F = "F";
type G E|F;
type H D|E;
H h = "D";
function testImproperSubset() returns G {
    G g = h; // @error
    return g;
}

type UVW UVW; // @error
type IJK IJK|"R"|SSS|"S"; // @error // @error
type LMN OPQ|"QRS"|RST|STU; // @error // @error
type OPQ LMN|"STU"|RST; // @error

type ACE BDF; // @error // @error
type BDF "AAA"|CEG|"TTT"|DFH; // @error
type CEG ACE|"UUU"|EGI;
type DFH "DFH";
type EGI BDF|ACE;

type MNO PQ; // @error
type JKL J|STU;
const J = "J";
type STU S|T|U; // @error // @error
const S = "S";

function testInvalidConstUsage() {
    string wxy = name2;
}

const boolean booleanWithType = false;
type BooleanTypeWithType booleanWithType;
function testBooleanTypeWithType() returns BooleanTypeWithType {
    BooleanTypeWithType t = true; // @error
    return t;
}

const booleanWithoutType = true;
type BooleanTypeWithoutType booleanWithoutType;
function testBooleanTypeWithoutType() returns BooleanTypeWithoutType {
    BooleanTypeWithoutType t = false; // @error
    return t;
}

const int intWithType = 40;
type IntTypeWithType intWithType;
function testIntTypeWithType() returns IntTypeWithType {
    IntTypeWithType t = 100; // @error
    return t;
}

const intWithoutType = 20;
type IntTypeWithoutType intWithoutType;
function testIntTypeWithoutType() returns IntTypeWithoutType {
    IntTypeWithoutType t = 100; // @error
    return t;
}

const byte byteWithType = 240;
type ByteTypeWithType byteWithType;
function testByteTypeWithType() returns ByteTypeWithType {
    ByteTypeWithType t = 120; // @error
    return t;
}

const float floatWithType = 4.0;
type FloatTypeWithType floatWithType;
function testFloatTypeWithType() returns FloatTypeWithType {
    FloatTypeWithType t = 10.0; // @error
    return t;
}

const floatWithoutType = 2.0;
type FloatTypeWithoutType floatWithoutType;
function testFloatTypeWithoutType() returns FloatTypeWithoutType {
    FloatTypeWithoutType t = 10.0; // @error
    return t;
}

const decimal decimalWithType = 4.0;
type DecimalTypeWithType decimalWithType;
function testDecimalTypeWithType() returns DecimalTypeWithType {
    DecimalTypeWithType t = 10.0; // @error
    return t;
}

const string stringWithType = "Ballerina is awesome";
type StringTypeWithType stringWithType;
function testStringTypeWithType() returns StringTypeWithType {
    StringTypeWithType t = "random text"; // @error
    return t;
}

const stringWithoutType = "Ballerina rocks";
type StringTypeWithoutType stringWithoutType;
function testStringTypeWithoutType() returns StringTypeWithoutType {
    StringTypeWithoutType t = "random text"; // @error
    return t;
}

const int invalidNil = (); // @error
const map<string> m1 = { "key": getValue() }; // @error
const map<string> m2 = { "key": sValue }; // @error
string sValue = "ballerina";
function getValue() returns string {
    return "ballerina";
}

const map<string> m3 = { "m3k": "m3v" };
function updateConstantMapValue() {
    m3.m3k = "m3nv"; // @error
}

type Foo record {
    string s;
    int i;
};
const Foo f = { s: "const string", i: 1 };
const json j = 1; // @error
public const int:Signed32 ONE = 1;
public const int:Unsigned16 TWO = 2;
public const string:Char A = "A"; // @error

class Bar {
    int i = 1;
}
const Bar BAR = new; // @error // @error
function main1() {
    const expected = ""; // @error
}

public const UT_OBJECT_RW  = 0x16;
public const UT_COUNT = UT_OBJECT_RW + 1;
const int UT_MASK = (1 << UT_COUNT) - 1;
const int CONST1 = CONST1; // @error

const abc2 = 1;
const abc2 = "1"; // @error // @error

type Byte byte;
const Byte V1 = 256; // @error
type Ints int;
const Ints V2 = 1.0; // @error
type Ints2 -1|int:MIN_VALUE;
Ints2 ints2 = 2; // @error
float:NaN floatNan = 1.0; // @error
float:Infinity floatInf = 1.0; // @error

const NUM1 = -1;
const int NUM2 = -9223372036854775807 - 1;
const int NUM3 = 0;
const int NUM4 = 9223372036854775807;
const int NUM5 = 10;
const int ANS1 = NUM2 / NUM1; // @error
const int ANS2 = NUM2 / NUM3; // @error
const int ANS3 = NUM2 * NUM1; // @error
const int ANS4 = NUM2 * 5; // @error
const int ANS5 = NUM2 % NUM3; // @error
const int ANS6 = -NUM2; // @error
const int ANS7 = NUM2 + NUM1; // @error
const int ANS8 = NUM4 + NUM5; // @error
const int ANS10 = NUM2 - NUM5; // @error
const int ANS11 = NUM4 - NUM1; // @error
const decimal ANS12 = 5 % 0; // @error
const int ANS7 = NUM2 - 1; // @error // @error // @error
const decimal d1 = 9.999999999999999999999999999999999E6001d * 1E145d; // @error
const decimal d2 = -9.999999999999999999999999999999999E6141d * 1E5d; // @error
const decimal d3 = 9.999999999999999999999999999999999E6144d + 1E6143d; // @error
const decimal d4 = -1E6144d - 9.999999999999999999999999999999999E6144d; // @error
const decimal d5 = 1E614d / 2E-5800d; // @error
const int ANS13 = -int:MIN_VALUE; // @error
const int var1 = 1;
const T1 = typeof var1; // @error // @error
