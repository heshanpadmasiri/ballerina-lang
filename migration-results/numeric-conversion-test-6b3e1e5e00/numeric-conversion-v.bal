import ballerina/io;

type Employee record {| string name; |};

function testFloatAsFloat(float f1) returns [boolean, float] {
    float s3 = <float> f1;
    anydata s4 = <float> getFloat(f1);

    return [s3 == s4 && s4 is float, s3];
}

function testFloatAsFloatInUnions(float f1) returns [boolean, float] {
    Employee|string|float f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    float s6 = <float> f2;
    float|boolean s7 = <float|boolean> f3;
    float s8 = <float> f4;
    float s9 = <float> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testFloatAsDecimal(float f1) returns [boolean, decimal] {
    decimal s3 = <decimal> f1;
    anydata s4 = <decimal> getFloat(f1);

    return [s3 == s4 && s4 is decimal, s3];
}

function testFloatAsDecimalInUnions(float f1) returns [boolean, decimal] {
    Employee|string|float f2 = f1;
    json f3 = f1;
    anydata f4 = getFloat(f1);
    any f5 = getFloat(f1);

    decimal s6 = <decimal> f2;
    decimal|Employee s7 = <decimal|Employee> f3;
    decimal s8 = <decimal> f4;
    decimal s9 = <decimal> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testFloatAsInt(float f1) returns [boolean, int] {
    int s3 = <int> f1;
    anydata s4 = <int> getFloat(f1);

    return [s3 == s4 && s4 is int, s3];
}

function testFloatAsIntInUnions(float f1) returns [boolean, int] {
    Employee|string|float f2 = f1;
    json f3 = f1;
    anydata f4 = getFloat(f1);
    any f5 = getFloat(f1);

    int s6 = <int> f2;
    int|Employee s7 = <int|Employee> f3;
    int s8 = <int> f4;
    int|string s9 = <int|string> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testFloatAsByte(float f1) returns [boolean, byte] {
    byte s3 = <byte> f1;
    anydata s4 = <byte> getFloat(f1);

    return [s3 == s4 && s4 is byte, s3];
}

function testFloatAsByteInUnions(float f1) returns [boolean, byte] {
    Employee|string|float f2 = f1;
    json f3 = f1;
    anydata f4 = getFloat(f1);
    any f5 = getFloat(f1);

    byte s6 = <byte> f2;
    byte|Employee s7 = <byte|Employee> f3;
    byte s8 = <byte> f4;
    byte|string s9 = <byte|string> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testDecimalAsFloat(decimal f1) returns [boolean, float] {
    float s3 = <float> f1;
    anydata s4 = <float> getDecimal(f1);

    return [s3 == s4 && s4 is float, s3];
}

function testDecimalAsFloatInUnions(decimal f1) returns [boolean, float|Employee|boolean|string] {
    Employee|string|decimal f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    float|string s6 = <float|string> f2;
    float|Employee|boolean s7 = <float|Employee|boolean> f3;
    float s8 = <float> f4;
    float s9 = <float> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testDecimalAsDecimal(decimal f1) returns [boolean, decimal] {
    decimal s3 = <decimal> f1;
    anydata s4 = <decimal> getDecimal(f1);

    return [s3 == s4 && s4 is decimal, s3];
}

function testDecimalAsDecimalInUnions(decimal f1) returns [boolean, decimal|string] {
    Employee|string|decimal f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    decimal|string s6 = <decimal|string> f2;
    decimal s7 = <decimal> f3;
    decimal s8 = <decimal> f4;
    decimal s9 = <decimal> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testDecimalAsInt(decimal f1) returns [boolean, int] {
    int s3 = <int> f1;
    anydata s4 = <int> getDecimal(f1);
    return [s3 == s4 && s4 is int, s3];
}

function testDecimalAsIntInUnions(decimal f1) returns [boolean, int] {
    Employee|string|decimal f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    int s6 = <int> f2;
    int|string s7 = <int|string> f3;
    int s8 = <int> f4;
    int s9 = <int> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testDecimalAsByte(decimal f1) returns [boolean, byte] {
    byte s3 = <byte> f1;
    anydata s4 = <byte> getDecimal(f1);
    return [s3 == s4 && s4 is byte, s3];
}

function testDecimalAsByteInUnions(decimal f1) returns [boolean, byte] {
    Employee|string|decimal f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    byte|Employee s6 = <byte|Employee> f2;
    byte|string s7 = <byte|string> f3;
    byte s8 = <byte> f4;
    byte s9 = <byte> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s9];
}

function testIntAsFloat(int f1) returns [boolean, float] {
    float s3 = <float> f1;
    anydata s4 = <float> getInt(f1);

    return [s3 == s4 && s4 is float, s3];
}

function testIntAsFloatInUnions(int f1) returns [boolean, float] {
    string|int|boolean f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    float s6 = <float> f2;
    float|string s7 = <float|string> f3;
    float|Employee|map<int> s8 = <float|Employee|map<int>> f4;
    float s9 = <float> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testIntAsDecimal(int f1) returns [boolean, decimal] {
    decimal s3 = <decimal> f1;
    anydata s4 = <decimal> getInt(f1);

    return [s3 == s4 && s4 is decimal, s3];
}

function testIntAsDecimalInUnions(int f1) returns [boolean, decimal] {
    string|int|boolean f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    decimal s6 = <decimal> f2;
    decimal|string s7 = <decimal|string> f3;
    decimal|Employee|map<float> s8 = <decimal|Employee|map<float>> f4;
    decimal s9 = <decimal> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testIntAsInt(int f1) returns [boolean, int] {
    int s3 = <int> f1;
    anydata s4 = <int> getInt(f1);
    return [s3 == s4 && s4 is int, s3];
}

function testIntAsIntInUnions(int f1) returns [boolean, int|boolean] {
    Employee|string|int f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    int|boolean s6 = <int|boolean> f2;
    int s7 = <int> f3;
    int s8 = <int> f4;
    int s9 = <int> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testIntAsByte(int f1) returns [boolean, byte] {
    byte s3 = <byte> f1;
    anydata s4 = <byte> getInt(f1);
    return [s3 == s4 && s4 is byte, s3];
}

function testIntAsByteInUnions(int f1) returns [boolean, byte|boolean] {
    Employee|string|int f2 = f1;
    json f3 = f1;
    anydata f4 = f1;
    any f5 = f1;

    byte|boolean s6 = <byte|boolean> f2;
    byte s7 = <byte> f3;
    byte s8 = <byte> f4;
    byte s9 = <byte> f5;

    return [s7 == s6 && s7 == s8 && s9 == s8, s6];
}

function testByteAsFloat(byte f1) returns [boolean, float] {
    float s3 = <float> f1;
    anydata s4 = <float> getByte(f1);

    return [s3 == s4 && s4 is float, s3];
}

function testByteAsFloatInUnions(byte f1) returns [boolean, float] {
    string|byte|boolean f2 = f1;
    anydata f3 = f1;
    any f4 = f1;

    float s6 = <float> f2;
    float|string s7 = <float|string> f3;
    float|Employee|map<int> s8 = <float|Employee|map<int>> f4;

    return [s7 == s6 && s7 == s8, s6];
}

function testByteAsDecimal(byte f1) returns [boolean, decimal] {
    decimal s3 = <decimal> f1;
    anydata s4 = <decimal> getByte(f1);

    return [s3 == s4 && s4 is decimal, s3];
}

function testByteAsDecimalInUnions(byte f1) returns [boolean, decimal] {
    string|byte f2 = f1;
    anydata f3 = f1;
    any f4 = f1;

    decimal s6 = <decimal> f2;
    decimal|string s7 = <decimal|string> f3;
    decimal|Employee|map<float> s8 = <decimal|Employee|map<float>> f4;

    return [s7 == s6 && s7 == s8, s6];
}

function testByteAsInt(byte f1) returns [boolean, int] {
    int s3 = <int> f1;
    anydata s4 = <int> getByte(f1);
    return [s3 == s4 && s4 is int, s3];
}

function testByteAsIntInUnions(byte f1) returns [boolean, int|boolean] {
    Employee|byte f2 = f1;
    anydata f3 = f1;
    any f4 = f1;

    int|boolean s6 = <int|boolean> f2;
    int s7 = <int> f3;
    int s8 = <int> f4;

    return [s7 == s6 && s7 == s8, s6];
}

function testByteAsByte(byte f1) returns [boolean, byte] {
    byte s3 = <byte> f1;
    anydata s4 = <byte> getByte(f1);
    return [s3 == s4 && s4 is byte, s3];
}

function testByteAsByteInUnions(byte f1) returns [boolean, byte|boolean] {
    Employee|string|byte f2 = f1;
    anydata f3 = f1;
    any f4 = f1;

    byte|boolean s6 = <byte|boolean> f2;
    byte s7 = <byte> f3;
    byte s8 = <byte> f4;

    return [s7 == s6 && s7 == s8, s6];
}

function testExplicitlyTypedExprForExactValues() returns error? {
    // test from float
    float f = 12.345;
    decimal fd = 12.345;
    byte fb = 12;

    float f1 = <float> f;
    if (f1 != f) {
        error e = error("invalid resultant value, from float to float");
        return e;
    }

    decimal d1 = <decimal> f;
    if (d1 != fd)  {
        error e = error("invalid resultant value, from float to decimal");
        return e;
    }

    int i1 = <int> f;
    if (i1 != 12) {
        error e = error("invalid resultant value, from float to int");
        return e;
    }

    byte b1 = <byte> f;
    if (b1 != fb) {
        error e = error("invalid resultant value, from float to byte");
        return e;
    }

    // test from decimal
    decimal d = 12.345;

    float f2 = <float> d;
    if (f2 != f) {
        error e = error("invalid resultant value, from decimal to float");
        return e;
    }

    decimal d2 = <decimal> d;
    if (d2 != d) {
        error e = error("invalid resultant value, from decimal to decimal");
        return e;
    }

    int i2 = <int> d;
    if (i2 != 12) {
        error e = error("invalid resultant value, from decimal to int");
        return e;
    }

    byte b2 = <byte> d;
    if (b2 != fb) {
        error e = error("invalid resultant value, from decimal to byte");
        return e;
    }

    // test from int
    int i = 123;
    float intf = 123.0;
    decimal intd = 123.0;
    byte intb = 123;

    float f3 = <float> i;
    if (f3 != intf) {
        error e = error("invalid resultant value, from int to float");
        return e;
    }

    decimal d3 = <decimal> i;
    if (d3 != intd) {
        error e = error("invalid resultant value, from int to decimal");
        return e;
    }

    int i3 = <int> i;
    if (i3 != i) {
        error e = error("invalid resultant value, from int to int");
        return e;
    }

    byte b3 = <byte> i;
    if (b3 != intb) {
        error e = error("invalid resultant value, from int to byte");
        return e;
    }

    // test from byte
    byte b = 255;
    float bytef = 255.0;
    decimal byted = 255.0;
    int bytei = 255;

    float f4 = <float> b;
    if (f4 != bytef) {
        error e = error("invalid resultant value, from byte to float");
        return e;
    }

    decimal d4 = <decimal> b;
    if (d4 != byted) {
        error e = error("invalid resultant value, from byte to decimal");
        return e;
    }

    int i4 = <int> b;
    if (i4 != bytei) {
        error e = error("invalid resultant value, from byte to int");
        return e;
    }

    byte b4 = <byte> b;
    if (b4 != b) {
        error e = error("invalid resultant value, from byte to byte");
        return e;
    }
    return;
}

function testConversionFromUnionWithNumericBasicTypes() returns boolean {
    float f = 12.0;
    decimal d = 110.5;
    int|boolean u1 = 12;
    float f1 = <float> u1;
    boolean conversionSuccessful = f1 == f;

    float|int|string u2 = 110.5f;
    decimal|boolean d1 = <decimal|boolean> u2;
    return conversionSuccessful && d1 == d;
}

function testNumericConversionFromBasicTypeToUnionType() returns boolean {
    float f1 = 12.0;
    int i1 = 12;
    decimal d1 = 12.0;
    byte b1 = 12;

    int|boolean u1 = <int|boolean> f1;
    decimal|string u2 = <decimal|string> f1;
    byte|string|Employee u3 = <byte|string|Employee> f1;
    boolean conversionSuccessful = u1 == i1 && u2 == d1 && u3 == b1;

    float|boolean u4 = <float|boolean> i1;
    decimal|string u5 = <decimal|string> i1;
    byte|string|Employee u6 = <byte|string|Employee> i1;
    conversionSuccessful = conversionSuccessful && u4 == f1 && u5 == d1 && u6 == b1;

    float|boolean u7 = <float|boolean> d1;
    int|string u8 = <int|string> d1;
    byte|string|Employee u9 = <byte|string|Employee> d1;
    conversionSuccessful = conversionSuccessful && u7 == f1 && u8 == i1 && u9 == b1;

    float|boolean u10 = <float|boolean> b1;
    int|string u11 = <int|string> b1;
    decimal|string|Employee u12 = <decimal|string|Employee> b1;
    conversionSuccessful = conversionSuccessful && u10 == f1 && u11 == i1 && u12 == d1;
    return conversionSuccessful;
}

type IntOrFoo int|"foo";
type OneOrString 1|string;
type OneOrTwo 1.0|2.0;
function testNumericConversionFromFiniteType() returns boolean {
    IntOrFoo a = 10;
    float b = <float> a;
    boolean conversionSuccessful = b == 10.0;

    OneOrString c = 1;
    decimal d = <decimal> c;
    decimal e = 1.0;
    conversionSuccessful = conversionSuccessful && d == e;

    OneOrTwo f = 2.0;
    int g = <int> f;
    return conversionSuccessful && g === 2;
}

function getFloat(float f) returns float {
    return f;
}

function getDecimal(decimal d) returns decimal {
    return d;
}

function getInt(int i) returns int {
    return i;
}

function getByte(byte b) returns byte {
    return b;
}

public function main() {
    var r0 = testFloatAsFloat(-1234.57);
    io:println(r0[0]); // @output true
    io:println(r0[1]); // @output -1234.57
    var r1 = testFloatAsFloat(0.0);
    io:println(r1[0]); // @output true
    io:println(r1[1]); // @output 0.0
    var r2 = testFloatAsFloat(1.5);
    io:println(r2[0]); // @output true
    io:println(r2[1]); // @output 1.5
    var r3 = testFloatAsFloat(53456.032);
    io:println(r3[0]); // @output true
    io:println(r3[1]); // @output 53456.032
    var r4 = testFloatAsFloatInUnions(-1234.57);
    io:println(r4[0]); // @output true
    io:println(r4[1]); // @output -1234.57
    var r5 = testFloatAsFloatInUnions(0.0);
    io:println(r5[0]); // @output true
    io:println(r5[1]); // @output 0.0
    var r6 = testFloatAsFloatInUnions(1.5);
    io:println(r6[0]); // @output true
    io:println(r6[1]); // @output 1.5
    var r7 = testFloatAsFloatInUnions(53456.032);
    io:println(r7[0]); // @output true
    io:println(r7[1]); // @output 53456.032
    var r8 = testFloatAsDecimal(-1234.57);
    io:println(r8[0]); // @output true
    io:println(r8[1]); // @output -1234.57
    var r9 = testFloatAsDecimal(0.0);
    io:println(r9[0]); // @output true
    io:println(r9[1]); // @output 0
    var r10 = testFloatAsDecimal(1.5);
    io:println(r10[0]); // @output true
    io:println(r10[1]); // @output 1.5
    var r11 = testFloatAsDecimal(53456.032);
    io:println(r11[0]); // @output true
    io:println(r11[1]); // @output 53456.032
    var r12 = testFloatAsDecimalInUnions(-1234.57);
    io:println(r12[0]); // @output true
    io:println(r12[1]); // @output -1234.57
    var r13 = testFloatAsDecimalInUnions(0.0);
    io:println(r13[0]); // @output true
    io:println(r13[1]); // @output 0
    var r14 = testFloatAsDecimalInUnions(1.5);
    io:println(r14[0]); // @output true
    io:println(r14[1]); // @output 1.5
    var r15 = testFloatAsDecimalInUnions(53456.032);
    io:println(r15[0]); // @output true
    io:println(r15[1]); // @output 53456.032
    var r16 = testFloatAsInt(-1234.57);
    io:println(r16[0]); // @output true
    io:println(r16[1]); // @output -1235
    var r17 = testFloatAsInt(0.0);
    io:println(r17[0]); // @output true
    io:println(r17[1]); // @output 0
    var r18 = testFloatAsInt(1.5);
    io:println(r18[0]); // @output true
    io:println(r18[1]); // @output 2
    var r19 = testFloatAsInt(53456.032);
    io:println(r19[0]); // @output true
    io:println(r19[1]); // @output 53456
    var r20 = testFloatAsIntInUnions(-1234.57);
    io:println(r20[0]); // @output true
    io:println(r20[1]); // @output -1235
    var r21 = testFloatAsIntInUnions(0.0);
    io:println(r21[0]); // @output true
    io:println(r21[1]); // @output 0
    var r22 = testFloatAsIntInUnions(1.5);
    io:println(r22[0]); // @output true
    io:println(r22[1]); // @output 2
    var r23 = testFloatAsIntInUnions(53456.032);
    io:println(r23[0]); // @output true
    io:println(r23[1]); // @output 53456
    var r24 = testFloatAsByte(0.99);
    io:println(r24[0]); // @output true
    io:println(r24[1]); // @output 1
    var r25 = testFloatAsByte(0.0);
    io:println(r25[0]); // @output true
    io:println(r25[1]); // @output 0
    var r26 = testFloatAsByte(1.0);
    io:println(r26[0]); // @output true
    io:println(r26[1]); // @output 1
    var r27 = testFloatAsByte(255.4);
    io:println(r27[0]); // @output true
    io:println(r27[1]); // @output 255
    var r28 = testFloatAsByteInUnions(0.99);
    io:println(r28[0]); // @output true
    io:println(r28[1]); // @output 1
    var r29 = testFloatAsByteInUnions(0.0);
    io:println(r29[0]); // @output true
    io:println(r29[1]); // @output 0
    var r30 = testFloatAsByteInUnions(1.0);
    io:println(r30[0]); // @output true
    io:println(r30[1]); // @output 1
    var r31 = testFloatAsByteInUnions(255.4);
    io:println(r31[0]); // @output true
    io:println(r31[1]); // @output 255
    var r32 = testDecimalAsFloat(-1234.57);
    io:println(r32[0]); // @output true
    io:println(r32[1]); // @output -1234.57
    var r33 = testDecimalAsFloat(53456.032);
    io:println(r33[0]); // @output true
    io:println(r33[1]); // @output 53456.032
    var r34 = testDecimalAsFloat(0.0);
    io:println(r34[0]); // @output true
    io:println(r34[1]); // @output 0.0
    var r35 = testDecimalAsFloat(1.1);
    io:println(r35[0]); // @output true
    io:println(r35[1]); // @output 1.1
    var r36 = testDecimalAsFloatInUnions(-1234.57);
    io:println(r36[0]); // @output true
    io:println(r36[1]); // @output -1234.57
    var r37 = testDecimalAsFloatInUnions(53456.032);
    io:println(r37[0]); // @output true
    io:println(r37[1]); // @output 53456.032
    var r38 = testDecimalAsFloatInUnions(0.0);
    io:println(r38[0]); // @output true
    io:println(r38[1]); // @output 0.0
    var r39 = testDecimalAsFloatInUnions(1.1);
    io:println(r39[0]); // @output true
    io:println(r39[1]); // @output 1.1
    var r40 = testDecimalAsDecimal(-1234.57);
    io:println(r40[0]); // @output true
    io:println(r40[1]); // @output -1234.57
    var r41 = testDecimalAsDecimal(53456.032);
    io:println(r41[0]); // @output true
    io:println(r41[1]); // @output 53456.032
    var r42 = testDecimalAsDecimal(0.0);
    io:println(r42[0]); // @output true
    io:println(r42[1]); // @output 0
    var r43 = testDecimalAsDecimal(1.1);
    io:println(r43[0]); // @output true
    io:println(r43[1]); // @output 1.1
    var r44 = testDecimalAsDecimalInUnions(-1234.57);
    io:println(r44[0]); // @output true
    io:println(r44[1]); // @output -1234.57
    var r45 = testDecimalAsDecimalInUnions(53456.032);
    io:println(r45[0]); // @output true
    io:println(r45[1]); // @output 53456.032
    var r46 = testDecimalAsDecimalInUnions(0.0);
    io:println(r46[0]); // @output true
    io:println(r46[1]); // @output 0
    var r47 = testDecimalAsDecimalInUnions(1.1);
    io:println(r47[0]); // @output true
    io:println(r47[1]); // @output 1.1
    var r48 = testDecimalAsInt(-1234.57);
    io:println(r48[0]); // @output true
    io:println(r48[1]); // @output -1235
    var r49 = testDecimalAsInt(53456.032);
    io:println(r49[0]); // @output true
    io:println(r49[1]); // @output 53456
    var r50 = testDecimalAsInt(0.0);
    io:println(r50[0]); // @output true
    io:println(r50[1]); // @output 0
    var r51 = testDecimalAsInt(1.1);
    io:println(r51[0]); // @output true
    io:println(r51[1]); // @output 1
    var r52 = testDecimalAsIntInUnions(-1234.57);
    io:println(r52[0]); // @output true
    io:println(r52[1]); // @output -1235
    var r53 = testDecimalAsIntInUnions(53456.032);
    io:println(r53[0]); // @output true
    io:println(r53[1]); // @output 53456
    var r54 = testDecimalAsIntInUnions(0.0);
    io:println(r54[0]); // @output true
    io:println(r54[1]); // @output 0
    var r55 = testDecimalAsIntInUnions(1.1);
    io:println(r55[0]); // @output true
    io:println(r55[1]); // @output 1
    var r56 = testDecimalAsByte(0.9);
    io:println(r56[0]); // @output true
    io:println(r56[1]); // @output 1
    var r57 = testDecimalAsByte(1.032);
    io:println(r57[0]); // @output true
    io:println(r57[1]); // @output 1
    var r58 = testDecimalAsByte(254.30);
    io:println(r58[0]); // @output true
    io:println(r58[1]); // @output 254
    var r59 = testDecimalAsByte(255.10);
    io:println(r59[0]); // @output true
    io:println(r59[1]); // @output 255
    var r60 = testDecimalAsByteInUnions(0.9);
    io:println(r60[0]); // @output true
    io:println(r60[1]); // @output 1
    var r61 = testDecimalAsByteInUnions(1.032);
    io:println(r61[0]); // @output true
    io:println(r61[1]); // @output 1
    var r62 = testDecimalAsByteInUnions(254.30);
    io:println(r62[0]); // @output true
    io:println(r62[1]); // @output 254
    var r63 = testDecimalAsByteInUnions(255.10);
    io:println(r63[0]); // @output true
    io:println(r63[1]); // @output 255
    var r64 = testIntAsFloat(-123457);
    io:println(r64[0]); // @output true
    io:println(r64[1]); // @output -123457.0
    var r65 = testIntAsFloat(0);
    io:println(r65[0]); // @output true
    io:println(r65[1]); // @output 0.0
    var r66 = testIntAsFloat(1);
    io:println(r66[0]); // @output true
    io:println(r66[1]); // @output 1.0
    var r67 = testIntAsFloat(53456032);
    io:println(r67[0]); // @output true
    io:println(r67[1]); // @output 5.3456032E7
    var r68 = testIntAsFloatInUnions(-123457);
    io:println(r68[0]); // @output true
    io:println(r68[1]); // @output -123457.0
    var r69 = testIntAsFloatInUnions(0);
    io:println(r69[0]); // @output true
    io:println(r69[1]); // @output 0.0
    var r70 = testIntAsFloatInUnions(1);
    io:println(r70[0]); // @output true
    io:println(r70[1]); // @output 1.0
    var r71 = testIntAsFloatInUnions(53456032);
    io:println(r71[0]); // @output true
    io:println(r71[1]); // @output 5.3456032E7
    var r72 = testIntAsDecimal(-123457);
    io:println(r72[0]); // @output true
    io:println(<int> r72[1]); // @output -123457
    var r73 = testIntAsDecimal(0);
    io:println(r73[0]); // @output true
    io:println(<int> r73[1]); // @output 0
    var r74 = testIntAsDecimal(1);
    io:println(r74[0]); // @output true
    io:println(<int> r74[1]); // @output 1
    var r75 = testIntAsDecimal(53456032);
    io:println(r75[0]); // @output true
    io:println(<int> r75[1]); // @output 53456032
    var r76 = testIntAsDecimalInUnions(-123457);
    io:println(r76[0]); // @output true
    io:println(<int> r76[1]); // @output -123457
    var r77 = testIntAsDecimalInUnions(0);
    io:println(r77[0]); // @output true
    io:println(<int> r77[1]); // @output 0
    var r78 = testIntAsDecimalInUnions(1);
    io:println(r78[0]); // @output true
    io:println(<int> r78[1]); // @output 1
    var r79 = testIntAsDecimalInUnions(53456032);
    io:println(r79[0]); // @output true
    io:println(<int> r79[1]); // @output 53456032
    var r80 = testIntAsInt(-123457);
    io:println(r80[0]); // @output true
    io:println(r80[1]); // @output -123457
    var r81 = testIntAsInt(0);
    io:println(r81[0]); // @output true
    io:println(r81[1]); // @output 0
    var r82 = testIntAsInt(1);
    io:println(r82[0]); // @output true
    io:println(r82[1]); // @output 1
    var r83 = testIntAsInt(53456032);
    io:println(r83[0]); // @output true
    io:println(r83[1]); // @output 53456032
    var r84 = testIntAsIntInUnions(-123457);
    io:println(r84[0]); // @output true
    io:println(r84[1]); // @output -123457
    var r85 = testIntAsIntInUnions(0);
    io:println(r85[0]); // @output true
    io:println(r85[1]); // @output 0
    var r86 = testIntAsIntInUnions(1);
    io:println(r86[0]); // @output true
    io:println(r86[1]); // @output 1
    var r87 = testIntAsIntInUnions(53456032);
    io:println(r87[0]); // @output true
    io:println(r87[1]); // @output 53456032
    var r88 = testIntAsByte(0);
    io:println(r88[0]); // @output true
    io:println(r88[1]); // @output 0
    var r89 = testIntAsByte(1);
    io:println(r89[0]); // @output true
    io:println(r89[1]); // @output 1
    var r90 = testIntAsByte(254);
    io:println(r90[0]); // @output true
    io:println(r90[1]); // @output 254
    var r91 = testIntAsByte(255);
    io:println(r91[0]); // @output true
    io:println(r91[1]); // @output 255
    var r92 = testIntAsByteInUnions(0);
    io:println(r92[0]); // @output true
    io:println(r92[1]); // @output 0
    var r93 = testIntAsByteInUnions(1);
    io:println(r93[0]); // @output true
    io:println(r93[1]); // @output 1
    var r94 = testIntAsByteInUnions(254);
    io:println(r94[0]); // @output true
    io:println(r94[1]); // @output 254
    var r95 = testIntAsByteInUnions(255);
    io:println(r95[0]); // @output true
    io:println(r95[1]); // @output 255
    var r96 = testByteAsFloat(0);
    io:println(r96[0]); // @output true
    io:println(r96[1]); // @output 0.0
    var r97 = testByteAsFloat(1);
    io:println(r97[0]); // @output true
    io:println(r97[1]); // @output 1.0
    var r98 = testByteAsFloat(254);
    io:println(r98[0]); // @output true
    io:println(r98[1]); // @output 254.0
    var r99 = testByteAsFloat(255);
    io:println(r99[0]); // @output true
    io:println(r99[1]); // @output 255.0
    var r100 = testByteAsFloatInUnions(0);
    io:println(r100[0]); // @output true
    io:println(r100[1]); // @output 0.0
    var r101 = testByteAsFloatInUnions(1);
    io:println(r101[0]); // @output true
    io:println(r101[1]); // @output 1.0
    var r102 = testByteAsFloatInUnions(254);
    io:println(r102[0]); // @output true
    io:println(r102[1]); // @output 254.0
    var r103 = testByteAsFloatInUnions(255);
    io:println(r103[0]); // @output true
    io:println(r103[1]); // @output 255.0
    var r104 = testByteAsDecimal(0);
    io:println(r104[0]); // @output true
    io:println(r104[1]); // @output 0
    var r105 = testByteAsDecimal(1);
    io:println(r105[0]); // @output true
    io:println(r105[1]); // @output 1.0
    var r106 = testByteAsDecimal(254);
    io:println(r106[0]); // @output true
    io:println(r106[1]); // @output 254.0
    var r107 = testByteAsDecimal(255);
    io:println(r107[0]); // @output true
    io:println(r107[1]); // @output 255.0
    var r108 = testByteAsDecimalInUnions(0);
    io:println(r108[0]); // @output true
    io:println(r108[1]); // @output 0
    var r109 = testByteAsDecimalInUnions(1);
    io:println(r109[0]); // @output true
    io:println(r109[1]); // @output 1.0
    var r110 = testByteAsDecimalInUnions(254);
    io:println(r110[0]); // @output true
    io:println(r110[1]); // @output 254.0
    var r111 = testByteAsDecimalInUnions(255);
    io:println(r111[0]); // @output true
    io:println(r111[1]); // @output 255.0
    var r112 = testByteAsInt(0);
    io:println(r112[0]); // @output true
    io:println(r112[1]); // @output 0
    var r113 = testByteAsInt(1);
    io:println(r113[0]); // @output true
    io:println(r113[1]); // @output 1
    var r114 = testByteAsInt(254);
    io:println(r114[0]); // @output true
    io:println(r114[1]); // @output 254
    var r115 = testByteAsInt(255);
    io:println(r115[0]); // @output true
    io:println(r115[1]); // @output 255
    var r116 = testByteAsIntInUnions(0);
    io:println(r116[0]); // @output true
    io:println(r116[1]); // @output 0
    var r117 = testByteAsIntInUnions(1);
    io:println(r117[0]); // @output true
    io:println(r117[1]); // @output 1
    var r118 = testByteAsIntInUnions(254);
    io:println(r118[0]); // @output true
    io:println(r118[1]); // @output 254
    var r119 = testByteAsIntInUnions(255);
    io:println(r119[0]); // @output true
    io:println(r119[1]); // @output 255
    var r120 = testByteAsByte(0);
    io:println(r120[0]); // @output true
    io:println(r120[1]); // @output 0
    var r121 = testByteAsByte(1);
    io:println(r121[0]); // @output true
    io:println(r121[1]); // @output 1
    var r122 = testByteAsByte(254);
    io:println(r122[0]); // @output true
    io:println(r122[1]); // @output 254
    var r123 = testByteAsByte(255);
    io:println(r123[0]); // @output true
    io:println(r123[1]); // @output 255
    var r124 = testByteAsByteInUnions(0);
    io:println(r124[0]); // @output true
    io:println(r124[1]); // @output 0
    var r125 = testByteAsByteInUnions(1);
    io:println(r125[0]); // @output true
    io:println(r125[1]); // @output 1
    var r126 = testByteAsByteInUnions(254);
    io:println(r126[0]); // @output true
    io:println(r126[1]); // @output 254
    var r127 = testByteAsByteInUnions(255);
    io:println(r127[0]); // @output true
    io:println(r127[1]); // @output 255
    checkpanic testExplicitlyTypedExprForExactValues();
    io:println(testConversionFromUnionWithNumericBasicTypes()); // @output true
    io:println(testNumericConversionFromBasicTypeToUnionType()); // @output true
    io:println(testNumericConversionFromFiniteType()); // @output true
}
