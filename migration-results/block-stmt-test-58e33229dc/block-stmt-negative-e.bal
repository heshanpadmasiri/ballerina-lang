function testUnreachableStmtInIfFunction1() {
    int a = 2;
    if (a > 0) {
        string _ = "hello if";
    } else {
        string _ = "hello else";
    }
    return;
    if (a > 10) { // @error unreachable code
        int _ = 10;
    }
    int _ = 9;
}

function testUnreachableStmtInIfFunction2() {
    int a = 2;
    int b; // @warning unused variable 'b'
    if (a > 0) {
        string _ = "hello if";
    } else {
        string _ = "hello else";
    }
    b = 7;
    return;
    int _ = 9; // @error unreachable code
}

function testUnreachableStmtInIfBlock() returns int {
    int a = 2;
    if (a > 0) {
        string _ = "hello if";
        return a;
        int _ = 10; // @error unreachable code
    } else {
        string _ = "hello else";
    }
    return a;
}

function testUnreachableStmtInWhileBlock() {
    int a = 2;
    while (a < 4) {
        a += 1;
        if (a == 3) {
            return;
            string _ = "hello"; // @error unreachable code
        }
    }
}

function testCommentAfterReturnStmt() returns int {
    int a = 2;
    if (a > 0) {
        string _ = "hello if";
        return 1;
    } else {
        string _ = "hello else";
    }
    return a;
    int x = 10; // @error unreachable code
    return x;
}

function testUnreachableTrapExpression() returns string {
    string a = "";
    if (2 > 1) {
        return "one";
    } else {
        return "two";
    }
    var newVar = trap "abc"; // @error unreachable code
    if newVar is error {
        return "catch1";
    }
    return a;
}

function testUnreachableNext() returns string {
    while true {
        return "unreachable continue";
        continue; // @error unreachable code
    }
    return "done"; // @error unreachable code
}

function testUnreachableBreak() returns string {
    if true {
        return "unreachable break";
        break; // @error break cannot be used outside of a loop // @error unreachable code
    }
    return "done";
}

public type testError record {|
    string message;
    error cause;
    string code?;
|};

function testUnreachableThrow(int value) returns string {
    if (value > 10) {
        testError tError = {message: "error", cause: error("errorMsg", code = "test")};
        return "unreachable throw";
        panic tError.cause;
    }
    return "done";
}

function testRedeclareFunctionArgument(int value) returns string {
    if (value > 10) {
        testError tError = {message: "error", cause: error("errorMsg", code = "test")};
        return "unreachable throw";
        panic tError.cause;
    }
    return "done";
}

function testUnreachableStmtInBlock() {
    int a = 2;
    {
        string _ = "hello Block";
        return;
        int _ = 9; // @error unreachable code
    }
    if (a > 10) {
        int _ = 10;
    }
}

function testUninitializedVariableAssignInBlock1() {
    int a;
    {
        int _ = a; // @error variable 'a' is not initialized
    }
}

function testUninitializedVariableAssignInBlock2() {
    int a;
    {
        a += 2; // @error variable 'a' is not initialized
    }
}
