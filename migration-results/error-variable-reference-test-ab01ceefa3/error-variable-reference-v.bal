import ballerina/io;
import ballerina/lang.value;

type SMS error<record {| string message; error cause?; string detail; string extra?; |}>;
type SMA error<record {| string message; error cause?; boolean fatal; boolean|string detail?; boolean|string extra?; |}>;
type CMS error<record {| string message; error cause?; string detail; string extra?; |}>;
type CMA error<record {| string message; error cause?; anydata fatal; anydata detail?; anydata extra?; |}>;

const ERROR1 = "Some Error One";
const ERROR2 = "Some Error Two";

function testBasicErrorVariableWithMapDetails() returns [string, string, string, string, map<string|error>, string?, string?, map<any|error>, any, any] {
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg");
    SMA err2 = error SMA("Error Two", message = "Msg Two", fatal = true);
    string reason11; map<string|error> detail11; string reason12; string? message12; string? detail12;
    error(reason11, ...detail11) = err1;
    error(reason12, message = message12, detail = detail12) = err1;
    string reason21; map<any|error> detail21; string reason22; any message22; any fatal22;
    error(reason21, ...detail21) = err2;
    error(reason22, message = message22, fatal = fatal22) = err2;
    return [reason11, reason12, reason21, reason22, detail11, message12, detail12, detail21, message22, fatal22];
}

function testBasicErrorVariableWithConstAndMap() returns [string, string, string, string, map<string|error>, string?, string?, map<any|error>, any, any, error?] {
    CMS err3 = error CMS(ERROR1, message = "Msg Three", detail = "Detail Msg");
    CMA err4 = error CMA(ERROR2, err3, message = "Msg Four", fatal = true);
    string reason31; map<string|error> detail31; string reason32; string? message32; string? detail32;
    error(reason31, ...detail31) = err3;
    error(reason32, message = message32, detail = detail32) = err3;
    string reason41; map<any|error> detail41; string reason42; any message42; any fatal42; error? cause;
    error(reason41, cause, ...detail41) = err4;
    error(reason42, message = message42, fatal = fatal42) = err4;
    return [reason31, reason32, reason41, reason42, detail31, message32, detail32, detail41, message42, fatal42, cause];
}

type Foo record { string message; boolean fatal; error cause?; };
type FooError error<Foo>;
type FileOpenErrorDetail record {| string message; error cause?; string targetFileName; int errorCode; int flags; |};
type FileOpenError error<FileOpenErrorDetail>;

function testBasicErrorVariableWithRecordDetails() returns [string, string, string, boolean, map<anydata|error>] {
    FooError err1 = error FooError("Error One", message = "Something Wrong", fatal = true);
    FooError err2 = error FooError("Error One", message = "Something Wrong", fatal = true);
    string res1; map<anydata|error> mapRec; string res2; string message; boolean fatal;
    error(res1, ...mapRec) = err1;
    error(res2, message = message, fatal = fatal) = err2;
    return [res1, res2, message, fatal, mapRec];
}

function testErrorInTuple() returns [int, string, string, value:Cloneable, boolean] {
    Foo f = {message: "fooMsg", fatal: true};
    [int, string, error, [error, Foo]] t1 = [12, "Bal", error("Err", message = "Something Wrong"), [error("Err2", message = "Something Wrong2"), f]];
    int intVar; string stringVar; error errorVar; error errorVar2; Foo fooVar;
    [intVar, stringVar, errorVar, [errorVar2, fooVar]] = t1;
    return [intVar, stringVar, errorVar.message(), errorVar2.detail()["message"], fooVar.fatal];
}

type StrError error<map<string|readonly>>;

function testErrorWithRestParam() returns map<string|readonly> {
    StrError errWithMap = error StrError("Error", message = "Fatal", fatal = "true");
    string reason; map<string|readonly> detailMap;
    error(reason, ...detailMap) = errWithMap;
    detailMap["extra"] = "extra";
    return detailMap;
}

function testErrorWithUnderscore() returns [string, map<string|readonly>] {
    StrError errWithMap = error StrError("Error", message = "Fatal", fatal = "true");
    string reason; map<string|readonly> detail;
    error(reason) = errWithMap;
    error(_, ...detail) = errWithMap;
    return [reason, detail];
}

type SampleError error;

function testDefaultErrorRefBindingPattern() returns string {
    SampleError e = error("the reason");
    string reason;
    error(reason) = e;
    return reason;
}

function testIndirectErrorRefBindingPattern() returns [anydata|error, boolean] {
    FooError e = error("the reason", message = "msg", fatal = false);
    anydata|error message; boolean fatal; map<anydata|error> rest;
    error FooError(_, message = message, fatal = fatal, ...rest) = e;
    return [message, fatal];
}

function testNoErrorReasonGiven() returns string? {
    FooError e = error("errorCode", message = "message", fatal = false);
    anydata|error message;
    error(_, message = message) = e;
    return <string?>checkpanic message;
}

function testIndirectErrorRefMandatoryFields() {
    error causeErr = error("c");
    FileOpenError e = error FileOpenError("FILE-OPEN", message = "file open failed", targetFileName = "/usr/bhah/a.log", errorCode = 45221, flags = 128, cause = causeErr);
    string message; string fileName; int errorCode; int flags;
    error FileOpenError(_, message = message, targetFileName = fileName, errorCode = errorCode, flags = flags) = e;
    error upcast = e; map<value:Cloneable> rest;
    error(_, ...rest) = upcast;
    string messageX; map<string|int|error> rest2;
    error(_, message = messageX, ...rest2) = e;
    assertEquality("file open failed", message);
    assertEquality("/usr/bhah/a.log", fileName);
    assertEquality(45221, errorCode);
    assertEquality(128, flags);
    assertEquality("file open failed", rest["message"]);
    error restCause = <error>rest["cause"];
    assertEquality(causeErr, restCause);
    assertEquality("/usr/bhah/a.log", rest["targetFileName"]);
    assertEquality(45221, rest["errorCode"]);
    assertEquality(128, rest["flags"]);
    assertEquality("file open failed", messageX);
    error rest2Cause = <error>rest2["cause"];
    assertEquality(causeErr, rest2Cause);
    assertEquality("/usr/bhah/a.log", rest2["targetFileName"]);
    assertEquality(45221, rest2["errorCode"]);
    assertEquality(128, rest2["flags"]);
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    var mapDetails = testBasicErrorVariableWithMapDetails();
    io:println(mapDetails[0]); // @output Error One
    io:println(mapDetails[1]); // @output Error One
    io:println(mapDetails[2]); // @output Error Two
    io:println(mapDetails[3]); // @output Error Two
    io:println(mapDetails[4]["message"]); // @output Msg One
    io:println(mapDetails[5]); // @output Msg One
    io:println(mapDetails[6]); // @output Detail Msg
    io:println(mapDetails[7]["message"]); // @output Msg Two
    io:println(mapDetails[7]["fatal"]); // @output true
    io:println(mapDetails[8]); // @output Msg Two
    io:println(mapDetails[9]); // @output true

    var constDetails = testBasicErrorVariableWithConstAndMap();
    io:println(constDetails[0]); // @output Some Error One
    io:println(constDetails[1]); // @output Some Error One
    io:println(constDetails[2]); // @output Some Error Two
    io:println(constDetails[3]); // @output Some Error Two
    io:println(constDetails[4]["message"]); // @output Msg Three
    io:println(constDetails[5]); // @output Msg Three
    io:println(constDetails[6]); // @output Detail Msg
    io:println(constDetails[7]["message"]); // @output Msg Four
    io:println(constDetails[7]["fatal"]); // @output true
    io:println(constDetails[8]); // @output Msg Four
    io:println(constDetails[9]); // @output true
    io:println(constDetails[10]); // @output error CMS ("Some Error One",message="Msg Three",detail="Detail Msg")

    var recordDetails = testBasicErrorVariableWithRecordDetails();
    io:println(recordDetails[0]); // @output Error One
    io:println(recordDetails[1]); // @output Error One
    io:println(recordDetails[2]); // @output Something Wrong
    io:println(recordDetails[3]); // @output true
    io:println(recordDetails[4]["message"]); // @output Something Wrong

    var tuple = testErrorInTuple();
    io:println(tuple[0]); // @output 12
    io:println(tuple[1]); // @output Bal
    io:println(tuple[2]); // @output Err
    io:println(tuple[3]); // @output Something Wrong2
    io:println(tuple[4]); // @output true

    var rest = testErrorWithRestParam();
    io:println(rest["fatal"]); // @output true
    io:println(rest["extra"]); // @output extra
    var underscore = testErrorWithUnderscore();
    io:println(underscore[0]); // @output Error
    io:println(underscore[1]["message"]); // @output Fatal
    io:println(underscore[1]["fatal"]); // @output true
    io:println(testDefaultErrorRefBindingPattern()); // @output the reason
    var indirect = testIndirectErrorRefBindingPattern();
    io:println(indirect[0]); // @output msg
    io:println(indirect[1]); // @output false
    io:println(testNoErrorReasonGiven()); // @output message
    testIndirectErrorRefMandatoryFields();
}
