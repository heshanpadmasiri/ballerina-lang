import ballerina/io;

type SampleErrorData record {|
    int code;
    string reason;
|};
type SampleError error<SampleErrorData>;
type SampleComplexErrorData record {|
    error cause;
    int code;
    int[2] pos;
    record {string moreInfo;} infoDetails;
|};
type SampleComplexError error<SampleComplexErrorData>;

string testMessage = "";
int testErrorCode = 0;
string testErrorReason = "";
int whileIndex = 0;
int testErrorPosRow = 0;
int testErrorPosCol = 0;
string testErrorMoreInfo = "";
int testErrorCodeNested = 0;
string testMessageNested = "";

function testWhileStmtWithFail(int x) returns string {
    int a = 0;
    string str = "";
    while x >= a {
        a += 1;
        str = str.concat(" Value: ", a.toString());
        if a == 3 {
            fail error("Custom Error");
        }
    } on fail error e {
        str += "-> error caught. Hence value returning";
        return str;
    }
    str += "-> reached end";
    return str;
}

function testWhileStmtWithCheck(int x) returns string {
    int a = 0;
    string str = "";
    while x >= a {
        a += 1;
        str = str.concat(" Value: ", a.toString());
        if a == 3 {
            int val = check getError();
            str = str.concat(" Value: ", val.toString());
        }
    } on fail error e {
        str += "-> error caught. Hence value returning";
        return str;
    }
    str += "-> reached end";
    return str;
}
function getError() returns int|error => error("Custom Error");

function testNestedWhileStmtWithFail() returns string {
    string result = "";
    error err = error("Custom Error");
    int i = 0;
    while isEqual(i, 0) {
        i += 1;
        while isEqual(i, 1) {
            i += 1;
            while i == 2 {
                i += 1;
                while i == 0 {
                }
                result += "level3";
                fail err;
            } on fail error e3 {
                result += "-> error caught at level 3, ";
            }
            result += "level2";
            fail err;
        } on fail error e2 {
            result += "-> error caught at level 2, ";
        }
        result += "level1";
        fail err;
    } on fail error e1 {
        result += "-> error caught at level 1.";
    }
    return result;
}
function isEqual(int i, int j) returns boolean => i == j;

function testWhileStmtLoopEndingWithFail(int x) returns string {
    int a = 0;
    string str = "";
    while x >= a {
        a += 1;
        str = str.concat(" Value: ", a.toString());
        fail error("Custom Error");
    } on fail error e {
        str += "-> error caught. Hence value returning";
    }
    str += "-> reached end";
    return str;
}

function testNestedWhileStmtLoopTerminationWithFail() returns string {
    string result = "";
    error err = error("Custom Error");
    int i = 0;
    while i >= 0 {
        i += 1;
        while i >= 1 {
            i += 1;
            while i >= 2 {
                i += 1;
                result += "level3";
                fail err;
            } on fail error e3 {
                result += "-> error caught at level 3, ";
            }
            result += "level2";
            fail err;
        } on fail error e2 {
            result += "-> error caught at level 2, ";
        }
        result += "level1";
        fail err;
    } on fail error e1 {
        result += "-> error caught at level 1.";
    }
    return result;
}

function testWhileStmtWithOnFailWithoutVariable() {
    int a = 0;
    string str = "";
    while 3 >= a {
        a += 1;
        str = str.concat(" Value: ", a.toString());
        if a == 3 {
            fail error("Custom Error");
        }
    } on fail {
        str += "-> error caught.";
    }
    str += " -> reached end";
    assertEquality(" Value: 1 Value: 2 Value: 3-> error caught. -> reached end", str);
}

function testSimpleOnFailWithErrorBP() {
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 { fail error("error!"); }
    } on fail error error(msg) { testMessage = msg; }
    assertEquality("error!", testMessage);
}
function testSimpleOnFailWithErrorBPWithVar() {
    whileIndex = 0;
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 { fail error("error!"); }
    } on fail var error(msg) { testMessage = msg; }
    assertEquality("error!", testMessage);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithError() {
    whileIndex = 0;
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail error error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertSample();
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function testOnFailWithErrorBPHavingUserDefinedTypeWithVar() {
    whileIndex = 0;
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail var error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertSample();
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function testOnFailWithErrorBPHavingUserDefinedType() {
    whileIndex = 0;
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 { fail error SampleError("error!", code = 20, reason = "deadlock condition"); }
    } on fail SampleError error(msg, code = errCode, reason = errReason) {
        testErrorCode = errCode; testErrorReason = errReason; testMessage = msg;
    }
    assertSample();
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function assertSample() {
    assertEquality("error!", testMessage); assertEquality(20, testErrorCode);
    assertEquality("deadlock condition", testErrorReason);
}

function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail1() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail error<SampleErrorData> error(msg, code = c, reason = r) { testMessage = msg; testErrorCode = c; testErrorReason = r; }
    assertSample();
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail2() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail error<record {int code;}> error(code = c) { testErrorCode = c; }
    assertEquality(20, testErrorCode);
    assertEquality(testErrorCode is int, true);
}
function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail3() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail error<record {int code;}> error(code = c, reason = r) { testErrorCode = c; testErrorReason = r; }
    assertEquality(20, testErrorCode); assertEquality("deadlock condition", testErrorReason);
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function testOnFailWithErrorBPHavingUserDefinedTypeWithErrDetail4() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail error<record {int|string code;}> error(code = c) { testErrorCode = c; }
    assertEquality(20, testErrorCode);
    assertEquality(testErrorCode is int, true);
}
function sampleError() returns SampleError => error SampleError("error!", code = 20, reason = "deadlock condition");

function testOnFailWithErrorBPHavingAnonDetailRecord() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { error<record {int code;}> errVar = error("error", code = 34); fail errVar; } }
    on fail error<record {int code;}> error(code = c) { testErrorCode = c; }
    assertEquality(34, testErrorCode);
    assertEquality(testErrorCode is int, true);
}
function testOnFailWithErrorBPHavingAnonDetailRecordWithVar() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { error<record {int code;}> errVar = error("error", code = 34); fail errVar; } }
    on fail var error(msg, code = c) { testErrorCode = c; testErrorReason = msg; }
    assertEquality(34, testErrorCode); assertEquality("error", testErrorReason);
    assertEquality(testErrorCode is int, true);
    assertEquality(testErrorReason is string, true);
}
function testOnFailWithErrorBPHavingAnonDetailRecordWithUnionType() {
    whileIndex = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { error<record {int code;}> errVar = error("error", code = 34); fail errVar; } }
    on fail error<record {int|string code;}> error(code = c) { testErrorCode = c; }
    assertEquality(34, testErrorCode);
    assertEquality(testErrorCode is int, true);
}

function complexError() returns SampleComplexError => error SampleComplexError("Transaction Failure", cause = error("Database Error"), code = 20, pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
function testOnFailWithErrorBPWithErrorArgsHavingBP1() {
    whileIndex = 0; while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail complexError(); } }
    on fail SampleComplexError error(_, cause = cause, code = c, pos = p, infoDetails = info) { testErrorCode = c; testErrorPosRow = p[0]; testErrorPosCol = p[1]; testErrorMoreInfo = info.moreInfo; testMessage = cause.message(); }
    assertComplex();
    assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode is int, true);
    assertEquality(testMessage is string, true);
}
function testOnFailWithErrorBPWithErrorArgsHavingBP2() {
    whileIndex = 0; while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail complexError(); } }
    on fail SampleComplexError error(message, cause = error(msg), code = c, pos = p, infoDetails = info) { testErrorCode = c; testErrorPosRow = p[0]; testErrorPosCol = p[1]; testErrorMoreInfo = info.moreInfo; testMessage = msg; }
    assertComplex();
    assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode is int, true);
    assertEquality(testMessage is string, true);
}
function testOnFailWithErrorBPWithErrorArgsHavingBP3() {
    whileIndex = 0; while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail complexError(); } }
    on fail SampleComplexError error(message, cause = error(msg), code = c, pos = [row, col], infoDetails = info) { testErrorCode = c; testErrorPosRow = row; testErrorPosCol = col; testErrorMoreInfo = info.moreInfo; testMessage = msg; }
    assertComplex();
    assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode is int, true);
    assertEquality(testMessage is string, true);
}
function testOnFailWithErrorBPWithErrorArgsHavingBP4() {
    whileIndex = 0; while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail complexError(); } }
    on fail SampleComplexError error(_, cause = error(msg), code = c, pos = [row, col], infoDetails = {moreInfo: info}) { testErrorCode = c; testErrorPosRow = row; testErrorPosCol = col; testErrorMoreInfo = info; testMessage = msg; }
    assertComplex();
    assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode is int, true);
    assertEquality(testMessage is string, true);
}
function testOnFailWithErrorBPWithErrorArgsHavingBP5() {
    whileIndex = 0; while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail complexError(); } }
    on fail var error(_, cause = error(msg), code = c, pos = [row, col], infoDetails = {moreInfo: info}) { testErrorCode = c; testErrorPosRow = row; testErrorPosCol = col; testErrorMoreInfo = info; testMessage = msg; }
    assertComplex();
    assertEquality(testErrorPosRow is int, true);
    assertEquality(testErrorPosCol is int, true);
    assertEquality(testErrorMoreInfo is string, true);
    assertEquality(testErrorCode is int, true);
    assertEquality(testMessage is string, true);
}
function assertComplex() {
    assertEquality(20, testErrorCode); assertEquality(30, testErrorPosRow); assertEquality(45, testErrorPosCol);
    assertEquality("deadlock condition", testErrorMoreInfo); assertEquality("Database Error", testMessage);
}

function testNestedOnFailWithErrorBP() {
    whileIndex = 0; int inner = 0; string nestedReason = "";
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail var error(msg1, code = c1, reason = r1) {
        if c1 == 20 {
            while inner >= 0 { inner += 1; if inner == 1 { fail error SampleError("nested error!", code = 30, reason = "database error"); } }
            on fail var error(msg2, code = c2, reason = r2) { testErrorCode = c1; testErrorCodeNested = c2; testErrorReason = r1; nestedReason = r2; testMessage = msg1; testMessageNested = msg2; }
        }
    }
    assertEquality(20, testErrorCode); assertEquality(30, testErrorCodeNested); assertEquality("deadlock condition", testErrorReason); assertEquality("database error", nestedReason); assertEquality("error!", testMessage); assertEquality("nested error!", testMessageNested);
}
function testNestedOnFailWithErrorBPWithErrorArgsHavingBP() {
    whileIndex = 0; int inner = 0;
    while whileIndex >= 0 { whileIndex += 1; if whileIndex == 1 { fail sampleError(); } }
    on fail var error(msg1, code = c1, reason = r1) {
        if c1 == 20 {
            while inner >= 0 { inner += 1; if inner == 1 { fail error SampleComplexError("nested error!", cause = error("Database Error"), code = 30, pos = [35, 45], infoDetails = {moreInfo: "deadlock condition"}); } }
            on fail SampleComplexError error(_, cause = error(msg2), code = c2, pos = [row, col], infoDetails = {moreInfo: info}) { testErrorCode = c1; testErrorCodeNested = c2; testMessage = msg1; testMessageNested = msg2; testErrorPosRow = row; testErrorPosCol = col; testErrorMoreInfo = info; }
        }
    }
    assertEquality(20, testErrorCode); assertEquality(30, testErrorCodeNested); assertEquality("deadlock condition", testErrorMoreInfo); assertEquality("error!", testMessage); assertEquality("Database Error", testMessageNested); assertEquality(35, testErrorPosRow); assertEquality(45, testErrorPosCol);
}
function testMultiLevelOnFailWithErrorBP() {
    int i = 0; string str = ""; whileIndex = 0;
    while i == 0 {
        while whileIndex == 0 { whileIndex += 1; if whileIndex == 1 { str += " -> Iteration " + i.toString() + ", "; fail sampleError(); } }
        on fail var error(msg, code = c, reason = r) { str += " -> On Fail #" + i.toString(); testMessage = msg; testErrorCode = c; testErrorReason = r; }
        i += 1; fail sampleError();
    } on fail SampleError error(msg, code = c, reason = r) { str += " -> On Fail Final"; }
    assertEquality(" -> Iteration 0,  -> On Fail #0 -> On Fail Final", str); assertSample();
}
function testMultiLevelOnFailWithoutErrorInOneLevel() {
    int i = 0; string str = ""; whileIndex = 0;
    while i == 0 {
        while whileIndex == 0 { whileIndex += 1; if whileIndex == 1 { str += " -> Iteration " + i.toString() + ", "; fail sampleError(); } }
        on fail var error(msg, code = c, reason = r) { str += " -> On Fail #" + i.toString(); testMessage = msg; testErrorCode = c; testErrorReason = r; }
        i += 1;
    } on fail SampleError error(msg, code = c, reason = r) { str += " -> On Fail Final"; }
    assertEquality(" -> Iteration 0,  -> On Fail #0", str); assertSample();
}

function assertEquality(anydata expected, anydata actual) {
    if actual == expected { return; }
    panic error("AssertionError", message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    testWhileStmtWithOnFailWithoutVariable();
    io:println(testWhileStmtWithFail(5)); // @output  Value: 1 Value: 2 Value: 3-> error caught. Hence value returning
    io:println(testWhileStmtWithCheck(5)); // @output  Value: 1 Value: 2 Value: 3-> error caught. Hence value returning
    io:println(testNestedWhileStmtWithFail()); // @output level3-> error caught at level 3, level2-> error caught at level 2, level1-> error caught at level 1.
    io:println(testWhileStmtLoopEndingWithFail(5)); // @output  Value: 1-> error caught. Hence value returning-> reached end
    io:println(testNestedWhileStmtLoopTerminationWithFail()); // @output level3-> error caught at level 3, level2-> error caught at level 2, level1-> error caught at level 1.
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
    testNestedOnFailWithErrorBP();
    testNestedOnFailWithErrorBPWithErrorArgsHavingBP();
    testMultiLevelOnFailWithErrorBP();
    testMultiLevelOnFailWithoutErrorInOneLevel();
}
