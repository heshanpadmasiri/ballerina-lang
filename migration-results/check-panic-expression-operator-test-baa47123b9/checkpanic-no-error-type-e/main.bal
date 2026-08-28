function testCheckingExprWithNoErrorType() {
    testCheckingExprWithNoErrorType1();
    testCheckingExprWithNoErrorType2();
}

function testCheckingExprWithNoErrorType1() {
    if checkpanic true { // @error
        return;
    }

    panic error("You are not supposed to reach this line");
}

type TRUE true;

type FALSE false;

function testCheckingExprWithNoErrorType2() {
    boolean b1 = true;
    error err = error("Error!");
    error err1 = checkpanic b1 ? err : err; // @error
    assertEquality(err1.message(), "Error!");

    true b2 = true;
    error err2 = checkpanic b2 ? err : err; // @error
    assertEquality(err2.message(), "Error!");

    boolean|true b3 = true;
    error err3 = checkpanic b3 ? err : err; // @error
    assertEquality(err3.message(), "Error!");

    TRUE|FALSE b4 = true;
    error err4 = checkpanic b4 ? err : err; // @error
    assertEquality(err4.message(), "Error!");
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(anydata actual, anydata expected) {
    if (actual == expected) {
        return;
    }

    panic error(ASSERTION_ERROR_REASON,
                message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}
