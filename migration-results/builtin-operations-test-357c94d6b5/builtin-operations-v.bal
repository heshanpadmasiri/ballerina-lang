import ballerina/io;

function testIsNaN() returns [boolean, boolean, boolean] {
    float f = 0.0 / 0.0;
    boolean isNaN = f.isNaN();
    return [isNaN, f.isInfinite(), f.isFinite()];
}

function testIsInfinite() returns [boolean, boolean, boolean] {
    float f = 1.0 / 0.0;
    boolean isInfinite = f.isInfinite();
    return [isInfinite, f.isFinite(), f.isNaN()];
}

function testIsFinite() returns [boolean, boolean, boolean] {
    float f = 6.0 / 2.5;
    boolean isFinite = f.isFinite();
    return [isFinite, f.isInfinite(), f.isNaN()];
}

function testWithCalc() returns [boolean, boolean, boolean] {
    float f = 6.0 / 2.0;
    f += 20.0;
    f /= 0.0;
    boolean isInfinite = f.isInfinite();
    return [isInfinite, f.isFinite(), f.isNaN()];
}

function testModWithDivisorAsZero() returns [boolean, boolean, boolean] {
    float a = 10.0 % 0.0;
    return [a.isNaN(), a.isInfinite(), a.isFinite()];
}

function testModZeroByZero() returns [boolean, boolean, boolean] {
    float a = 0.0 % 0.0;
    return [a.isNaN(), a.isInfinite(), a.isFinite()];
}

function testModWithDivisorAsFinite() returns [boolean, boolean, boolean] {
    float a = 10.0 % 3.0;
    return [a.isNaN(), a.isInfinite(), a.isFinite()];
}

public function main() {
    [boolean, boolean, boolean] isNaN = testIsNaN();
    io:println(isNaN[0]); // @output true
    io:println(isNaN[1]); // @output false
    io:println(isNaN[2]); // @output false

    [boolean, boolean, boolean] isInfinite = testIsInfinite();
    io:println(isInfinite[0]); // @output true
    io:println(isInfinite[1]); // @output false
    io:println(isInfinite[2]); // @output false

    [boolean, boolean, boolean] isFinite = testIsFinite();
    io:println(isFinite[0]); // @output true
    io:println(isFinite[1]); // @output false
    io:println(isFinite[2]); // @output false

    [boolean, boolean, boolean] withCalc = testWithCalc();
    io:println(withCalc[0]); // @output true
    io:println(withCalc[1]); // @output false
    io:println(withCalc[2]); // @output false

    [boolean, boolean, boolean] modWithDivisorAsZero = testModWithDivisorAsZero();
    io:println(modWithDivisorAsZero[0]); // @output true
    io:println(modWithDivisorAsZero[1]); // @output false
    io:println(modWithDivisorAsZero[2]); // @output false

    [boolean, boolean, boolean] modZeroByZero = testModZeroByZero();
    io:println(modZeroByZero[0]); // @output true
    io:println(modZeroByZero[1]); // @output false
    io:println(modZeroByZero[2]); // @output false

    [boolean, boolean, boolean] modWithDivisorAsFinite = testModWithDivisorAsFinite();
    io:println(modWithDivisorAsFinite[0]); // @output false
    io:println(modWithDivisorAsFinite[1]); // @output false
    io:println(modWithDivisorAsFinite[2]); // @output true
}
