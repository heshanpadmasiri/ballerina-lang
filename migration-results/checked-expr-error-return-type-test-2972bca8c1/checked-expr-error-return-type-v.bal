import ballerina/io;

type E1 distinct error;
type E2 distinct error;

function foo(int state) returns int|E1|E2 {
    if state == 0 {
        return error E1("Custom Error E1");
    } else if state == 1 {
        return error E2("Custom Error E2");
    }
    return state;
}

function bar() returns error? {
    return error("Dummy error");
}

function checkedExprErrorReturnTypeWithOnFail(int state) returns int|error {
    do {
        if foo(state) == state {
            return check foo(state - 2);
        }
        return check foo(state);
    } on fail var e {
        return e;
    }
}

function testCheckedExprErrorReturnTypeWithOnFail() {
    io:println(checkedExprErrorReturnTypeWithOnFail(0) is E1); // @output true
    io:println(checkedExprErrorReturnTypeWithOnFail(1) is E2); // @output true
    io:println(checkedExprErrorReturnTypeWithOnFail(2) is E1); // @output true
    io:println(checkedExprErrorReturnTypeWithOnFail(3) is E2); // @output true
    io:println(checkedExprErrorReturnTypeWithOnFail(5) is int); // @output true
    io:println(checkedExprErrorReturnTypeWithOnFail(0) is E2); // @output false
    io:println(checkedExprErrorReturnTypeWithOnFail(1) is E1); // @output false
}

function checkedExprErrorReturnTypeWithNestedFailStmt(int state) returns int|error {
    do {
        if foo(state) == state {
            return check foo(state - 2);
        }
        return check foo(state);
    } on fail var e {
        check bar();
        return e;
    }
}

function testCheckedExprErrorReturnTypeWithNestedFailStmt() {
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(0) is error); // @output true
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(1) is error); // @output true
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(5) is int); // @output true
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(0) is E1); // @output false
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(0) is E2); // @output false
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(1) is E1); // @output false
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(1) is E2); // @output false
    io:println(checkedExprErrorReturnTypeWithNestedFailStmt(5) is error); // @output false
}

public function main() {
    testCheckedExprErrorReturnTypeWithOnFail();
    testCheckedExprErrorReturnTypeWithNestedFailStmt();
}
