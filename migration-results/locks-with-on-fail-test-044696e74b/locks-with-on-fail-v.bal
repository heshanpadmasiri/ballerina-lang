import ballerina/io;

int lockWithinLockInt1 = 0;
string lockWithinLockString1 = "";

public function main() {
    [int, string] failed = failLockWithinLock();
    io:println(failed[0]); // @output 100
    io:println(failed[1]); // @output Error caught
    [int, string] checked = checkLockWithinLock();
    io:println(checked[0]); // @output 100
    io:println(checked[1]); // @output Error caught
    onFailLockWithinLockWithoutVariable();
    testSimpleOnFailWithErrorBP();
    testSimpleOnFailWithErrorBPWithVar();
    testOnFailWithErrorBPHavingUserDefinedTypeWithError();
    testOnFailWithErrorBPHavingUserDefinedTypeWithVar();
    testOnFailWithErrorBPHavingUserDefinedType();
    testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail1();
    testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail2();
    testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail3();
    testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail4();
    testOnFailWithErrorBPHavingAnonDetailRecord();
    testOnFailWithErrorBPHavingAnonDetailRecordWithVar();
    testOnFailWithErrorBPHavingAnonDetailRecordWithUnionType();
    testOnFailWithErrorBPWithErrorArgsHavingBP1();
    testOnFailWithErrorBPWithErrorArgsHavingBP2();
    testOnFailWithErrorBPWithErrorArgsHavingBP3();
    testOnFailWithErrorBPWithErrorArgsHavingBP4();
    testOnFailWithErrorBPWithErrorArgsHavingBP5();
    testMultiLevelOnFailWithErrorBP();
    testMultiLevelOnFailWithoutErrorInOneLevel();
}

function failLockWithinLock() returns [int, string] {
    lock {
        lockWithinLockInt1 = 50;
        lockWithinLockString1 = "sample value";
        lock {
            lockWithinLockString1 = "second sample value";
            lockWithinLockInt1 = 99;
            lock { lockWithinLockInt1 = 90; }
            error err = error("custom error", message = "error value");
            fail err;
        }
    } on fail error e {
        lockWithinLockInt1 = 100;
        lockWithinLockString1 = "Error caught";
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function checkLockWithinLock() returns [int, string] {
    lock {
        lockWithinLockInt1 = 50;
        lockWithinLockString1 = "sample value";
        lock {
            lockWithinLockString1 = "second sample value";
            lockWithinLockInt1 = 99;
            lock { lockWithinLockInt1 = 90; }
            lockWithinLockInt1 = check getError();
        }
        lockWithinLockInt1 = 77;
    } on fail error e {
        lockWithinLockInt1 = 100;
        lockWithinLockString1 = "Error caught";
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function onFailLockWithinLockWithoutVariable() {
    lock {
        lockWithinLockInt1 = 50;
        lockWithinLockString1 = "sample value";
        lock {
            lockWithinLockString1 = "second sample value";
            lockWithinLockInt1 = 99;
            lock { lockWithinLockInt1 = 90; }
            error err = error("custom error", message = "error value");
            fail err;
        }
    } on fail {
        lockWithinLockInt1 = 100;
        lockWithinLockString1 = "Error handled";
    }
    assertEquality(100, lockWithinLockInt1);
    assertEquality("Error handled", lockWithinLockString1);
}

function getError() returns int|error => error("Custom Error");

type SampleErrorData record {| int code; string reason; |};
type SampleError error<SampleErrorData>;

string testMessage = "";
int testErrorCode = 0;
string testErrorReason = "";

function testSimpleOnFailWithErrorBP() {
    lock { lockWithinLockInt1 = 99; fail error("error!");
    } on fail error error(msg) { testMessage = msg; }
    assertEquality(testMessage, "error!");
}

function testSimpleOnFailWithErrorBPWithVar() {
    lock { lockWithinLockInt1 = 99; fail error("error!");
    } on fail var error(msg) { testMessage = msg; }
    assertEquality(testMessage, "error!");
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithError() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail error error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertBasicErrorDetails();
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithVar() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail var error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertBasicErrorDetails();
}

function testOnFailWithErrorBPHavingUserDefinedType() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail SampleError error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertBasicErrorDetails();
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail1() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail error<SampleErrorData> error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertBasicErrorDetails();
}

function assertBasicErrorDetails() {
    assertEquality(testMessage, "error!");
    assertEquality(testErrorCode, 20);
    assertEquality(testErrorReason, "deadlock condition");
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail2() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail error<record {int code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquality(testErrorCode, 20); assertEquality(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail3() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail error<record {int code;}> error(code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason;
    }
    assertEquality(testErrorCode, 20); assertEquality(testErrorReason, "deadlock condition");
    assertEquality(testErrorCode is int, true); assertEquality(testErrorReason is string, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail4() {
    lock { lockWithinLockInt1 = 99; fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail error<record {int|string code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquality(testErrorCode, 20); assertEquality(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingAnonDetailRecord() {
    lock {
        lockWithinLockInt1 = 99;
        error<record {int code;}> errVar = error("error", code = 34); fail errVar;
    } on fail error<record {int code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquality(testErrorCode, 34); assertEquality(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingAnonDetailRecordWithVar() {
    lock {
        lockWithinLockInt1 = 99;
        error<record {int code;}> errVar = error("error", code = 34); fail errVar;
    } on fail var error(msg, code = errCode) { testErrorCode = errCode; testErrorReason = msg; }
    assertEquality(testErrorCode, 34); assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true); assertEquality(testErrorReason, "error");
}

function testOnFailWithErrorBPHavingAnonDetailRecordWithUnionType() {
    lock {
        lockWithinLockInt1 = 99;
        error<record {int code;}> errVar = error("error", code = 34); fail errVar;
    } on fail error<record {int|string code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquality(testErrorCode, 34); assertEquality(testErrorCode is int, true);
}

type SampleComplexErrorData record {|
    error cause;
    int code;
    int[2] pos;
    record {string moreInfo;} infoDetails;
|};
type SampleComplexError error<SampleComplexErrorData>;
int testErrorPosRow = 0;
int testErrorPosCol = 0;
string testErrorMoreInfo = "";

function complexError() returns SampleComplexError => error SampleComplexError(
    "Transaction Failure", cause = error("Database Error"), code = 20, pos = [30, 45],
    infoDetails = {moreInfo: "deadlock condition"});

function assertComplexErrorDetails() {
    assertEquality(testErrorPosRow, 30); assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol, 45); assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo, "deadlock condition"); assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode, 20); assertEquality(testErrorCode is int, true);
    assertEquality(testMessage, "Database Error"); assertEquality(testMessage is string, true);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP1() {
    string causeMsg;
    lock { lockWithinLockInt1 = 99; fail complexError();
    } on fail SampleComplexError error(_, cause = errCause, code = errCode, pos = errorPos, infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = errorPos[0]; testErrorPosCol = errorPos[1];
        testErrorMoreInfo = errInfo.moreInfo; causeMsg = errCause.message();
    }
    assertEquality(testErrorPosRow, 30); assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol, 45); assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo, "deadlock condition"); assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode, 20); assertEquality(testErrorCode is int, true);
    assertEquality(causeMsg, "Database Error"); assertEquality(causeMsg is string, true);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP2() {
    lock { lockWithinLockInt1 = 99; fail complexError();
    } on fail SampleComplexError error(message, cause = error(msg), code = errCode, pos = errorPos, infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = errorPos[0]; testErrorPosCol = errorPos[1];
        testErrorMoreInfo = errInfo.moreInfo; testMessage = msg;
    }
    assertComplexErrorDetails();
}

function testOnFailWithErrorBPWithErrorArgsHavingBP3() {
    lock { lockWithinLockInt1 = 99; fail complexError();
    } on fail SampleComplexError error(message, cause = error(msg), code = errCode, pos = [row, col], infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo.moreInfo; testMessage = msg;
    }
    assertComplexErrorDetails();
}

function testOnFailWithErrorBPWithErrorArgsHavingBP4() {
    lock { lockWithinLockInt1 = 99; fail complexError();
    } on fail SampleComplexError error(_, cause = error(msg), code = errCode, pos = [row, col], infoDetails = {moreInfo: errInfo}) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo; testMessage = msg;
    }
    assertComplexErrorDetails();
}

function testOnFailWithErrorBPWithErrorArgsHavingBP5() {
    lock { lockWithinLockInt1 = 99; fail complexError();
    } on fail var error(_, cause = error(msg), code = errCode, pos = [row, col], infoDetails = {moreInfo: errInfo}) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo; testMessage = msg;
    }
    assertComplexErrorDetails();
}

function testMultiLevelOnFailWithErrorBP() {
    int i = 2;
    string str = "";
    lock {
        lock {
            str += " -> Iteration " + i.toString() + ", ";
            fail error SampleError("error!", code = 20, reason = "deadlock condition");
        } on fail var error(msg1, code = errCode1, reason = errReason1) {
            str += " -> On Fail #" + i.toString(); testMessage = msg1;
            testErrorCode = errCode1; testErrorReason = errReason1;
        }
        i += 1;
        fail error SampleError("error!", code = 20, reason = "deadlock condition");
    } on fail SampleError error(msg2, code = errCode2, reason = errReason2) {
        str += " -> On Fail Final";
    }
    assertEquality(" -> Iteration 2,  -> On Fail #2 -> On Fail Final", str);
    assertEquality(testErrorCode, 20); assertEquality(testErrorReason, "deadlock condition");
    assertEquality(testMessage, "error!");
}

function testMultiLevelOnFailWithoutErrorInOneLevel() {
    int i = 2;
    string str = "";
    lock {
        lock {
            str += " -> Iteration " + i.toString() + ", ";
            fail error SampleError("error!", code = 20, reason = "deadlock condition");
        } on fail var error(msg1, code = errCode1, reason = errReason1) {
            str += " -> On Fail #" + i.toString(); testMessage = msg1;
            testErrorCode = errCode1; testErrorReason = errReason1;
        }
        i += 1;
    } on fail SampleError error(msg2, code = errCode2, reason = errReason2) {
        str += " -> On Fail Final";
    }
    assertEquality(" -> Iteration 2,  -> On Fail #2", str);
    assertEquality(testErrorCode, 20); assertEquality(testErrorReason, "deadlock condition");
    assertEquality(testMessage, "error!");
}

function assertEquality(anydata expected, anydata actual) {
    if expected != actual {
        panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
    }
}
