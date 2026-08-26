import ballerina/io;

function testVariableShadowingBasic() returns int {
    int a = 5;
    int b = 4;
    if (a > 3) {
        b = a + b;
    }
    return b;
}

function testVariableShadowingInCurrentScope1(int a) returns int {
    int b = 4;
    if (a > 3) {
        b = a + b;
    }
    return b;
}

function testVariableShadowingInCurrentScope2(int a) returns function (float) returns string {
    int b = 4;
    if (a < 10) {
        b = a + b;
    }
    var foo = function (float f) returns string {
        if (a > 8) {
            b = a + <int> f + b;
        }
        return "K" + b.toString();
    };
    return foo;
}

function test1() returns int {
    return testVariableShadowingBasic();
}

function test2() returns int {
    return testVariableShadowingInCurrentScope1(4);
}

function test3() returns string {
    var foo = testVariableShadowingInCurrentScope2(9);
    return foo(3.4);
}

int a = 10;

function testScopeOfBlock() {
    {
        int a = 5;
    }
    assertEquality(10, a);
}

function testStmtInBlock() {
    int a = 2;
    int b = 5;
    {
        while (a < 4) {
            a += 1;
            if (a == 3) {
                b = 8;
            }
        }
    }
    assertEquality(8, b);
}

function returnStmtLocation1InBlock() returns int {
    int a = 2;
    {
        a = 10;
    }
    return a;
}

function returnStmtLocation2InBlock() returns int {
    int a = 2;
    {
        a = 10;
        return a;
    }
}

function testReturnStmtLocationInBlock() {
    assertEquality(10, returnStmtLocation1InBlock());
    assertEquality(10, returnStmtLocation2InBlock());
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(int expected, int actual) {
    if (expected == actual) {
        return;
    }
    panic error(ASSERTION_ERROR_REASON,
        message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    io:println(test1());
    // @output 9
    io:println(test2());
    // @output 8
    io:println(test3());
    // @output K25
    testScopeOfBlock();
    testStmtInBlock();
    testReturnStmtLocationInBlock();
}
