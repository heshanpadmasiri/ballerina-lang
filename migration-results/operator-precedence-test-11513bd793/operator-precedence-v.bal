import ballerina/io;

function addSubPrecedence(int a, int b, int c) returns int {
    return a - b + c;
}

function addSubMultPrecedence(int a, int b, int c, int d, int e, int f) returns int {
    return a * b - c + d * e - f;
}

function multDivisionPrecedence(int a, int b, int c, int d, int e, int f) returns int {
    return a * b / c * d * e / f;
}

function addMultPrecedence(int a, int b, int c, int d, int e, int f) returns int {
    return a * b * c + d * e + f;
}

function addDivisionPrecedence(int a, int b, int c, int d, int e, int f) returns int {
    return a / b / c + d / e + f;
}

function intAdditionAndSubtractionPrecedence(int a, int b, int c, int d) returns int {
    return a - b + c - d;
}

function intMultiplicationPrecedence(int a, int b, int c, int d) returns int {
    int x = (a + b) * (c * d) + a * b;
    int y = (a + b) * (c * d) - a * b;
    int z = a + b * c * d - a * b;
    return x + y - z;
}

function intDivisionPrecedence(int a, int b, int c, int d) returns int {
    int x = (a + b) / (c + d) + a / b;
    int y = (a + b) / (c - d) - a / b;
    int z = a + b / c - d - a / b;
    return x - y + z;
}

function intMultiplicationAndDivisionPrecedence(int a, int b, int c, int d) returns int {
    int x = (a + b) * (c + d) + a / b;
    int y = (a + b) / (c - d) - a * b;
    int z = a + b / c - d + a * b;
    return x + y + z;
}

function comparatorPrecedence(int a, int b, int c, int d, int e, int f) returns boolean {
    return (a > b) && (c < d) || (e > f);
}

public function main() {
    io:println(addSubPrecedence(10, 5, 1)); // @output 6
    io:println(addSubPrecedence(-6, 8, 6)); // @output -8
    io:println(addSubPrecedence(-3, -7, 5)); // @output 9
    io:println(addSubPrecedence(-9, -10, -4)); // @output -3
    io:println(addSubPrecedence(2, -13, 11)); // @output 26
    io:println(addSubPrecedence(14, 6, -17)); // @output -9
    io:println(addSubPrecedence(0, 2, 5)); // @output 3

    io:println(addSubMultPrecedence(10, 5, 1, 20, 8, 3)); // @output 206
    io:println(addSubMultPrecedence(-6, 9, 12, 35, 10, 78)); // @output 206
    io:println(addSubMultPrecedence(5, -39, 54, 65, 13, 10)); // @output 586
    io:println(addSubMultPrecedence(25, 3, -6, 9, 7, 10)); // @output 134
    io:println(addSubMultPrecedence(7, 4, 6, -3, 8, 40)); // @output -42
    io:println(addSubMultPrecedence(13, 12, 74, 65, -10, 37)); // @output -605
    io:println(addSubMultPrecedence(0, 12, 74, 65, 10, -37)); // @output 613
    io:println(addSubMultPrecedence(-4, 0, -14, 0, -10, -63)); // @output 77

    io:println(multDivisionPrecedence(10, 5, 7, 0, 8, 3)); // @output 0
    io:println(multDivisionPrecedence(18, -3, 6, 74, 4, -40)); // @output 66
    io:println(multDivisionPrecedence(0, 9, -7, 41, 9, -40)); // @output 0
    io:println(multDivisionPrecedence(0, -9, -7, -41, -9, -40)); // @output 0
    io:println(multDivisionPrecedence(80, -1, 2, 3, -4, 5)); // @output 96
    io:println(multDivisionPrecedence(2, -13, 28, -36, 74, -9)); // @output 0
    io:println(multDivisionPrecedence(54, 96, 45, -36, 74, -9)); // @output 34040
    io:println(multDivisionPrecedence(93, 81, 3, 74, 0, -9)); // @output 0

    io:println(addMultPrecedence(5, 6, 7, 8, 9, 10)); // @output 292
    io:println(addMultPrecedence(64, -79, 14, -36, 39, -40)); // @output -72228
    io:println(addMultPrecedence(-15, 86, -67, 38, -79, 20)); // @output 83448
    io:println(addMultPrecedence(9, 8, 0, 6, -9, 3)); // @output -51
    io:println(addMultPrecedence(0, 0, 0, 0, 0, 0)); // @output 0

    io:println(addDivisionPrecedence(5, 6, 7, 8, 9, 10)); // @output 10
    io:println(addDivisionPrecedence(64, -79, 14, -36, 39, -40)); // @output -40
    io:println(addDivisionPrecedence(-15, 86, -67, 38, -79, 20)); // @output 20

    io:println(comparatorPrecedence(10, 20, 30, 40, 50, 60)); // @output false
    io:println(comparatorPrecedence(0, 5, 5, 9, 34, 80)); // @output false
    io:println(comparatorPrecedence(0, 5, 5, 9, 34, 6)); // @output true

    io:println(intAdditionAndSubtractionPrecedence(10, 20, 30, 40)); // @output -20
    io:println(intMultiplicationPrecedence(10, 20, 30, 40)); // @output 48190
    io:println(intDivisionPrecedence(10, 20, 30, 40)); // @output -27
    io:println(intMultiplicationAndDivisionPrecedence(10, 20, 30, 40)); // @output 2067
}
