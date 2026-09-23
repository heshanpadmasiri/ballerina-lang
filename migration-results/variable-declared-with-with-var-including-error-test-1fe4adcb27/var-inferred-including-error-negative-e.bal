// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.

function foo() returns [int, int|error] => [1, 1];
var [x, y] = foo();
var a = y; // @error

var m = error("Error!"); // @error

function testVarInVarDeclWithTypeIncludingErrorNegative() {
    var [x1, y1] = foo(); // @error
    var a1 = y1; // @error

    var m1 = error("Error!"); // @error
}

error[] errs = let var e1 = error("one"), var e2 = error("two"), var e3 = [error("three")] in [e3[0]]; // @error // @error

function testVarInLetVarWithTypeIncludingErrorNegative() {
    error[] errs2 = let var e1 = error("one"), var e2 = {a: error("two")}, var e3 = error("three") in []; // @error // @error // @error // @error
}

type MyError error<record {error err;}>;

function baz() returns record {[error|boolean, int] q; error r; MyError s; int t;} =>
    {q: [error("four"), 1], r: error("five"), s: error MyError("five", err = error("six")), t: 101};

function testOnFailClauseWithError() {
    do {
        fail error("error!");
    } on fail var x { // @error

    }
}
