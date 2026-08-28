import ballerina/io;

function testDecimalValue() returns decimal {
    decimal d;
    d = 10.1;
    return d;
}

function testNegativeDecimalValue() returns decimal {
    decimal d;
    d = -10.1;
    return d;
}

function testDecimalValueAssignmentByReturnValue() returns decimal {
    decimal d;
    d = testDecimalValue();
    return d;
}

function testDecimalAddition() returns decimal {
    decimal a = 4.565;
    decimal b = 3.1;
    return a + b;
}

function testDecimalSubtraction() returns decimal {
    decimal a = 4.565;
    decimal b = 3.1;
    return a - b;
}

function testDecimalMultiplication() returns decimal {
    decimal a = 4.565;
    decimal b = 3.1;
    return a * b;
}

function testDecimalDivision() returns decimal {
    decimal a = 4.565;
    decimal b = 3.1;
    return a / b;
}

function testDecimalModulus() returns decimal {
    decimal a = 4.565;
    decimal b = 3.1;
    return a % b;
}

function testDecimalNegation() returns decimal {
    decimal a = 4.565;
    return -a;
}

function testDecimalComparisonOperations() returns [boolean, boolean, boolean, boolean, boolean, boolean] {
    decimal d1 = 45.678432;
    decimal d2 = 45.678432005;
    return [d1 == d2, d1 != d2, d1 > d2, d1 < d2, d1 >= d2, d1 <= d2];
}

function testDecimalParameter(decimal a, decimal b) returns [decimal, decimal] {
    decimal c = a;
    decimal d = b;
    return [c, d];
}

function testIntLiteralAssignment() returns [decimal, decimal] {
    decimal d = 12;
    return [d, 15];
}

function testDecimalArrayValue() returns decimal[] {
    decimal[] ds = [1.0, 2.0];
    return ds;
}

function testDecimalArrayValueWithDiscriminator() returns decimal[] {
    decimal[] ds = [1.0d, 2.0d, 3.0e3d];
    return ds;
}

function testDiscriminatedDecimalLiterals() returns [decimal, decimal, decimal, decimal] {
    var a = 3.22d;
    var b = 0.0e5d;
    decimal c = 3.141592653589793238462643383279502d;
    decimal d = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679d;
    return [a, b, c, d];
}

function testPositivelySignedLiteralAssignment() returns [decimal, decimal, decimal] {
    decimal d1 = +12.23;
    decimal d2 = +0.0;
    decimal d4 = -12.23;
    decimal d5 = d1 + d4;
    return [d1, d2, d5];
}

function testDecimalInferenceInMapContext() returns map<decimal> {
    map<decimal> md = {a: 33.3d, b: 33.3, c: 0.1, d: 1, e: 10000000000000000000000.123};
    return md;
}

function decimalInferenceInLiterals() returns [decimal, decimal, decimal, decimal, decimal] {
    decimal a = 1.0 / 2.0;
    decimal b = 1.0 + 2.0;
    decimal c = 1.0 - 2.0;
    decimal d = 1.0 * 2.0;
    decimal k = 10000.0001;
    decimal e = 1.0 / 2.0 / 1.0 + 1.0 * 0.005 + k;
    return [a, b, c, d, e];
}

public function decimalArrayLoad() returns decimal {
    decimal[] a = [1.0, 2.0];
    return a[1];
}

function testDecimalFillerValue() {
    [decimal] a = [];
    decimal[1] b = [];
    assertEquality(+0d, a[0]);
    assertEquality(+0d, b[0]);
    assertEquality(true, a == b);
}

function testDecimalZeroOperations() {
    decimal result = 1.2 + 0;
    assertEquality(1.2d, result);
    result = 0 - 0;
    assertEquality(0d, result);
    result = 0 - 22;
    assertEquality(-22d, result);
    result = 22 - 0;
    assertEquality(22d, result);
    result = 0 * 0;
    assertEquality(0d, result);
    result = 0 * 1.2;
    assertEquality(0d, result);
    result = 1.2 * 0;
    assertEquality(0d, result);
    result = 0 / 1.2;
    assertEquality(0d, result);
    result = 0;
    result = -result;
    assertEquality(0d, result);

    decimal|error d2 = trap 12d / 0d;
    assertEquality(true, d2 is error);
    error err = <error>d2;
    var message = err.detail()["message"];
    string messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'Infinity'", messageString);

    decimal d1 = 0.0;
    d2 = trap d1 / 0d;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'NaN'", messageString);

    d2 = trap -1.0d / d1;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value '-Infinity'", messageString);

    d2 = trap 1.0d / d1;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'Infinity'", messageString);

    d2 = trap 1.0d % d1;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'NaN'", messageString);

    float inf = 1.0 / 0.0;
    d2 = trap <decimal>inf;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'Infinity'", messageString);

    float negInf = -1.0 / 0.0;
    d2 = trap <decimal>negInf;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value '-Infinity'", messageString);

    float nan1 = 0.0 / 0.0;
    d2 = trap <decimal>nan1;
    assertEquality(true, d2 is error);
    err = <error>d2;
    message = err.detail()["message"];
    messageString = message is error ? message.toString() : message.toString();
    assertEquality("{ballerina}UnsupportedDecimalError", err.message());
    assertEquality("decimal operation resulting in unsupported decimal value 'NaN'", messageString);
}

function testDecimalValueWithExponent() {
    decimal a1 = 9.99E+6111;
    decimal a2 = <decimal>9.99E+6111;
    assertEquality(true, a1 == a2);
}

function testDecimalValUsingIntLiterals() {
    decimal result = 10000000000000000123;
    assertEquality("1.0E+19", result.toString());
    result = 9223372036854775808;
    assertEquality("9.223372036854776E+18", result.toString());
    result = 922337203685477580883748874792939797987937145676734655623565776478378749283472394;
    assertEquality("9.223372036854776E+80", result.toString());
}

public type Seconds decimal;
public type SecondsOrNil Seconds?;

function testDecimalTypeRef() {
    Seconds? sec1 = 10;
    assertEquality(sec1 is decimal, true);
    SecondsOrNil sec2 = 11;
    assertEquality(sec2 is decimal, true);
}

function testDecimalValueOverflow() {
    decimal|error d = trap 9.999999999999999999999999999999999E6001d * 1E145d;
    assertEquality(true, d is error);
    error err = <error>d;
    assertEquality("{ballerina}NumberOverflow", err.message());
    assertEquality("decimal range overflow", checkpanic <string|error>err.detail()["message"]);

    d = trap -9.999999999999999999999999999999999E6141d * 1E5d;
    assertEquality(true, d is error);
    err = <error>d;
    assertEquality("{ballerina}NumberOverflow", err.message());
    assertEquality("decimal range overflow", checkpanic <string|error>err.detail()["message"]);

    d = trap 9.999999999999999999999999999999999E6144d + 1E6143d;
    assertEquality(true, d is error);
    err = <error>d;
    assertEquality("{ballerina}NumberOverflow", err.message());
    assertEquality("decimal range overflow", checkpanic <string|error>err.detail()["message"]);

    d = trap -1E6144d - 9.999999999999999999999999999999999E6144d;
    assertEquality(true, d is error);
    err = <error>d;
    assertEquality("{ballerina}NumberOverflow", err.message());
    assertEquality("decimal range overflow", checkpanic <string|error>err.detail()["message"]);

    d = trap 1E614d / 2E-5800d;
    assertEquality(true, d is error);
    err = <error>d;
    assertEquality("{ballerina}NumberOverflow", err.message());
    assertEquality("decimal range overflow", checkpanic <string|error>err.detail()["message"]);
}

type AssertionError distinct error;

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error AssertionError(ASSERTION_ERROR_REASON,
        message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    io:println(testDecimalValue()); // @output 10.1
    io:println(testNegativeDecimalValue()); // @output -10.1
    io:println(testDecimalValueAssignmentByReturnValue()); // @output 10.1
    io:println(testDecimalAddition()); // @output 7.665
    io:println(testDecimalSubtraction()); // @output 1.465
    io:println(testDecimalMultiplication()); // @output 14.1515
    io:println(testDecimalDivision()); // @output 1.472580645161290322580645161290323
    io:println(testDecimalModulus()); // @output 1.465
    io:println(testDecimalNegation()); // @output -4.565

    var comparisons = testDecimalComparisonOperations();
    io:println(comparisons[0]); // @output false
    io:println(comparisons[1]); // @output true
    io:println(comparisons[2]); // @output false
    io:println(comparisons[3]); // @output true
    io:println(comparisons[4]); // @output false
    io:println(comparisons[5]); // @output true

    var parameters = testDecimalParameter(343.342, -21.2);
    io:println(parameters[0]); // @output 343.342
    io:println(parameters[1]); // @output -21.2

    var intLiterals = testIntLiteralAssignment();
    io:println(intLiterals[0]); // @output 12
    io:println(intLiterals[1]); // @output 15

    var positivelySignedLiterals = testPositivelySignedLiteralAssignment();
    io:println(positivelySignedLiterals[0]); // @output 12.23
    io:println(positivelySignedLiterals[1]); // @output 0
    io:println(positivelySignedLiterals[2]); // @output 0

    var decimalArray = testDecimalArrayValue();
    io:println(decimalArray[0]); // @output 1.0
    io:println(decimalArray[1]); // @output 2.0

    var discriminatedDecimalArray = testDecimalArrayValueWithDiscriminator();
    io:println(discriminatedDecimalArray[0]); // @output 1.0
    io:println(discriminatedDecimalArray[1]); // @output 2.0
    io:println(discriminatedDecimalArray[2]); // @output 3.0E+3

    var discriminatedLiterals = testDiscriminatedDecimalLiterals();
    io:println(discriminatedLiterals[0]); // @output 3.22
    io:println(discriminatedLiterals[1]); // @output 0
    io:println(discriminatedLiterals[2]); // @output 3.141592653589793238462643383279502
    io:println(discriminatedLiterals[3]); // @output 3.141592653589793238462643383279503

    var mapValues = testDecimalInferenceInMapContext();
    io:println(mapValues["a"]); // @output 33.3
    io:println(mapValues["b"]); // @output 33.3
    io:println(mapValues["c"]); // @output 0.1
    io:println(mapValues["d"]); // @output 1
    io:println(mapValues["e"]); // @output 10000000000000000000000.123

    var binaryExpressions = decimalInferenceInLiterals();
    io:println(binaryExpressions[0]); // @output 0.5
    io:println(binaryExpressions[1]); // @output 3.0
    io:println(binaryExpressions[2]); // @output -1.0
    io:println(binaryExpressions[3]); // @output 2.00
    io:println(binaryExpressions[4]); // @output 10000.5051

    io:println(decimalArrayLoad()); // @output 2.0

    testDecimalFillerValue();
    testDecimalValueWithExponent();
    testDecimalZeroOperations();
    testDecimalValueOverflow();
    testDecimalValUsingIntLiterals();
    testDecimalTypeRef();
}
