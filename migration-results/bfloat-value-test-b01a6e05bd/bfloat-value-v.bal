import ballerina/io;

function testFloatValue() returns float {
    float b;
    b = 10.1;
    return b;
}

function testNegativeFloatValue() returns float {
    float y;
    y = -10.1;
    return y;
}

function testFloatValueAssignmentByReturnValue() returns float {
    float x;
    x = testFloatValue();
    return x;
}

function testFloatAddition() returns float {
    float b;
    float a;
    a = 9.9;
    b = 10.1;
    return a + b;
}

function testFloatMultiplication() returns float {
    float b;
    float a;
    a = 2.5;
    b = 5.5;
    return a * b;
}

function testFloatSubtraction() returns float {
    float b;
    float a;
    a = 25.5;
    b = 15.5;
    return a - b;
}

function testFloatDivision() returns float {
    float b;
    float a;
    a = 25.5;
    b = 5.1;
    return a / b;
}

function testFloatParameter(float a) returns float {
    float b;
    b = a;
    return b;
}

function testFloatValues() returns [float, float, float, float] {
    float a = 123.4;
    float b = 1.234e2;
    float c = 123.4;
    float d = 1.234e2;
    return [a, b, c, d];
}

function testHexFloatingPointLiterals() returns [float, float, float, float] {
    float a = 0X12Ab.0;
    float b = 0x8.0;
    float c = 0xaP-1;
    float d = 0x3p2;
    return [a, b, c, d];
}

function testIntLiteralAssignment() returns [float, float] {
    float x = 12;
    return [x, 15];
}

function testDiscriminatedFloatLiteral() returns [float, float, float] {
    float a = 1.0f;
    var b = 1.0f;
    float d = 2.2e3f;
    return [a, b, d];
}

function testHexaDecimalLiteralsWithFloat() {
    float f1 = 0x5;
    float f2 = 0x555;
    assertEqual(5.0, f1);
    assertEqual(1365.0, f2);
}

function testOutOfRangeIntWithFloat() {
    float f1 = 999999999999999999999999999999;
    assertEqual(1.0E30, f1);
}

function assertEqual(any expected, any actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected.toString();
    string actualValAsString = actual.toString();
    panic error(string `Assertion error: expected ${expectedValAsString} found ${actualValAsString}`);
}

public function main() {
    io:println(testFloatValue()); // @output 10.1
    io:println(testNegativeFloatValue()); // @output -10.1
    io:println(testFloatValueAssignmentByReturnValue()); // @output 10.1
    io:println(testFloatParameter(3.3)); // @output 3.3
    io:println(testFloatAddition()); // @output 20.0
    io:println(testFloatSubtraction()); // @output 10.0
    io:println(testFloatMultiplication()); // @output 13.75
    io:println(testFloatDivision()); // @output 5.0

    var values = testFloatValues();
    io:println(values.length()); // @output 4
    io:println(values[0]); // @output 123.4
    io:println(values[1]); // @output 123.4
    io:println(values[2]); // @output 123.4
    io:println(values[3]); // @output 123.4

    var hexValues = testHexFloatingPointLiterals();
    io:println(hexValues.length()); // @output 4
    io:println(hexValues[0]); // @output 4779.0
    io:println(hexValues[1]); // @output 8.0
    io:println(hexValues[2]); // @output 5.0
    io:println(hexValues[3]); // @output 12.0

    var intValues = testIntLiteralAssignment();
    io:println(intValues.length()); // @output 2
    io:println(intValues[0]); // @output 12.0
    io:println(intValues[1]); // @output 15.0

    var discriminatedValues = testDiscriminatedFloatLiteral();
    io:println(discriminatedValues.length()); // @output 3
    io:println(discriminatedValues[0]); // @output 1.0
    io:println(discriminatedValues[1]); // @output 1.0
    io:println(discriminatedValues[2]); // @output 2200.0

    testHexaDecimalLiteralsWithFloat();
    testOutOfRangeIntWithFloat();
}
