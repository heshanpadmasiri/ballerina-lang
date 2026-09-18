import ballerina/io;

public function main() {
    testStaticMatchPatternsWithFailStmt();
    testStaticMatchPatternsWithOnFailStmtWithoutVariable();
    testStaticMatchPatternsWithCheckExpr();
    testNestedMatchPatternsWithFail();
    testNestedMatchPatternsWithCheck();
    testVarInMatchPatternWithinOnfail();
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
    io:println("ok"); // @output ok
}

function testStaticMatchPatternsWithFailStmt() {
    assertEquals("12", fooWithFail(12));
    assertEquals("Hello", fooWithFail("Hello"));
    assertEquals("true", fooWithFail(true));
    assertEquals("15", fooWithFail(15));
    assertEquals("error(\"custom error\",message=\"error value\")", fooWithFail("fail"));
    assertEquals("false", fooWithFail(false));
    assertEquals("Default", fooWithFail("NothingToMatch"));
}

function testStaticMatchPatternsWithOnFailStmtWithoutVariable() {
    assertEquals("12", onFailWithoutVariable(12));
    assertEquals("Failed!", onFailWithoutVariable("fail"));
    assertEquals("Default", onFailWithoutVariable("NothingToMatch"));
}

function testStaticMatchPatternsWithCheckExpr() {
    assertEquals("12", fooWithCheck(12));
    assertEquals("Hello", fooWithCheck("Hello"));
    assertEquals("true", fooWithCheck(true));
    assertEquals("15", fooWithCheck(15));
    assertEquals("error(\"Check Error\")", fooWithCheck("check"));
    assertEquals("false", fooWithCheck(false));
    assertEquals("Default", fooWithCheck("NothingToMatch"));
}

function onFailWithoutVariable(string|int|boolean a) returns string {
    match a {
        12 => { return "12"; }
        "fail" => {
            error err = error("custom error", message = "error value");
            fail err;
        }
    } on fail {
        return "Failed!";
    }
    return "Default";
}

function fooWithFail(string|int|boolean a) returns string {
    match a {
        12 => { return "12"; }
        "Hello" => { return "Hello"; }
        15 => { return "15"; }
        true => { return "true"; }
        false => { return "false"; }
        "fail" => {
            error err = error("custom error", message = "error value");
            fail err;
        }
    } on fail error e {
        return e.toString();
    }
    return "Default";
}

function fooWithCheck(string|int|boolean a) returns string {
    match a {
        12 => { return "12"; }
        "Hello" => { return "Hello"; }
        15 => { return "15"; }
        true => { return "true"; }
        false => { return "false"; }
        "check" => {
            string str = check getCheckError();
            return str;
        }
    } on fail error e {
        return e.toString();
    }
    return "Default";
}

function getError() returns string|error {
    return error("Custom Error");
}

function getCheckError() returns string|error {
    return error("Check Error");
}

function testNestedMatchPatternsWithFail() {
    assertEquals("12", barWithFail(12, "Hello"));
    assertEquals("15 & HelloWorld", barWithFail(15, "HelloWorld"));
    assertEquals("error(\"custom error\",message=\"error value\")", barWithFail("fail", "fail"));
    assertEquals("Default", barWithFail("NothingToMatch", false));
    assertEquals("15 & 34", barWithFail(15, 34));
    assertEquals("true", barWithFail(true, false));
}

function barWithFail(string|int|boolean a, string|int|boolean b) returns string {
    match a {
        12 => { return "12"; }
        "Hello" => { return "Hello"; }
        15 => {
            match b {
                34 => { return "15 & 34"; }
                "HelloWorld" => { return "15 & HelloWorld"; }
            }
        }
        "fail" => {
            match b {
                "fail" => {
                    error err = error("custom error", message = "error value");
                    fail err;
                }
                "HelloWorld" => { return "HelloAgain & HelloWorld"; }
            }
        }
        true => { return "true"; }
    } on fail error e {
        return e.toString();
    }
    return "Default";
}

function testNestedMatchPatternsWithCheck() {
    assertEquals("12", barWithCheck(12, "Hello"));
    assertEquals("15 & HelloWorld", barWithCheck(15, "HelloWorld"));
    assertEquals("error(\"Check Error\")", barWithCheck("check", "check"));
    assertEquals("Default", barWithCheck("NothingToMatch", false));
    assertEquals("15 & 34", barWithCheck(15, 34));
    assertEquals("true", barWithCheck(true, false));
}

function barWithCheck(string|int|boolean a, string|int|boolean b) returns string {
    match a {
        12 => { return "12"; }
        "Hello" => { return "Hello"; }
        15 => {
            match b {
                34 => { return "15 & 34"; }
                "HelloWorld" => { return "15 & HelloWorld"; }
            }
        }
        "check" => {
            match b {
                "check" => {
                    string str = check getCheckError();
                    return str;
                }
                "HelloWorld" => { return "HelloAgain & HelloWorld"; }
            }
        }
        true => { return "true"; }
    } on fail error e {
        return e.toString();
    }
    return "Default";
}

const DECIMAL_NUMBER = 2;

function testVarInMatchPatternWithinOnfail() {
    assertEquals("error(\"Custom Error\") at onfail; input received: 2, 10",
        getDetailErrorWithMatchedInput([2, "10"]));
    assertEquals("error(\"Custom Error\") at onfail; input received: 10, 50",
        getDetailErrorWithMatchedInput([10, "50"]));
    assertEquals("error(\"Custom Error\") at onfail; input received: 20, 100",
        getDetailErrorWithMatchedInput([20, "100"]));
    assertEquals("error(\"Custom Error\") at onfail; input received: 2, 100-> Error at outer onfail : error(\"Custom Error\")",
        getErrorDetailFromMultipleThrow([2, "100"]));
    assertEquals("error(\"Custom Error\") at onfail; input received: 10, 100-> Error at outer onfail : error(\"Custom Error\")",
        getErrorDetailFromMultipleThrow([10, "100"]));
    assertEquals("error(\"Custom Error\") at onfail; input received; digits:10 num:10-> Error at outer onfail : error(\"Custom Error\")",
        getErrorDetailNestedMatch([DECIMAL_NUMBER, "10"]));
}

function getDetailErrorWithMatchedInput([int, string] entry) returns string {
    string str = "";
    match entry {
        [DECIMAL_NUMBER, var digits] => {
            do { string _ = check getError(); } on fail error cause {
                str += cause.toString() + " at onfail; input received: 2, " + digits;
            }
        }
        [10, var digits] => {
            do { string _ = check getError(); } on fail error cause {
                str += cause.toString() + " at onfail; input received: 10, " + digits;
            }
        }
        [20, var digits] => {
            do { string _ = check getError(); } on fail error cause {
                str += cause.toString() + " at onfail; input received: 20, " + digits;
            }
        }
    }
    return str;
}

function getErrorDetailFromMultipleThrow([int, string] entry) returns string {
    string str = "";
    match entry {
        [DECIMAL_NUMBER, var digits] => {
            do { string _ = check getError(); } on fail error cause {
                str += cause.toString() + " at onfail; input received: 2, " + digits;
                fail cause;
            }
        }
        [10, var digits] => {
            do { string _ = check getError(); } on fail error cause {
                str += cause.toString() + " at onfail; input received: 10, " + digits;
                fail cause;
            }
        }
    } on fail error e {
        str += "-> Error at outer onfail : " + e.toString();
    }
    return str;
}

function getErrorDetailNestedMatch([int, string] entry) returns string {
    string str = "";
    match entry {
        [DECIMAL_NUMBER, var digits] => {
            match digits {
                var num => {
                    do { string _ = check getError(); } on fail error cause {
                        str += cause.toString() + " at onfail; input received; digits:" + digits + " num:" + num;
                        fail cause;
                    }
                }
            }
        }
    } on fail error e {
        str += "-> Error at outer onfail : " + e.toString();
    }
    return str;
}

type SampleErrorData record {| int code; string reason; |};
type SampleError error<SampleErrorData>;

string testMessage = "";
int testErrorCode = 0;
string testErrorReason = "";
string matchString = "fail";
string matchRes = "";

function testSimpleOnFailWithErrorBP() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error("error!"); }
    } on fail error error(msg) { testMessage = msg; }
    assertEquals(testMessage, "error!");
}

function testSimpleOnFailWithErrorBPWithVar() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error("error!"); }
    } on fail var error(msg) { testMessage = msg; }
    assertEquals(testMessage, "error!");
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithError() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertUserErrorFields();
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithVar() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail var error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertUserErrorFields();
}

function testOnFailWithErrorBPHavingUserDefinedType() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail SampleError error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertUserErrorFields();
}

function assertUserErrorFields() {
    assertEquals(testMessage, "error!");
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorReason, "deadlock condition");
    assertEquals(testErrorCode is int, true);
    assertEquals(testErrorReason is string, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail1() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error<SampleErrorData> error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertUserErrorFields();
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail2() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error<record {int code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail3() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error<record {int code;}> error(code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason;
    }
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorReason, "deadlock condition");
    assertEquals(testErrorCode is int, true);
    assertEquals(testErrorReason is string, true);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail4() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error<record {int|string code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingAnonDetailRecord() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            error<record {int code;}> errVar = error("error", code = 34);
            fail errVar;
        }
    } on fail error<record {int code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquals(testErrorCode, 34);
    assertEquals(testErrorCode is int, true);
}

function testOnFailWithErrorBPHavingAnonDetailRecordWithVar() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            error<record {int code;}> errVar = error("error", code = 34);
            fail errVar;
        }
    } on fail var error(msg, code = errCode) { testErrorCode = errCode; testErrorReason = msg; }
    assertEquals(testErrorCode, 34);
    assertEquals(testErrorCode is int, true);
    assertEquals(testErrorReason is string, true);
    assertEquals(testErrorReason, "error");
}

function testOnFailWithErrorBPHavingAnonDetailRecordWithUnionType() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            error<record {int code;}> errVar = error("error", code = 34);
            fail errVar;
        }
    } on fail error<record {int|string code;}> error(code = errCode) { testErrorCode = errCode; }
    assertEquals(testErrorCode, 34);
    assertEquals(testErrorCode is int, true);
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

function testOnFailWithErrorBPWithErrorArgsHavingBP1() {
    string causeMsg;
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            fail error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20,
                pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
    } on fail SampleComplexError error(_, cause = errCause, code = errCode, pos = errorPos, infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = errorPos[0]; testErrorPosCol = errorPos[1];
        testErrorMoreInfo = errInfo.moreInfo; causeMsg = errCause.message();
    }
    assertComplexErrorFields(causeMsg);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP2() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            fail error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20,
                pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
    } on fail SampleComplexError error(message, cause = error(msg), code = errCode, pos = errorPos, infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = errorPos[0]; testErrorPosCol = errorPos[1];
        testErrorMoreInfo = errInfo.moreInfo; testMessage = msg;
    }
    assertComplexErrorFields(testMessage);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP3() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            fail error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20,
                pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
    } on fail SampleComplexError error(message, cause = error(msg), code = errCode, pos = [row, col], infoDetails = errInfo) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo.moreInfo; testMessage = msg;
    }
    assertComplexErrorFields(testMessage);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP4() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            fail error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20,
                pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
    } on fail SampleComplexError error(_, cause = error(msg), code = errCode, pos = [row, col],
            infoDetails = {moreInfo: errInfo}) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo; testMessage = msg;
    }
    assertComplexErrorFields(testMessage);
}

function testOnFailWithErrorBPWithErrorArgsHavingBP5() {
    match matchString {
        12 => { matchRes = "12"; }
        "fail" => {
            fail error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20,
                pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
    } on fail var error(_, cause = error(msg), code = errCode, pos = [row, col], infoDetails = {moreInfo: errInfo}) {
        testErrorCode = errCode; testErrorPosRow = row; testErrorPosCol = col;
        testErrorMoreInfo = errInfo; testMessage = msg;
    }
    assertComplexErrorFields(testMessage);
}

function assertComplexErrorFields(string causeMessage) {
    assertEquals(testErrorPosRow, 30);
    assertEquals(testErrorPosRow is int, true);
    assertEquals(testErrorPosCol, 45);
    assertEquals(testErrorPosCol is int, true);
    assertEquals(testErrorMoreInfo, "deadlock condition");
    assertEquals(testErrorMoreInfo is string, true);
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorCode is int, true);
    assertEquals(causeMessage, "Database Error");
    assertEquals(causeMessage is string, true);
}

function testMultiLevelOnFailWithErrorBP() {
    int i = 2;
    string str = "";
    while i <= 2 {
        match matchString {
            12 => { matchRes = "12"; }
            "fail" => {
                str += " -> Iteration " + i.toString() + ", ";
                fail error SampleError("error!", code = 30, reason = "deadlock condition");
            }
        } on fail var error(msg1, code = errCode1, reason = errReason1) {
            str += " -> On Fail #" + i.toString();
            testMessage = msg1; testErrorCode = errCode1; testErrorReason = errReason1;
        }
        i += 1;
        fail error SampleError("database error!", code = 20, reason = "database connection error");
    } on fail SampleError error(msg2, code = errCode2, reason = errReason2) {
        str += " -> On Fail Final";
    }
    assertEquals(" -> Iteration 2,  -> On Fail #2 -> On Fail Final", str);
    assertEquals(testErrorCode, 30);
    assertEquals(testErrorReason, "deadlock condition");
    assertEquals(testMessage, "error!");
}

function testMultiLevelOnFailWithoutErrorInOneLevel() {
    int i = 2;
    string str = "";
    while i <= 2 {
        match matchString {
            12 => { matchRes = "12"; }
            "fail" => {
                str += " -> Iteration " + i.toString() + ", ";
                fail error SampleError("error!", code = 20, reason = "deadlock condition");
            }
        } on fail var error(msg1, code = errCode1, reason = errReason1) {
            str += " -> On Fail #" + i.toString();
            testMessage = msg1; testErrorCode = errCode1; testErrorReason = errReason1;
        }
        i += 1;
    } on fail SampleError error(msg2, code = errCode2, reason = errReason2) {
        str += " -> On Fail Final";
    }
    assertEquals(" -> Iteration 2,  -> On Fail #2", str);
    assertEquals(testErrorCode, 20);
    assertEquals(testErrorReason, "deadlock condition");
    assertEquals(testMessage, "error!");
}

function assertEquals(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}
