import ballerina/io;
import ballerina/lang.'value;

const MSG = "Message";

function errorConstructorExpr1() returns error {
    return error("Message");
}

function testErrorConstructorExpr1() {
    error e = errorConstructorExpr1();
    io:println(e.message()); // @output Message
}

function errorConstructorExpr2() returns error {
    return error("Message");
}

function testErrorConstructorExpr2() {
    error e = errorConstructorExpr2();
    io:println(e.message()); // @output Message
}

function errorConstructorExpr3() returns error {
    return error("Message1", error("Message2"));
}

function testErrorConstructorExpr3() {
    error e = errorConstructorExpr3();
    io:println(e.message()); // @output Message1
    error? eCause = e.cause();
    if eCause is error {
        io:println(eCause.message()); // @output Message2
    }
}

function errorConstructorExpr4() returns error {
    return error("Message1", error("Message2", error("Message3")));
}

function testErrorConstructorExpr4() {
    error e = errorConstructorExpr4();
    error? eCause = e.cause();
    if eCause is error {
        error? erCause = <error?> eCause.cause();
        if erCause is error {
            io:println(erCause.message()); // @output Message3
        }
    }
}

function errorConstructorExpr5() returns error {
    return error("Message1", c = 200, d = 300);
}

function testErrorConstructorExpr5() {
    error e = errorConstructorExpr5();
    map<value:Cloneable> m = e.detail();
    io:println(<int> checkpanic m["c"]); // @output 200
    io:println(<int> checkpanic m["d"]); // @output 300
}

function errorConstructorExpr6() returns error {
    return error("Message1", error("Message2", a = 100, b = "400"), c = 200, d = 300);
}

function testErrorConstructorExpr6() {
    error e = errorConstructorExpr6();
    e = <error> e.cause();
    map<value:Cloneable> m = e.detail();
    io:println(<int> checkpanic m["a"]); // @output 100
    io:println(<string> checkpanic m["b"]); // @output 400
    io:println(<int?> checkpanic m["c"]); // @output
}

type MyError2 error<map<string>>;

function errorConstructorExpr8() returns MyError2 {
    return error MyError2("Message1", a = "str1", b = "str2");
}

function testErrorConstructorExpr8() {
    MyError2 e = errorConstructorExpr8();
    io:println(<string> e.detail()["a"]); // @output str1
    io:println(<string> e.detail()["b"]); // @output str2
}

function errorConstructorExpr9() returns error {
    return error("Message", ());
}

function testErrorConstructorExpr9() {
    error e = errorConstructorExpr9();
    io:println(e.cause() is ()); // @output true
}

type AppError distinct error<record { int code; }>;
type CodeError distinct error<record { int no; }>;
type AppCodeError AppError & CodeError;
type MyError error<record {| byte code; |}>;

function testContextuallyExpectedErrorCtor() {
    AppError e = error("message", code = 2);
    error eDash = e;
    io:println(eDash is AppError); // @output true

    AppCodeError ace = error("message", code = 3, no = 1);
    io:println(ace.message()); // @output message
    io:println(ace.detail().code); // @output 3
    io:println(ace.detail().no); // @output 1

    var eTuple = getError(error("message", code = 22));
    io:println(eTuple[0].detail().code); // @output 22
    io:println(eTuple[1].detail().no); // @output 2
    io:println(eTuple[2][0].detail().code); // @output 0
    io:println(eTuple[2][0].detail().no); // @output 0

    AppError|CodeError|AppCodeError|int|map<string> u = error("msg", code = 100);
    io:println(u is AppError); // @output true
    if u is AppError {
        io:println(u.detail().code); // @output 100
    }

    u = error("msg", no = 100);
    io:println(u is CodeError); // @output true
    if u is CodeError {
        io:println(u.detail().no); // @output 100
    }

    readonly r = error("msg", code = 100, no = 100);
    if r is error {
        var code = r.detail()["code"];
        var no = r.detail()["no"];
        if code is anydata && no is anydata {
            io:println(code); // @output 100
            io:println(no); // @output 100
        } else {
            panic error("Invalid State");
        }
    } else {
        panic error("Invalid state: expected `error` found + `" + (typeof r).toString() + "`");
    }

    MyError x = error MyError("error!", code = 1);
    anydata code = x.detail().code;
    if !(code is byte) {
        panic error("Expected byte, found: " + (typeof code).toString());
    }
}

function getError(AppError ae) returns [AppError, CodeError, AppCodeError[]] {
    return [ae, error("msg", no = 2), [error("m", code = 0, no = 0)]];
}

public function main() {
    testErrorConstructorExpr1();
    testErrorConstructorExpr2();
    testErrorConstructorExpr3();
    testErrorConstructorExpr4();
    testErrorConstructorExpr5();
    testErrorConstructorExpr6();
    testErrorConstructorExpr8();
    testErrorConstructorExpr9();
    testContextuallyExpectedErrorCtor();
}
