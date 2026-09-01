function invalidIfElse(string[] args) {
    if 5 { // @error
        // nothing
    }

    if false {
        int a;
    }
}

function foo() returns string {
    if true {
        return "returning from if";
    } else {
        return "returning from else";
    }
}

function testIfStmtWithIncompatibleType1() returns boolean {
    if false {
        return false;
    } else if "foo" { // @error
        return true;
    }
}

function testIfStmtWithIncompatibleType2() {
    if "foo" { // @error
        int a = 5;
    }
    return;
}

function testIfStmtWithIncompatibleType3() {
    if "foo" { // @error
        int a = 5;
    } else if 4 { // @error
        int b = 4;
    }

    if [5, "baz"] { // @error
        // do nothing
    }
    return;
}

function testResetTypeNarrowingForCompoundAssignmentNegative() {
    int|string a = 5;
    if a == 5 {
        5 b = a;
        a += 1;
        int c = a + 3; // @error
    }

    if a is int {
        a += 5;
        int b = a; // @error
        a = "Hello";
        string c = a; // @error
    }
}
