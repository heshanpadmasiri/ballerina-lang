import ballerina/io;

const int CAI = 10 + 5;
const float CAF = 10.0 + 5.0;
const decimal CAD = 11.5 + 4;
const string CAS = "hello" + "world";

function getConstAdditions() returns [int, float, decimal, string] {
    return [CAI, CAF, CAD, CAS];
}

const int CSI = 10 - 5;
const float CSF = 10.5 - 5.0;
const decimal CSD = 10.5 - 5;

function getConstSubtracts() returns [int, float, decimal] {
    return [CSI, CSF, CSD];
}

const int CMI = 10 * 5;
const float CMF = 10.5 * 5.0;
const decimal CMD = 10.5 * 5;

function getConstMultiplications() returns [int, float, decimal] {
    return [CMI, CMF, CMD];
}

const int CDI = 10 / 5;
const float CDF = 10.5 / 5.0;
const float NAN = 0.0 / 0.0;
const float IFN = 1.0 / 0.0;
const decimal CDD = 10.5 / 5;

function getConstDivisions() returns [int, float, float, float, decimal] {
    return [CDI, CDF, NAN, IFN, CDD];
}

const int CGI1 = 10 + (5 + (10 - 5));
const int CGI2 = 10 / (-5 - (10 - 5));
const int CGI3 = 10 + (5 * (10 - 5));

function getConstGrouping() returns [int, int, int] {
    return [CGI1, CGI2, CGI3];
}

const float CF1 = 1.0 + 2.0;
const float CF2 = 2.0 + 3.0;
const map<float> CF_MAP = {v1: CF1, v2: CF2};

function checkMapAccessReference() returns map<float> {
    return CF_MAP;
}

const int SHIFTED = (1 << CAI) + 1;
const int RSHIFTED = 64 >> 1;
const int RSHIFTED_C = CAI >> 2;
const int URSHIFTED = (-32) >>> 2;
const int URSHIFTED_C = CAI >>> 2;
const int AND = 31 & 1;
const int OR = 30 | 1;
const int XOR = 3 ^ 1;
const int WRAP_AROUND_0 = 1 << 62;
const int WRAP_AROUND_2 = 1 << 64;
const int WRAP_AROUND_3 = 1 << 65;
const int ZERO_EXT_0 = 3 >> 0;
const int ZERO_EXT_1 = 3 >> 1;
const int ZERO_EXT_2 = 3 >> 2;
const int ZERO_EXT_3 = 3 >> 3;
const int ZERO_EXT_4 = 3 >> 4;
const int ZERO_EXT_5 = 3 >> 5;
const TAG_MASK = 0xff;
const TAG_LEFT_SHIFT = 0x38;
const TAG_RIGHT_SHIFT = 0x2;

function testBitwiseConstExpressions() {
    assertEqual(SHIFTED, 0x8001);
    assertEqual(RSHIFTED, 0x20);
    assertEqual(RSHIFTED_C, 0x3);
    assertEqual(URSHIFTED, 0x3ffffffffffffff8);
    assertEqual(URSHIFTED_C, 0x3);
    assertEqual(AND, 0x1);
    assertEqual(OR, 0x1F);
    assertEqual(XOR, 0x2);
    assertEqual(WRAP_AROUND_0, 0x4000000000000000);
    assertEqual(WRAP_AROUND_2, 0x1);
    assertEqual(WRAP_AROUND_3, 0x2);
    assertEqual(ZERO_EXT_0, 0x3);
    assertEqual(ZERO_EXT_1, 0x1);
    assertEqual(ZERO_EXT_2, 0x0);
    assertEqual(ZERO_EXT_3, 0x0);
    assertEqual(ZERO_EXT_4, 0x0);
    assertEqual(ZERO_EXT_5, 0x0);
    assertEqual(TAG_MASK << TAG_LEFT_SHIFT, -0x0100000000000000);
    assertEqual(TAG_MASK >> TAG_RIGHT_SHIFT, 0x3f);
    assertEqual(~(TAG_MASK << TAG_LEFT_SHIFT), 0xffffffffffffff);
    assertEqual(~(TAG_MASK >> TAG_RIGHT_SHIFT), -64);
}

const int CUI1 = -10;
const int CUI2 = -(+(5 + 10));
const int CUI3 = ~2;
const int CUI4 = ~(-36);
const float CUF1 = -(10.0 * 2.0);
const float CUF2 = +(10.0 + 2.0);
const decimal CUD = -(11.5 + 4);
const boolean CUB = !true;
const map<int> CUE = {a: -1};
const int CUI5 = -int:MAX_VALUE;

function testConstUnaryExpressions() {
    assertEqual(CUI1, -10);
    assertEqual(CUI2, -15);
    assertEqual(CUI3, -3);
    assertEqual(CUI4, 35);
    assertEqual(CUF1, -20.0);
    assertEqual(CUF2, 12.0);
    assertEqual(CUD, -15.5d);
    assertEqual(CUB, false);
    assertEqual(CUE["a"], -1);
    assertEqual(CUI5, -9223372036854775807);
}

const float X1 = 5.5;
const float ANS1 = X1 % 0;
const float ANS2 = X1 % 1.1;
const float ANS3 = 5 % float:NaN;
const float ANS4 = float:NaN % 5;
const float ANS5 = float:Infinity % 5;
const float ANS6 = 5 % float:Infinity;
const decimal ANS7 = 5 % 2;
const decimal ANS8 = 100 % 9.999999999999999999999999999999999e6144;

function testConstRemainderOperation() {
    assertEqual(ANS1.toString(), "NaN");
    assertEqual(ANS2, 1.0999999999999996);
    assertEqual(ANS3.toString(), "NaN");
    assertEqual(ANS4.toString(), "NaN");
    assertEqual(ANS5.toString(), "NaN");
    assertEqual(ANS6, 5.0);
    assertEqual(ANS7.toString(), "1");
    assertEqual(ANS8.toString(), "100");
}

const decimal ANS11 = 1.000000000000000000000000000000000e-6143 * 1e-1;
const decimal ANS12 = 1.000000000000000000000000000000000e-6143 * 1e-100;
const decimal ANS13 = -1.000000000000000000000000000000000e-6143 * 1e-1;
const decimal ANS14 = -1.000000000000000000000000000000000e-6143 * 1e-150;

function testConstDecimalSubnormals() {
    assertEqual(ANS11.toString(), "0");
    assertEqual(ANS12.toString(), "0");
    assertEqual(ANS13.toString(), "0");
    assertEqual(ANS14.toString(), "0");
}

const float|decimal CONST11 = 1 + 2.0;
const int|float|decimal CONST12 = 2 * 2.0;
const float|decimal CONST13 = 2 * 2.0;
const float|decimal CONST14 = 10 / 2;
const int|float|decimal CONST15 = 10.0 / 2;

function testConstExprWithUnionExpectedType() {
    assertEqual(CONST11, 3.0);
    assertEqual(CONST12, 4.0);
    assertEqual(CONST13, 4.0);
    assertEqual(CONST14, 5.0);
    assertEqual(CONST15, 5.0);
}

const CONST21 = 1 + 2;
const CONST21 CONST22 = 3;

function testConstExprWithConstExpectedType() {
    assertEqual(CONST22, 3);
}

const byte CONST31 = 300 - 100;
const byte CONST32 = (700 - 200) - 400;
const byte CONST33 = 1000 / 2 - 300;
const byte CONST34 = 10 * 2;
const byte CONST35 = 500 % 3;
const byte CONST36 = -(-10);

function testConstExprWithByteExpectedType() {
    assertEqual(CONST31, 200);
    assertEqual(CONST32, 100);
    assertEqual(CONST33, 200);
    assertEqual(CONST34, 20);
    assertEqual(CONST35, 2);
    assertEqual(CONST36, 10);
}

function assertEqual(int|float|decimal|boolean|string actual, int|float|decimal|boolean|string expected) {
    if actual != expected {
        panic error(string `Assertion error: expected ${expected} found ${actual}`);
    }
}

public function main() {
    [int, float, decimal, string] additions = getConstAdditions();
    io:println(additions[0]); // @output 15
    io:println(additions[1]); // @output 15.0
    io:println(additions[2]); // @output 15.5
    io:println(additions[3]); // @output helloworld
    [int, float, decimal] subtracts = getConstSubtracts();
    io:println(subtracts[0]); // @output 5
    io:println(subtracts[1]); // @output 5.5
    io:println(subtracts[2]); // @output 5.5
    [int, float, decimal] multiplications = getConstMultiplications();
    io:println(multiplications[0]); // @output 50
    io:println(multiplications[1]); // @output 52.5
    io:println(multiplications[2]); // @output 52.5
    [int, float, float, float, decimal] divisions = getConstDivisions();
    io:println(divisions[0]); // @output 2
    io:println(divisions[1]); // @output 2.1
    io:println(divisions[2]); // @output NaN
    io:println(divisions[3]); // @output Infinity
    io:println(divisions[4]); // @output 2.1
    [int, int, int] grouping = getConstGrouping();
    io:println(grouping[0]); // @output 20
    io:println(grouping[1]); // @output -1
    io:println(grouping[2]); // @output 35
    io:println(checkMapAccessReference()); // @output {"v1":3.0,"v2":5.0}
    testBitwiseConstExpressions();
    testConstUnaryExpressions();
    testConstRemainderOperation();
    testConstDecimalSubnormals();
    testConstExprWithUnionExpectedType();
    testConstExprWithConstExpectedType();
    testConstExprWithByteExpectedType();
}
