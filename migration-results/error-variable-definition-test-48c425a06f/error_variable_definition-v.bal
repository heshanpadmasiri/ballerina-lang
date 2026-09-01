import ballerina/io;
import ballerina/lang.'value;

type SMS error <record {| string message; error cause?; string detail?; string...; |}>;
type SMA error <record {| string message; error cause?; boolean fatal?; string...; |}>;
type CMS error <record {| string message; error cause?; string detail?; string...; |}>;
type CMA error <record {| string message; error cause?; boolean fatal?; anydata...; |}>;
const ERROR1 = "Some Error One";
const ERROR2 = "Some Error Two";

function testBasicErrorVariableWithMapDetails() returns [string, string, string, string, map<string|error>, string?, map<any|error>, any] {
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg");
    SMA err2 = error SMA("Error Two", message = "Msg Two", fatal = true);
    SMS error (reason11, message = m1, ... detail11) = err1;
    SMS error (reason12, message = message12) = err1;
    SMA error (reason21, ...detail21) = err2;
    SMA error (reason22, message = message22) = err2;
    return [reason11, reason12, reason21, reason22, detail11, message12, detail21, message22];
}

function testBasicErrorVariableWithConstAndMap() returns [string, string, string, string, map<string|error>, string?, map<any|error>, any] {
    CMS err3 = error CMS(ERROR1, message = "Msg Three", detail = "Detail Msg");
    CMA err4 = error CMA(ERROR2, message = "Msg Four", fatal = true);
    CMS error (reason31, ... detail31) = err3;
    CMS error (reason32, message = message32) = err3;
    CMA error (reason41, ... detail41) = err4;
    CMA error (reason42, message = message42) = err4;
    return [reason31, reason32, reason41, reason42, detail31, message32, detail41, message42];
}

function testVarBasicErrorVariableWithMapDetails() returns [string, string, string, string, map<string|error>, string?, map<any|error>, any] {
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg");
    SMA err2 = error SMA("Error Two", message = "Msg Two", fatal = true);
    var error (reason11, ... detail11) = err1;
    var error (reason12, message = message12) = err1;
    var error (reason21, ... detail21) = err2;
    var error (reason22, message = message22) = err2;
    return [reason11, reason12, reason21, reason22, detail11, message12, detail21, message22];
}

function testVarBasicErrorVariableWithConstAndMap() returns [string, string, string, string, map<string|error>, string?, map<any|error>, any] {
    CMS err3 = error CMS(ERROR1, message = "Msg Three", detail = "Detail Msg");
    CMA err4 = error CMA(ERROR2, message = "Msg Four", fatal = true);
    var error (reason31, ... detail31) = err3;
    var error (reason32, message = message32) = err3;
    var error (reason41, ... detail41) = err4;
    var error (reason42, message = message42) = err4;
    return [reason31, reason32, reason41, reason42, detail31, message32, detail41, message42];
}

type Foo record { string message; boolean fatal; error cause?; };
type FooError error <Foo>;

function testBasicErrorVariableWithRecordDetails() returns [string, string, string, boolean, map<anydata|readonly>] {
    FooError err1 = error FooError("Error One", message = "Something Wrong", fatal = true);
    FooError error (res1, ... rec) = err1;
    FooError error (res2, message = message, fatal = fatal) = error FooError("Error One", message = "Something Wrong", fatal = true);
    return [res1, res2, message, fatal, rec];
}

function testErrorInTuple() returns [int, string, string, value:Cloneable, boolean] {
    Foo f = { message: "fooMsg", fatal: true };
    [int, string, error, [error, Foo]] t1 = [12, "Bal", error("Err", message = "Something Wrong"), [error("Err2", message = "Something Wrong2"), f]];
    [int, string, error, [error, Foo]] [intVar, stringVar, erroVar, [errorVar2, fooVar]] = t1;
    return [intVar, stringVar, erroVar.message(), errorVar2.detail()["message"], fooVar.fatal];
}

function testErrorInTupleWithVar() returns [int, string, string, value:Cloneable, boolean] {
    Foo f = { message: "fooMsg", fatal: false };
    [int, string, error, [error, Foo]] t1 = [12, "Bal", error("Err", message = "Something Wrong"), [error("Err2", message = "Something Wrong2"), f]];
    var [intVar, stringVar, erroVar, [errorVar2, fooVar]] = t1;
    return [intVar, stringVar, erroVar.message(), errorVar2.detail()["message"], fooVar.fatal];
}

function testErrorInTupleWithDestructure() returns [int, string, string, map<value:Cloneable>, boolean] {
    [int, string, [error, boolean]] t1 = [12, "Bal", [error("Err2", message = "Something Wrong2"), true]];
    [int, string, [error, boolean]] [intVar, stringVar, [error(reasonVar, ... detailVar), booleanVar]] = t1;
    return [intVar, stringVar, reasonVar, detailVar, booleanVar];
}

function testErrorInTupleWithDestructure2() returns [int, string, string, value:Cloneable, boolean] {
    [int, string, [error, boolean]] t1 = [12, "Bal", [error("Err2", message = "Something Wrong2"), true]];
    [int, string, [error, boolean]] [intVar, stringVar, [error(reasonVar, message = message), booleanVar]] = t1;
    return [intVar, stringVar, reasonVar, message, booleanVar];
}

type Bar record { int x; error e; };

function testErrorInRecordWithDestructure() returns [int, string, value:Cloneable] {
    Bar b = { x: 1000, e: error("Err3", message = "Something Wrong3") };
    Bar { x, e: error(reason, ...detail) } = b;
    return [x, reason, detail["message"]];
}

type SealedErrorDetail record { string message; error cause?; };
type SealedError error<SealedErrorDetail>;
type simpleError record {| (value:Cloneable)...; |};

function testErrorWithAnonErrorType() returns [string, value:Cloneable] {
    SealedError err = error("Error Code", message = "Fatal");
    error <simpleError> error(reason, message = message) = err;
    return [reason, message];
}

function testErrorWithUnderscore() returns [string, string, string, string, string, string, string, string, string|error?, anydata|readonly?, anydata|readonly?] {
    error err = error("Error Code", message = "Fatal");
    error error (reason) = err;
    error error (reason2) = err;
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg");
    SMS error (reason3) = err1;
    SMS error (reason4) = err1;
    SMS error (_, ... detail) = err1;
    FooError err2 = error FooError("Error Two", message = "Something Wrong", fatal = true);
    FooError error (reason5) = err2;
    FooError error (reason6) = err2;
    FooError error (_, ... detail2) = err2;
    var error (reason7) = err2;
    var error (reason8) = err2;
    var error (_, ... detail3) = err2;
    return [reason, reason2, reason3, reason4, reason5, reason6, reason7, reason8, detail["message"], detail2["message"], detail3["message"]];
}

type Bee record {| string message; boolean fatal; error cause?; string other?; anydata...; |};
const R = "r";
type BeeError distinct error<Bee>;

function testIndirectErrorDestructuring() returns [string?, boolean, map<anydata|error>] {
    BeeError e = error BeeError(R, message="Msg", fatal=false, other="k");
    var error(_, message=m, fatal=f, ...rest) = e;
    return [m, f, rest];
}

function testSealedDetailDestructuring() returns [string, map<anydata|readonly>] {
    SealedError e = error SealedError("sealed", message="Msg");
    var error(reason, ...rest) = e;
    return [reason, rest];
}

type SampleErrorData record { string message?; error cause?; string info; boolean fatal; };
type SampleError error<SampleErrorData>;
type Baz record { value:Cloneable data; };
type BazError error<Baz>;

function testErrorBindingPattern() returns [string, boolean, value:Cloneable] {
    SampleError error(info=info, fatal=fatal) = error SampleError("Sample Error", info = "Detail Info", fatal = true);
    error error(data=transactionData) = error BazError("TransactionError", data = {"A":"a", "B":"b"});
    return [info, fatal, transactionData];
}

function testLocalErrorType() {
    SealedError err = error("Error Code", message = "Fatal");
    error<record {| value:Cloneable...; |}> error(reason, message = message) = err;
    if message is string {
        if message == "Fatal" { return; }
        panic error("Expected message=Fatal, found message=" + message);
    }
    panic error("Expected string, found: " + (typeof message).toString());
}

type ReadOnlyIntersectionError readonly & error<record { string[2] info; }>;

function testErrorBindingPatternWithErrorDeclaredWithReadOnlyIntersection() {
    ReadOnlyIntersectionError e = error("Sample Error", info = ["Detail Info 1", "Detail Info 2"]);
    var error ReadOnlyIntersectionError(message, cause, info = [info1, info2]) = e;
    assertEquals(e.message(), message);
    assertTrue(cause is ());
    assertEquals("Detail Info 1", info1);
    assertEquals("Detail Info 2", info2);
}

function assertTrue(anydata actual) { assertEquals(true, actual); }
function assertEquals(anydata expected, anydata actual) {
    if expected != actual { panic error(string `expected ${expected.toBalString()}, found ${actual.toBalString()}`); }
}

public function main() {
    var r = testBasicErrorVariableWithMapDetails();
    io:println(r[0]); // @output Error One
    io:println(r[1]); // @output Error One
    io:println(r[2]); // @output Error Two
    io:println(r[3]); // @output Error Two
    io:println(r[4]); // @output {"detail":"Detail Msg"}
    io:println(r[5]); // @output Msg One
    io:println(r[6]["message"]); // @output Msg Two
    io:println(r[6]["fatal"]); // @output true
    io:println(r[7]); // @output Msg Two

    r = testBasicErrorVariableWithConstAndMap();
    io:println(r[0]); // @output Some Error One
    io:println(r[1]); // @output Some Error One
    io:println(r[2]); // @output Some Error Two
    io:println(r[3]); // @output Some Error Two
    io:println(r[4]["message"]); // @output Msg Three
    io:println(r[5]); // @output Msg Three
    io:println(r[6]["message"]); // @output Msg Four
    io:println(r[6]["fatal"]); // @output true
    io:println(r[7]); // @output Msg Four

    r = testVarBasicErrorVariableWithMapDetails();
    io:println(r[0]); // @output Error One
    io:println(r[1]); // @output Error One
    io:println(r[2]); // @output Error Two
    io:println(r[3]); // @output Error Two
    io:println(r[4]["message"]); // @output Msg One
    io:println(r[5]); // @output Msg One
    io:println(r[6]["message"]); // @output Msg Two
    io:println(r[6]["fatal"]); // @output true
    io:println(r[7]); // @output Msg Two

    r = testVarBasicErrorVariableWithConstAndMap();
    io:println(r[0]); // @output Some Error One
    io:println(r[1]); // @output Some Error One
    io:println(r[2]); // @output Some Error Two
    io:println(r[3]); // @output Some Error Two
    io:println(r[4]["message"]); // @output Msg Three
    io:println(r[5]); // @output Msg Three
    io:println(r[6]["message"]); // @output Msg Four
    io:println(r[6]["fatal"]); // @output true
    io:println(r[7]); // @output Msg Four

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
    tuple = testErrorInTupleWithVar();
    io:println(tuple[0]); // @output 12
    io:println(tuple[1]); // @output Bal
    io:println(tuple[2]); // @output Err
    io:println(tuple[3]); // @output Something Wrong2
    io:println(tuple[4]); // @output false
    var destructuredTuple = testErrorInTupleWithDestructure();
    io:println(destructuredTuple[0]); // @output 12
    io:println(destructuredTuple[1]); // @output Bal
    io:println(destructuredTuple[2]); // @output Err2
    io:println(destructuredTuple[3]); // @output {"message":"Something Wrong2"}
    io:println(destructuredTuple[4]); // @output true
    var destructuredTuple2 = testErrorInTupleWithDestructure2();
    io:println(destructuredTuple2[0]); // @output 12
    io:println(destructuredTuple2[1]); // @output Bal
    io:println(destructuredTuple2[2]); // @output Err2
    io:println(destructuredTuple2[3]); // @output Something Wrong2
    io:println(destructuredTuple2[4]); // @output true
    var recordResult = testErrorInRecordWithDestructure();
    io:println(recordResult[0]); // @output 1000
    io:println(recordResult[1]); // @output Err3
    io:println(recordResult[2]); // @output Something Wrong3
    var anon = testErrorWithAnonErrorType();
    io:println(anon[0]); // @output Error Code
    io:println(anon[1]); // @output Fatal
    var underscore = testErrorWithUnderscore();
    io:println(underscore[0]); // @output Error Code
    io:println(underscore[1]); // @output Error Code
    io:println(underscore[2]); // @output Error One
    io:println(underscore[3]); // @output Error One
    io:println(underscore[4]); // @output Error Two
    io:println(underscore[5]); // @output Error Two
    io:println(underscore[6]); // @output Error Two
    io:println(underscore[7]); // @output Error Two
    io:println(underscore[8]); // @output Msg One
    io:println(underscore[9]); // @output Something Wrong
    io:println(underscore[10]); // @output Something Wrong
    var indirect = testIndirectErrorDestructuring();
    io:println(indirect[0]); // @output Msg
    io:println(indirect[1]); // @output false
    io:println(indirect[2]); // @output {"other":"k"}
    var sealed = testSealedDetailDestructuring();
    io:println(sealed[0]); // @output sealed
    io:println(sealed[1]); // @output {"message":"Msg"}
    var binding = testErrorBindingPattern();
    io:println(binding[0]); // @output Detail Info
    io:println(binding[1]); // @output true
    io:println(binding[2]); // @output {"A":"a","B":"b"}
    testLocalErrorType();
    testErrorBindingPatternWithErrorDeclaredWithReadOnlyIntersection();
}
