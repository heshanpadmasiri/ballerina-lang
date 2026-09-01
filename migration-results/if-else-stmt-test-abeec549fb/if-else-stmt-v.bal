import ballerina/io;

function testIfStmt(int aa, int b, int c) returns [int, int] {
    int x;
    x = 10;

    int a1;
    if (aa == b) {
        a1 = 100;
    } else if (aa == b + 1) {
        a1 = 200;
    } else if (aa == b + 2) {
        a1 = 300;
    } else {
        a1 = 400;
    }

    int b1 = c;
    return [a1 + x, b1 + 1];
}

function testIfStmtWithoutParentheses(int aa, int b, int c) returns [int, int] {
    int x;
    x = 10;

    int a1;
    if aa == b {
        a1 = 100;
    } else if aa == (b + 1) {
        a1 = 200;
    } else if (((aa == (b + 2)))) {
        a1 = 300;
    } else {
        a1 = 400;
    }

    int b1 = c;
    return [a1 + x, b1 + 1];
}

function testAgeGroup(int age) returns string {
    string avgGroup;
    if age > 18 {
        avgGroup = "elder";
    } else {
        avgGroup = "minor";
    }
    return avgGroup;
}

function ifElseScope(int number) returns int {
    int i = number;
    if i == 1 {
        i = -10;
        int j = 2;
        if j == 2 {
            int k = 200;
            i = k;
        } else {
            int k = -1;
        }
    } else if i == 2 {
        int j = 400;
        i = j;
    } else {
        i = 100;
        int j = 500;
        i = j;
    }
    return i;
}

function nestedIfElseScope(int number1, int number2) returns int {
    int i = number1;
    if i == 1 {
        int j = number2;
        if j == 1 {
            int k = 100;
            i = k;
        } else {
            int k = 200;
            i = k;
        }
    } else if i == 2 {
        int j = number2;
        i = j;
        if j == 2 {
            int k = 300;
            i = k;
        } else {
            int k = 400;
            i = k;
        }
    } else {
        i = 100;
        int j = number2;
        if j == 3 {
            int k = 500;
            i = k;
        } else {
            int k = 600;
            i = k;
        }
    }
    return i;
}

final int a = 6;

function testConditionScope(int b) returns int {
    int output = 0;
    if a > b {
        int c = 1;
        output = 10;
    } else if a == b {
        int c = 2;
        output = 20;
    }
    return output;
}

const ONE = 1;

function testTypeNarrowing(string? s) returns string {
    int|boolean a = 5;
    if a == ONE {
        ONE b = a;
    } else {
        int|boolean c = a;
    }

    if a == 5 {
        5 b = a;
    } else {
        int|boolean c = a;
    }

    if () == s {
        () t = s;
    } else {
        string u = s;
    }

    if s != () {
        string u = s;
    } else {
        () t = s;
    }

    if s == () {
        return "";
    }
    return s;
}

function testTypeNarrowingWithLambda() {
    string? optionalName = "Ballerina";
    var lambdaFunc = function (int|string id) returns ONE {
        int? optionalAge = 20;
        if optionalAge == () {
            () d = optionalAge;
        }

        if id != ONE {
            return 1;
        }
        return id;
    };
}

function testResetTypeNarrowingForCompoundAssignment() {
    int a = 5;
    if a == 5 {
        a += 1;
    }
}

function testResetTypeNarrowing() {
    int a = 10;
    if a > 0 {
        return;
    }
    error? errors = error("");
    if errors is error {
        return;
    }
    if a is int {
        errors = error("");
    }
}

function testResetTypeNarrowingWithBlockStmt() {
    int a = 10;
    if a > 0 {
        return;
    }
    {
        error? errors = error("");
        if errors is error {
            return;
        }
        if a is int {
            errors = error("");
        }
    }
}

function testSymbolsInIfElse1() {
    int? x = ();
    if x is () {
        int a = 3;
        int b = 12;
        b += 1;
        if b == 13 {
            a += 1;
            b = 1;
        }
    } else {
        int a = 3;
        int b = 12;
    }
}

function testSymbolsInIfElse2() {
    int? x = ();
    if x is () {
        int a = 2;
        int b = 6;
        b += 1;
        if b == 7 {
            a += 1;
            b = 1;
            if a == 3 {
                a += 2;
                b += 2;
            }
        }
        int c = 10;
        int d = 20;
        if c == 7 {
            a += 1;
            b = 1;
            if a == 6 {
                a += 2;
                b += 2;
            }
        }
    } else {
        int a = 5;
        int b = 12;
        if a == 4 {
            int c = 2;
            int d = 3;
        } else {
            int c = 2;
            int d = 3;
        }
    }
}

function testSymbolsInIfElse3() {
    int|string? x = ();
    if x is () {
        int a = 12;
        int b = 12;
        b += 1;
        if b == 13 {
            a += 1;
            b = 1;
        }
        if a == 2 {
            a += 2;
            b += 2;
        }
    } else if x is string {
        int a = 2022;
        int b = 12;
    } else {
        int a = 10;
        int b = 12;
    }
}

function testSymbolsInIfElse4() {
    int|string? x = ();
    if x is () {
        int? a = 12;
        int? b = 12;
        if b is int {
            b += 1;
            int? c = 1;
            if c is int {
                int|string? d = ();
                if d is int {
                    c = 2;
                    a = 2;
                }
                if d is string {
                    d = 2;
                    b = 3;
                }
            } else {
                int d = 2;
                a = 2;
                b = 3;
                c = 10;
            }
        }
        if a is int {
            if a == 0 {
                int d = 12;
            }
            int c = 10;
        }
    } else {
        int a = 12;
        int b = 10;
        if a == 10 {
            int c = 10;
            if c == 10 {
                int d = 12;
            }
        }
    }
}

public function main() {
    io:println(testIfStmt(10, 10, 20)[0]); // @output 110
    io:println(testIfStmt(10, 10, 20)[1]); // @output 21
    io:println(testIfStmt(11, 10, 20)[0]); // @output 210
    io:println(testIfStmt(11, 10, 20)[1]); // @output 21
    io:println(testIfStmt(12, 10, 20)[0]); // @output 310
    io:println(testIfStmt(12, 10, 20)[1]); // @output 21
    io:println(testIfStmt(10, 100, 20)[0]); // @output 410
    io:println(testIfStmt(10, 100, 20)[1]); // @output 21
    io:println(testIfStmtWithoutParentheses(10, 100, 20)[0]); // @output 410
    io:println(testIfStmtWithoutParentheses(10, 100, 20)[1]); // @output 21
    io:println(testAgeGroup(21)); // @output elder
    io:println(testAgeGroup(16)); // @output minor
    io:println(ifElseScope(1)); // @output 200
    io:println(ifElseScope(2)); // @output 400
    io:println(ifElseScope(16)); // @output 500
    io:println(nestedIfElseScope(1, 1)); // @output 100
    io:println(nestedIfElseScope(1, 2)); // @output 200
    io:println(nestedIfElseScope(2, 2)); // @output 300
    io:println(nestedIfElseScope(2, 3)); // @output 400
    io:println(nestedIfElseScope(3, 3)); // @output 500
    io:println(nestedIfElseScope(3, 4)); // @output 600
    io:println(testConditionScope(3)); // @output 10
    io:println(testConditionScope(6)); // @output 20
    testTypeNarrowingWithLambda();
    testResetTypeNarrowingForCompoundAssignment();
    testResetTypeNarrowing();
    testResetTypeNarrowingWithBlockStmt();
    io:println(testTypeNarrowing("ballerina")); // @output ballerina
    testSymbolsInIfElse1();
    testSymbolsInIfElse2();
    testSymbolsInIfElse3();
    testSymbolsInIfElse4();
}
