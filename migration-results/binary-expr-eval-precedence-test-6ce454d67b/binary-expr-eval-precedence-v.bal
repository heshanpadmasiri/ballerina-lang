import ballerina/io;

public function main() {
    io:println(binaryOrExprWithLeftMostSubExprTrue(true, false, false)); // @output true
    io:println(binaryOrExprWithLeftMostSubExprTrue(false, false, false)); // @output false
    io:println(binaryANDExprWithLeftMostSubExprFalse(false, false, false)); // @output false
    io:println(binaryANDExprWithLeftMostSubExprFalse(true, false, false)); // @output false
    io:println(multiBinaryORExpr(false, false, true)); // @output 101
    io:println(multiBinaryORExpr(false, false, false)); // @output 201
    io:println(multiBinaryANDExpr(true, true, true)); // @output 101
    io:println(multiBinaryANDExpr(true, false, false)); // @output 201
}

function binaryOrExprWithLeftMostSubExprTrue(boolean one, boolean two, boolean three) returns boolean {
    return one || getBoolean();
}

function binaryANDExprWithLeftMostSubExprFalse(boolean one, boolean two, boolean three) returns boolean {
    return one && getBoolean();
}

function multiBinaryORExpr(boolean one, boolean two, boolean three) returns int {
    if one || two || three {
        return 101;
    }
    return 201;
}

function multiBinaryANDExpr(boolean one, boolean two, boolean three) returns int {
    if one && two && three {
        return 101;
    }
    return 201;
}

function getBoolean() returns boolean {
    json j = {};
    string val;
    json|error jVal = j.isPresent;
    if jVal is error {
        val = jVal.toString();
    } else {
        val = jVal.toString();
    }
    return val == "test";
}
