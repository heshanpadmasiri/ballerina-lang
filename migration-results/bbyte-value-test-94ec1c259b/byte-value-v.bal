import ballerina/io;

byte globalByte = 0;

public function main() returns error? {
    io:println(testByteValue()); // @output 34
    io:println(testByteValueSpace()); // @output 234
    io:println(testByteDefaultValue()); // @output 0
    io:println(testByteParam(34)); // @output 34
    io:println(testGlobalByte(34)); // @output 34
    io:println(testByteToIntCast(12)); // @output 12
    io:println(testIntToByteCast(123)); // @output 123
    io:println(testIntToByteExplicitCast(123)); // @output 123
    io:println(testIntToByteConversion(123)); // @output 123
    io:println(testByteToIntConversion(45)); // @output 45
    io:println(testSafeCasting()); // @output 6
    io:println(testAnyToByteCasting()); // @output 45
    _ = testByteArray();
    byte[] assigned = testByteArrayAssignment([2, 56, 89, 23]);
    io:println(assigned[0]); // @output 2
    io:println(assigned[1]); // @output 56
    io:println(assigned[2]); // @output 89
    io:println(assigned[3]); // @output 23
    io:println(testByteArrayLength()); // @output 4
    io:println(testByteArrayZeroLength()); // @output 0
    io:println(testByteArrayIncreaseSize()); // @output 10
    [int, int] arrayOfArray = testByteArrayOfArray();
    io:println(arrayOfArray[0]); // @output 3
    io:println(arrayOfArray[1]); // @output 4
    byte[] iterated = testByteArrayIteration([1, 2, 3, 4, 5]);
    io:println(iterated[0]); // @output 1
    io:println(iterated[1]); // @output 2
    io:println(iterated[2]); // @output 3
    io:println(iterated[3]); // @output 4
    io:println(iterated[4]); // @output 5
    [boolean, boolean] equal = testByteBinaryOperation(2, 3, 2);
    io:println(equal[0]); // @output false
    io:println(equal[1]); // @output true
    [boolean, boolean] notEqual = testByteBinaryNotEqualOperation(12, 32, 12);
    io:println(notEqual[0]); // @output true
    io:println(notEqual[1]); // @output false
    testWorkerWithByteVariable();
    byte|int|string[]|Foo|error byteMatch = testByteOrIntMatch1();
    io:println(byteMatch is byte); // @output true
    io:println(byteMatch); // @output 12
    byte|int|string[]|Foo|error intMatch = testByteOrIntMatch2();
    io:println(intMatch is int); // @output true
    io:println(intMatch); // @output 266
    io:println(testByteOrIntMatch3()); // @output 456
    io:println(testByteOrIntMatch4()); // @output -123

    [byte, int, int, int, int] and1 = testBitwiseAndOperator(12, 34, 234, -456);
    io:println(and1[0]); // @output 0
    io:println(and1[1]); // @output 0
    io:println(and1[2]); // @output 8
    io:println(and1[3]); // @output 40
    io:println(and1[4]); // @output 0
    [byte, int, int, int, int] and2 = testBitwiseAndOperator(159, 12, -456832, 34);
    io:println(and2[0]); // @output 12
    io:println(and2[1]); // @output 12
    io:println(and2[2]); // @output 128
    io:println(and2[3]); // @output 0
    io:println(and2[4]); // @output 0
    [byte, int, int, int, int] and3 = testBitwiseAndOperator(159, 233, -456832, -3456);
    io:println(and3[0]); // @output 137
    io:println(and3[1]); // @output 137
    io:println(and3[2]); // @output 128
    io:println(and3[3]); // @output -458112
    io:println(and3[4]); // @output 128
    [byte, int, int, int, int] and4 = testBitwiseAndOperator(159, 233, -456832, -3456);
    io:println(and4[0]); // @output 137
    io:println(and4[1]); // @output 137
    io:println(and4[2]); // @output 128
    io:println(and4[3]); // @output -458112
    io:println(and4[4]); // @output 128

    [byte, int, int, int, int] or1 = testBitwiseOrOperator(12, 34, 234, -456);
    io:println(or1[0]); // @output 46
    io:println(or1[1]); // @output 46
    io:println(or1[2]); // @output 238
    io:println(or1[3]); // @output -262
    io:println(or1[4]); // @output -258
    [byte, int, int, int, int] or2 = testBitwiseOrOperator(159, 12, -456832, 34);
    io:println(or2[0]); // @output 159
    io:println(or2[1]); // @output 159
    io:println(or2[2]); // @output -456801
    io:println(or2[3]); // @output -456798
    io:println(or2[4]); // @output -456769
    [byte, int, int, int, int] or3 = testBitwiseOrOperator(159, 233, -456832, -3456);
    io:println(or3[0]); // @output 255
    io:println(or3[1]); // @output 255
    io:println(or3[2]); // @output -456801
    io:println(or3[3]); // @output -2176
    io:println(or3[4]); // @output -2049

    [byte, int, int, int, int] xor1 = testBitwiseXorOperator(12, 34, 234, -456);
    io:println(xor1[0]); // @output 46
    io:println(xor1[1]); // @output 46
    io:println(xor1[2]); // @output 230
    io:println(xor1[3]); // @output -302
    io:println(xor1[4]); // @output -260
    [byte, int, int, int, int] xor2 = testBitwiseXorOperator(159, 12, -456832, 34);
    io:println(xor2[0]); // @output 147
    io:println(xor2[1]); // @output 147
    io:println(xor2[2]); // @output -456929
    io:println(xor2[3]); // @output -456798
    io:println(xor2[4]); // @output -456911
    [byte, int, int, int, int] xor3 = testBitwiseXorOperator(159, 233, -456832, -3456);
    io:println(xor3[0]); // @output 118
    io:println(xor3[1]); // @output 118
    io:println(xor3[2]); // @output -456929
    io:println(xor3[3]); // @output 455936
    io:println(xor3[4]); // @output 456054

    [byte, int, byte] right1 = testBitwiseRightShiftOperator1(123, 4, 234, 3);
    io:println(right1[0]); // @output 7
    io:println(right1[1]); // @output 29
    io:println(right1[2]); // @output 15
    [int, int, int] right2 = testBitwiseRightShiftOperator2(123, 4, 234, 3);
    io:println(right2[0]); // @output 7
    io:println(right2[1]); // @output 29
    io:println(right2[2]); // @output 15
    [byte, int, byte] right3 = testBitwiseRightShiftOperator1(228, 6, -45678776, 4);
    io:println(right3[0]); // @output 3
    io:println(right3[1]); // @output -2854924
    io:println(right3[2]); // @output 14
    [int, int, int] right4 = testBitwiseRightShiftOperator2(228, 6, -45678776, 4);
    io:println(right4[0]); // @output 3
    io:println(right4[1]); // @output -2854924
    io:println(right4[2]); // @output 14

    [int, int] unsigned1 = testBitwiseUnsignedRightShiftOperator(12, 234736486, 6);
    io:println(unsigned1[0]); // @output 3667757
    io:println(unsigned1[1]); // @output 57308
    [int, int] unsigned2 = testBitwiseUnsignedRightShiftOperator(12, -23445834, 5);
    io:println(unsigned2[0]); // @output 576460752302690805
    io:println(unsigned2[1]); // @output 4503599627364771
    [int, int] unsigned3 = testBitwiseUnsignedRightShiftOperator(255, -23445834, 5);
    io:println(unsigned3[0]); // @output 576460752302690805
    io:println(unsigned3[1]); // @output 1

    [int, int, int] left1 = testBitwiseLeftShiftOperator1(23, 6, 4567, 7);
    io:println(left1[0]); // @output 1472
    io:println(left1[1]); // @output 584576
    io:println(left1[2]); // @output 2944
    [int, int, int] left2 = testBitwiseLeftShiftOperator2(23, 6, 4567, 7);
    io:println(left2[0]); // @output 1472
    io:println(left2[1]); // @output 584576
    io:println(left2[2]); // @output 2944
    [int, int, int] left3 = testBitwiseLeftShiftOperator1(255, 56, 255, 56);
    io:println(left3[0]); // @output -72057594037927936
    io:println(left3[1]); // @output -72057594037927936
    io:println(left3[2]); // @output -72057594037927936
    [int, int, int] left4 = testBitwiseLeftShiftOperator2(255, 56, 255, 56);
    io:println(left4[0]); // @output -72057594037927936
    io:println(left4[1]); // @output -72057594037927936
    io:println(left4[2]); // @output -72057594037927936
    [int, int, int] left5 = testBitwiseLeftShiftOperator1(228, 6, -45678776, 4);
    io:println(left5[0]); // @output 14592
    io:println(left5[1]); // @output -730860416
    io:println(left5[2]); // @output 3648
    [int, int, int] left6 = testBitwiseLeftShiftOperator2(228, 6, -45678776, 4);
    io:println(left6[0]); // @output 14592
    io:println(left6[1]); // @output -730860416
    io:println(left6[2]); // @output 3648
    [int, int, int] left7 = testBitwiseLeftShiftOperator1(255, 56, 255, 56);
    io:println(left7[0]); // @output -72057594037927936
    io:println(left7[1]); // @output -72057594037927936
    io:println(left7[2]); // @output -72057594037927936
    [int, int, int] left8 = testBitwiseLeftShiftOperator2(255, 56, 255, 56);
    io:println(left8[0]); // @output -72057594037927936
    io:println(left8[1]); // @output -72057594037927936
    io:println(left8[2]); // @output -72057594037927936

    io:println(testByteShift()); // @output 129
    testByteShiftWithLargeValue();
    [int, int] not1 = testBitwiseNotOperator(34, 234);
    io:println(not1[0]); // @output -35
    io:println(not1[1]); // @output -235
    [int, int] not2 = testBitwiseNotOperator(156, -232224);
    io:println(not2[0]); // @output -157
    io:println(not2[1]); // @output 232223
    [int, int] not3 = testBitwiseNotOperator(144, 567849302);
    io:println(not3[0]); // @output -145
    io:println(not3[1]); // @output -567849303

    io:println(testBitwiseOperatorPrecedence1(127, 4, 5)); // @output 0
    io:println(testBitwiseOperatorPrecedence1(233, 23, 3)); // @output 2
    io:println(testBitwiseOperatorPrecedence2(23, 4, 5)); // @output 4
    io:println(testBitwiseOperatorPrecedence2(233, 23, 3)); // @output 2
    io:println(testBitwiseOperatorPrecedence3(23, 4, 5)); // @output 0
    io:println(testBitwiseOperatorPrecedence3(233, 23, 3)); // @output 2
    io:println(testBitwiseOperatorPrecedence4(3546782, 4, 5)); // @output 0
    io:println(testBitwiseOperatorPrecedence4(-2334353, 23, -3)); // @output 0
    io:println(testBitwiseOperatorPrecedence5(245623, 4, -5)); // @output 4
    io:println(testBitwiseOperatorPrecedence5(-2667533, 23, 3)); // @output 1
    io:println(testBitwiseOperatorPrecedence6(23, 4, 5)); // @output 0
    io:println(testBitwiseOperatorPrecedence6(23334233, 23, 3)); // @output 2
    testByteReturnAsIntInLambda1();
    testByteReturnAsIntInLambda2();
    testByteReturnAsIntInLambda3();
}

function testByteValue() returns byte { byte a = 0; a = 34; return a; }
function testByteValueSpace() returns byte { byte a = 0; a = 234; return a; }
function testByteDefaultValue() returns byte { byte a = 0; return a; }
function testByteParam(byte b) returns byte { byte a = 0; a = b; return a; }
function testGlobalByte(byte b) returns byte { globalByte = b; return globalByte; }
function testIntToByteCast(int b) returns byte|error { byte a = check trap <byte> b; return a; }
function testByteToIntCast(byte a) returns int { int b = <int>a; return b; }
function testIntToByteExplicitCast(int b) returns byte|error { byte a = check trap <byte> b; return a; }
function testIntToByteConversion(int b) returns byte|error { var c = check trap <byte> b; return c; }
function testByteToIntConversion(byte b) returns int { int c = <int>b; return c; }
function testSafeCasting() returns int|error { any abc = byteReturn(); int val = <int>abc; return val; }
function byteReturn() returns any { byte val = 6; return val; }
function testAnyToByteCasting() returns byte|error { any val = 45; byte i = <byte>val; return i; }
function testByteArray() returns byte[] { byte[] ba = [12, 24, 7]; return ba; }
function testByteArrayAssignment(byte[] cArrayIn) returns byte[] { byte[] cArray; cArray = cArrayIn; return cArray; }
function testByteArrayZeroLength() returns int { byte[] a = []; return a.length(); }
function testByteArrayLength() returns int { byte[] a = [4, 6, 27, 75]; return a.length(); }
function testByteArrayIncreaseSize() returns int { byte[] a = [4, 6, 27, 75]; a[9] = 56; return a.length(); }
function testByteArrayOfArray() returns [int, int] { byte[][] aa = [[4, 6, 27, 75], [3, 7, 1], [5, 32, 98]]; return [aa.length(), aa[0].length()]; }
function testByteBinaryOperation(byte a, byte b, byte c) returns [boolean, boolean] { return [a == b, a == c]; }
function testByteArrayIteration(byte[] b) returns byte[] { byte[] a = []; foreach var i in b { a[a.length()] = i; } return a; }
function testByteBinaryNotEqualOperation(byte a, byte b, byte c) returns [boolean, boolean] { return [a != b, a != c]; }
function testWorkerWithByteVariable() {
    worker w1 {
        byte a = 10;
        byte b = 12;
        a -> w2;
        b = <- w2;
        if b != 15 {
            panic error("unexpected worker value");
        }
    }
    worker w2 {
        byte a = 0;
        byte b = 15;
        a = <- w1;
        b -> w1;
        if a != 10 {
            panic error("unexpected worker value");
        }
    }
}

function testByteOrIntMatch1() returns byte|int|string[]|Foo|error {
    byte|int|string[]|Foo|error result = byteOrInt(1);
    if result is byte {
        return result;
    } else if result is int {
        return result;
    } else if result is string[] {
        return result;
    } else if result is Foo {
        return result;
    }
    return result;
}

function testByteOrIntMatch2() returns byte|int|string[]|Foo|error {
    byte|int|string[]|Foo|error result = byteOrInt(2);
    if result is byte {
        return result;
    } else if result is int {
        return result;
    } else if result is string[] {
        return result;
    } else if result is Foo {
        return result;
    }
    return result;
}
function testByteOrIntMatch3() returns int { var result = byteOrInt(1); return result is byte ? 456 : (result is int ? -123 : (result is string[] ? 789 : (result is Foo ? 8765 : 1135))); }
function testByteOrIntMatch4() returns int { var result = byteOrInt(2); return result is byte ? 456 : (result is int ? -123 : (result is string[] ? 789 : (result is Foo ? 8765 : 1135))); }
function byteOrInt(int a) returns byte|int|string[]|Foo|error { if a == 1 { return check trap <byte>12; } else if a == 2 { return 266; } else if a == 3 { return ["DD", "GG"]; } return { name: "bar" }; }
type Foo record {| string name; |};

function testBitwiseAndOperator(byte a, byte b, int i, int j) returns [byte, int, int, int, int] { return [a & b, <int>(a & b), <int>a & i, i & j, <int>a & i & <int>b & j]; }
function testBitwiseOrOperator(byte a, byte b, int i, int j) returns [byte, int, int, int, int] { return [a | b, <int>(a | b), <int>a | i, i | j, <int>a | i | <int>b | j]; }
function testBitwiseXorOperator(byte a, byte b, int i, int j) returns [byte, int, int, int, int] { return [a ^ b, <int>(a ^ b), <int>a ^ i, i ^ j, <int>a ^ i ^ <int>b ^ j]; }
function testBitwiseRightShiftOperator1(byte a, byte b, int i, int j) returns [byte, int, byte] { return [a >> b, i >> j, a >> j]; }
function testBitwiseRightShiftOperator2(byte a, byte b, int i, int j) returns [int, int, int] { return [<int>(a >> b), i >> j, <int>(a >> j)]; }
function testBitwiseLeftShiftOperator1(byte a, byte b, int i, int j) returns [int, int, int] { return [a << b, i << j, a << j]; }
function testBitwiseLeftShiftOperator2(byte a, byte b, int i, int j) returns [int, int, int] { return [<int>(a << b), i << j, <int>(a << j)]; }
function testBitwiseUnsignedRightShiftOperator(byte a, int i, int j) returns [int, int] { return [i >>> j, i >>> a]; }
function testByteShift() returns int { byte a = 129; int c = a << 1; return c >> 1; }
function testByteShiftWithLargeValue() { byte a = 12; byte b = 5; byte c = 5; byte x = b >>> a; byte y = c >> a; assert(x, 0); assert(y, 0); }
function testBitwiseNotOperator(byte b, int i) returns [int, int] { return [~b, ~i]; }
function testBitwiseOperatorPrecedence1(byte a, byte b, byte c) returns byte { return ~a & b >> c; }
function testBitwiseOperatorPrecedence2(byte a, byte b, byte c) returns byte { return b & ~a >> c; }
function testBitwiseOperatorPrecedence3(byte a, byte b, byte c) returns byte { return b >> c & ~a; }
function testBitwiseOperatorPrecedence4(int a, int b, int c) returns int { return ~a & b >> c; }
function testBitwiseOperatorPrecedence5(int a, int b, int c) returns int { return b & ~a >> c; }
function testBitwiseOperatorPrecedence6(int a, int b, int c) returns int { return b >> c & ~a; }
public function testByteReturnAsIntInLambda1() { var fn = function () returns int { byte a = 255; return a - a; }; assert(0, fn()); }
public function testByteReturnAsIntInLambda2() { var fn1 = function () returns int { byte a = 255; return a - a; }; var fn2 = function () returns int { byte a = 255; int res = a - a; return res; }; assertTrue(fn1() == fn2(), "fn1() == fn2()"); }
public function testByteReturnAsIntInLambda3() { byte a = 255; byte b = 255; var fn = function (byte a1, byte b1) returns int { return a1 - b1; }; assert(a - b, fn(a, b)); }
function assert(anydata expected, anydata actual) { if expected != actual { panic error("assertion failed"); } }
function assertTrue(boolean result, string condition) { if !result { panic error("condition [" + condition + "] evaluated to 'false'"); } }
