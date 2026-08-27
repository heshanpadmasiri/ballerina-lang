import ballerina/io;

public function testByteAddition1() returns int {
    byte b1 = 23;
    byte b2 = 12;
    return b1 + b2;
}

public function testByteAddition2() returns int {
    byte b1 = 43;
    byte b2 = 236;
    return b1 + b2;
}

public function testByteIntAddition1() returns int {
    byte b1 = 43;
    int b2 = 3456;
    return b1 + b2;
}

public function testByteIntAddition2() returns int {
    int b1 = -423;
    byte b2 = 34;
    return b1 + b2;
}

public function testByteSubtraction1() returns int {
    byte b1 = 255;
    byte b2 = 55;
    return b1 - b2;
}

public function testByteSubtraction2() returns int {
    byte b1 = 55;
    byte b2 = 255;
    return b1 - b2;
}

public function testByteIntSubtraction1() returns int {
    byte b1 = 55;
    int b2 = 2555;
    return b1 - b2;
}

public function testByteIntSubtraction2() returns int {
    int b1 = -2555;
    byte b2 = 55;
    return b1 - b2;
}

public function testByteMultiplication1() returns int {
    byte b1 = 12;
    byte b2 = 20;
    return b1 * b2;
}

public function testByteMultiplication2() returns int {
    byte b1 = 250;
    byte b2 = 110;
    return b1 * b2;
}

public function testByteIntMultiplication1() returns int {
    byte b1 = 55;
    int b2 = -200;
    return b1 * b2;
}

public function testByteIntMultiplication2() returns int {
    int b1 = 300;
    byte b2 = 50;
    return b1 * b2;
}

public function testByteDivision1() returns int {
    byte b1 = 22;
    byte b2 = 10;
    return b1 / b2;
}

public function testByteDivision2() returns int {
    byte b1 = 250;
    byte b2 = 70;
    return b1 / b2;
}

public function testByteIntDivision1() returns int {
    byte b1 = 155;
    int b2 = -22;
    return b1 / b2;
}

public function testByteIntDivision2() returns int {
    int b1 = 334;
    byte b2 = 21;
    return b1 / b2;
}

public function testByteModulus1() returns int {
    byte b1 = 22;
    byte b2 = 10;
    return b1 % b2;
}

public function testByteModulus2() returns int {
    byte b1 = 250;
    byte b2 = 110;
    return b1 % b2;
}

public function testByteIntModulus1() returns int {
    byte b1 = 155;
    int b2 = -22;
    return b1 % b2;
}

public function testByteIntModulus2() returns int {
    int b1 = 334;
    byte b2 = 21;
    return b1 % b2;
}

public function testByteComplexExpression() returns int {
    byte[] b = [23, 47, 165, 234];
    byte b1 = b[0];
    byte b2 = b[1];
    return b1 + b2 * (b[3] / b[2]) - b[3];
}

public function testByteBitwiseAnd() returns byte {
    byte b1 = 191;
    byte b2 = 88;
    return b1 & b2;
}

public function testIntByteBitwiseAnd() returns int {
    int b1 = 959;
    int b2 = 88;
    return b1 & b2;
}

public function testByteIntBitwiseAnd() returns int {
    int b1 = 88;
    int b2 = -1;
    return b1 & b2;
}

public function testIntBitwiseAnd() returns int {
    int i1 = 959;
    int i2 = 447;
    return i1 & i2;
}

public function testByteBitwiseOr() returns byte {
    byte b1 = 191;
    byte b2 = 88;
    return b1 | b2;
}

public function testIntByteBitwiseOr() returns int {
    int b1 = 703;
    byte b2 = 88;
    return b1 | b2;
}

public function testByteIntBitwiseOr() returns int {
    byte b1 = 80;
    int b2 = 696;
    return b1 | b2;
}

public function testIntBitwiseOr() returns int {
    int i1 = -80;
    int i2 = 696;
    return i1 | i2;
}

public function testByteBitwiseXor() returns byte {
    byte b1 = 191;
    byte b2 = 88;
    return b1 ^ b2;
}

public function testIntByteBitwiseXor() returns int {
    int b1 = -191;
    byte b2 = 43;
    return b1 ^ b2;
}

public function testByteIntBitwiseXor() returns int {
    byte b1 = 43;
    int b2 = 191;
    return b1 ^ b2;
}

public function testIntBitwiseXor() returns int {
    int i1 = -443;
    int i2 = 191;
    return i1 ^ i2;
}

public function testByteBitwiseComplement() returns int {
    byte b = 191;
    return ~b;
}

public function testIntBitwiseComplement() returns int {
    int i = 191;
    return ~i;
}

public function main() {
    io:println(testByteAddition1()); // @output 35
    io:println(testByteAddition2()); // @output 279
    io:println(testByteIntAddition1()); // @output 3499
    io:println(testByteIntAddition2()); // @output -389
    io:println(testByteSubtraction1()); // @output 200
    io:println(testByteSubtraction2()); // @output -200
    io:println(testByteIntSubtraction1()); // @output -2500
    io:println(testByteIntSubtraction2()); // @output -2610
    io:println(testByteMultiplication1()); // @output 240
    io:println(testByteMultiplication2()); // @output 27500
    io:println(testByteIntMultiplication1()); // @output -11000
    io:println(testByteIntMultiplication2()); // @output 15000
    io:println(testByteDivision1()); // @output 2
    io:println(testByteDivision2()); // @output 3
    io:println(testByteIntDivision1()); // @output -7
    io:println(testByteIntDivision2()); // @output 15
    io:println(testByteModulus1()); // @output 2
    io:println(testByteModulus2()); // @output 30
    io:println(testByteIntModulus1()); // @output 1
    io:println(testByteIntModulus2()); // @output 19
    io:println(testByteComplexExpression()); // @output -164
    io:println(testByteBitwiseAnd()); // @output 24
    io:println(testIntByteBitwiseAnd()); // @output 24
    io:println(testByteIntBitwiseAnd()); // @output 88
    io:println(testIntBitwiseAnd()); // @output 447
    io:println(testByteBitwiseOr()); // @output 255
    io:println(testIntByteBitwiseOr()); // @output 767
    io:println(testByteIntBitwiseOr()); // @output 760
    io:println(testIntBitwiseOr()); // @output -72
    io:println(testByteBitwiseXor()); // @output 231
    io:println(testIntByteBitwiseXor()); // @output -150
    io:println(testByteIntBitwiseXor()); // @output 148
    io:println(testIntBitwiseXor()); // @output -262
    io:println(testByteBitwiseComplement()); // @output -192
    io:println(testIntBitwiseComplement()); // @output -192
}
