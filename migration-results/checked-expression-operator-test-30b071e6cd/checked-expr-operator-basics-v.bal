import ballerina/io;
import ballerina/lang.value;

function openFileSuccess(string path) returns boolean|error => true;

function openFileFailure(string path) returns boolean|error => error("file not found error: " + path);

function testSafeAssignmentBasics1() returns boolean|error {
    boolean statusSuccess = check openFileSuccess("/home/sameera/foo.txt");
    return statusSuccess;
}

function testSafeAssignmentBasics2() {
    var f = function () returns error|boolean {
        boolean statusFailure = check openFileFailure("/home/sameera/bar.txt");
        return statusFailure;
    };
    validateError(f());
}

function testSafeAssignmentBasics3() returns error? {
    var f = function () returns error? {
        boolean statusFailure = check openFileFailure("/home/sameera/bar.txt");
        return ();
    };
    validateError(f());
}

function testSafeAssignmentBasics4() {
    var f = function () returns boolean|error {
        boolean statusFailure = check openFileFailure("/home/sameera/bar.txt");
        return statusFailure;
    };
    validateError(f());
}

function validateError(any|error e) {
    if e is error && e.message() == "file not found error: /home/sameera/bar.txt" {
        return;
    }
    panic error("Expected error");
}

function testSafeAssignOpInAssignmentStatement1() returns boolean|error {
    boolean b = false;
    b = check openFileSuccess("/home/sameera/foo.txt");
    return b;
}

function testSafeAssignOpInAssignmentStatement2() {
    var f = function () returns boolean|error {
        boolean b = false;
        b = check openFileFailure("/home/sameera/bar.txt");
        return b;
    };
    validateError(f());
}

type FileOpenStatus record { boolean status = false; };

function testSafeAssignOpInAssignmentStatement3() returns boolean|error {
    FileOpenStatus fos = {};
    fos.status = check openFileSuccess("/home/sameera/foo.txt");
    return fos.status;
}

function testSafeAssignOpInAssignmentStatement4() returns boolean|error {
    boolean[] ba = [];
    ba[0] = check openFileSuccess("/home/sameera/foo.txt");
    ba[1] = false;
    return ba[0];
}

function testSafeAssignOpInAssignmentStatement5() returns error? {
    var f = function () returns error? {
        boolean statusFailure;
        statusFailure = check openFileFailure("/home/sameera/bar.txt");
        return ();
    };
    validateError(f());
}

function testSafeAssignOpInAssignmentStatement6() returns boolean|error {
    var statusFailure = check openFileSuccess("/home/sameera/bar.txt");
    return statusFailure;
}

type Person record { string name; };
public type MyErrorData record {| string message?; error cause?; |};
type MyError error<MyErrorData>;
public type CustomErrorData record {| string data; string message?; error cause?; |};
type CustomError error<CustomErrorData>;

function getPerson() returns Person|MyError => {name: "Diayasena"};

function testSafeAssignOpInAssignmentStatement7() returns string|error {
    var p = check getPerson();
    return p.name;
}

function readLineError() returns string|MyError => error MyError("io error");
function readLineCustomError() returns string|CustomError => error CustomError("custom io error", data = "foo.txt");
function readLineSuccess() returns string|MyError => "Ballerina";

function testCheckExprInBinaryExpr1() returns error? {
    string str = "hello, " + check readLineError();
    return ();
}

function testCheckExprInBinaryExpr2() returns MyError? {
    string str = "hello, " + check readLineError();
    return ();
}

function testCheckExprInBinaryExpr3() returns string|MyError => "hello, " + check readLineSuccess();

function testCheckExprInBinaryExpr4() returns error {
    string str = "hello, " + check readLineError();
    return error("error");
}

function testCheckExprInBinaryExpr5() returns error? {
    string str = "hello, " + check readLineError();
    return ();
}

function testCheckExprInBinaryExpr6() returns string|CustomError => "hello, " + check readLineCustomError();

function readLineProper() returns string|MyError|CustomError => "Hello, World!!!";
function testCheckExprInBinaryExpr8() returns string|error => "hello, " + check readLineProper();

function foo(string s) returns string|CustomError => "(" + s + "|" + s + ")";
function bar(string s1, string s2) returns string|CustomError => s1 + " " + s2;

function testCheckedExprAsFuncParam1() returns string|error {
    return check bar(check bar(check foo(check foo(check foo(check foo("S")))), check foo(check foo("A"))),
        check bar(check foo(check foo(check foo("M"))), "done"));
}

function testCheckInBinaryAddExpression() returns int|error {
    int|error a = 10;
    int|error b = 20;
    return check a + check b;
}

function testCheckInBinaryDivExpression() returns int|error {
    int|error a = 10;
    int|error b = 20;
    return check b / check a;
}

function testCheckInBinaryLTExpression() returns boolean|error {
    int|error a = 10;
    int|error b = 20;
    return check b < check a;
}

function baz() returns boolean|error {
    value:Cloneable x = error("error one!");
    any y = check x;
    return true;
}

type CyclicUnion readonly|boolean[]|CyclicUnion[];
function corge(boolean bool) returns error|int {
    CyclicUnion x = bool ? error("error two!") : 1234;
    any y = check x;
    return y is int ? y : 0;
}

function testCheckedErrorsWithReadOnlyInUnion() {
    boolean|error x = baz();
    assertTrue(x is error);
    error errVal = <error>x;
    assertEquality("error one!", errVal.message());
    assertTrue(errVal.cause() is ());
    assertEquality(0, errVal.detail().length());
    int|error y = corge(true);
    assertTrue(y is error);
    errVal = <error>y;
    assertEquality("error two!", errVal.message());
    assertTrue(errVal.cause() is ());
    assertEquality(0, errVal.detail().length());
    y = corge(false);
    assertTrue(y is int);
    assertEquality(1234, checkpanic y);
}

type Err distinct error;
function emitError(int i) returns int|Err|error {
    match i {
        1 => { return 1; }
        2 => { return error Err("Err"); }
        _ => { return error("Any error"); }
    }
}

function performErrornousAction(int i) returns error? {
    int m = check emitError(i);
}

function testCheckWithMixOfDefaultErrorAndDistinctErrors() {
    var result = performErrornousAction(1);
    assertTrue(result is ());
    result = performErrornousAction(2);
    assertTrue(result is Err && result.message() == "Err");
}

float location1 = let var statusSuccess = check openFileSuccess("/home/sameera/foo.txt") in 3.33;
function testCheckInLetExpression() returns error? {
    float location = let var statusSuccess = check openFileSuccess("/home/sameera/foo.txt") in 5.33;
    assertEquality(5.33, location);
    assertEquality(3.33, location1);
}

function testCheckedExprWithNever() {
    error? e = checkingFunc();
    assertTrue(e is error && e.message() == "io error");
}

function checkingFunc() returns error? {
    check getErr();
}

function getErr() returns error => error("io error");
function assertTrue(anydata actual) => assertEquality(true, actual);
function assertEquality(anydata expected, anydata actual) {
    if expected == actual { return; }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    io:println(testSafeAssignmentBasics1()); // @output true
    testSafeAssignmentBasics2();
    error? ignoredBasics3 = testSafeAssignmentBasics3();
    testSafeAssignmentBasics4();
    io:println(testSafeAssignOpInAssignmentStatement1()); // @output true
    testSafeAssignOpInAssignmentStatement2();
    io:println(testSafeAssignOpInAssignmentStatement3()); // @output true
    io:println(testSafeAssignOpInAssignmentStatement4()); // @output true
    error? ignoredAssignment5 = testSafeAssignOpInAssignmentStatement5();
    io:println(testSafeAssignOpInAssignmentStatement6()); // @output true
    io:println(testSafeAssignOpInAssignmentStatement7()); // @output Diayasena
    error? binary1 = testCheckExprInBinaryExpr1();
    if binary1 is error { io:println(binary1.message()); } // @output io error
    MyError? binary2 = testCheckExprInBinaryExpr2();
    if binary2 is error { io:println(binary2.message()); } // @output io error
    io:println(testCheckExprInBinaryExpr3()); // @output hello, Ballerina
    io:println(testCheckExprInBinaryExpr4().message()); // @output io error
    error? binary5 = testCheckExprInBinaryExpr5();
    if binary5 is error { io:println(binary5.message()); } // @output io error
    string|CustomError binary6 = testCheckExprInBinaryExpr6();
    if binary6 is CustomError {
        io:println(binary6.message()); // @output custom io error
        io:println(binary6.detail().data); // @output foo.txt
    }
    io:println(testCheckExprInBinaryExpr8()); // @output hello, Hello, World!!!
    io:println(testCheckedExprAsFuncParam1()); // @output ((((S|S)|(S|S))|((S|S)|(S|S)))|(((S|S)|(S|S))|((S|S)|(S|S)))) ((A|A)|(A|A)) (((M|M)|(M|M))|((M|M)|(M|M))) done
    io:println(testCheckInBinaryAddExpression()); // @output 30
    io:println(testCheckInBinaryDivExpression()); // @output 2
    io:println(testCheckInBinaryLTExpression()); // @output false
    testCheckedErrorsWithReadOnlyInUnion();
    testCheckWithMixOfDefaultErrorAndDistinctErrors();
    error? ignoredLet = testCheckInLetExpression();
    testCheckedExprWithNever();
}
