import ballerina/io;

public function main() {
    testInvocationExpr();
    testNilLiteral();
    testVariableReference();
    testFieldAccessExpr();
    testMemberAccessExpr();
}

function testInvocationExpr() {
    error? e = checkingFunc1();
    io:println(e is error && e.message() == "msg1"); // @output true
    e = checkingFunc2();
    io:println(e is ()); // @output true
    e = checkingFunc3();
    io:println(e is error && e.message() == "msg3"); // @output true
}

function checkingFunc1() returns error? {
    check func1();
}

function func1() returns error? {
    return error("msg1");
}

function checkingFunc2() returns error? {
    check func2();
}

function func2() returns error? {
    return;
}

function checkingFunc3() returns error? {
    check func3();
}

function func3() returns error {
    return error("msg3");
}

function testNilLiteral() {
    check ();
}

function testVariableReference() {
    () n = ();
    check n;
    error? e1 = checkingFunc4();
    io:println(e1 is error && e1.message() == "msg4"); // @output true
    error? e2 = checkingFunc5();
    io:println(e2 is ()); // @output true
    error e3 = checkingFunc6();
    io:println(e3 is error && e3.message() == "msg6"); // @output true
}

function checkingFunc4() returns error? {
    error? e = error("msg4");
    check e;
}

function checkingFunc5() returns error? {
    error? e = ();
    check e;
}

function checkingFunc6() returns error {
    error e = error("msg6");
    check e;
    return error("new msg");
}

type REC1 record {
    () n;
};

type REC2 record {
    error? e;
};

function testFieldAccessExpr() {
    REC1 rec = { n: () };
    check rec.n;
    error? e = checkingFunc7();
    io:println(e is error && e.message() == "msg7"); // @output true
}

function checkingFunc7() returns error? {
    REC2 rec = { e: error("msg7") };
    check rec.e;
}

map<error> errMap = { "e1": error("msg8") };

function testMemberAccessExpr() {
    error? e = checkingFunc8();
    io:println(e is error && e.message() == "msg8"); // @output true
}

function checkingFunc8() returns error? {
    check errMap["e2"];
    check errMap["e1"];
}
