// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.

var [x, y] = foo();
function foo() returns [int, int|error] => [1, 1];

var [a, ...b] = bar();
function bar() returns [error, error...] => [error("one"), error("two"), error("three")];

var [x2, y2] = foo();

var [a2, ...b2] = bar();

var m = error("Error!");

function testVarInVarDeclWithTypeIncludingError() {
    var [x1, y1] = foo(); // @error

    var [a1, ...b1] = bar(); // @error

    var [x2, y2] = foo(); // @error // @error

    var [a2, ...b2] = bar(); // @error // @error

    var m1 = error("Error!");

    (any|error)[] arr = [y, a, m, y1, a1, m1]; // @error
}

error[] errs = let var e1 = error("one"), var e2 = error("two"), var e3 = [error("three")] in [e1, e2]; // @error

function testVarInLetVarWithTypeIncludingError() {
    error[] errs2 = let var e1 = error("one"), var e2 = {a: error("two")}, var e3 = error("three") in [e1, e3]; // @error // @error
}

type MyError error<record {error err;}>;

function baz() returns record {[error|boolean, int] q; error r; MyError s; int t;} =>
    {q: [error("four"), 1], r: error("five"), s: error MyError("five", err = error("six")), t: 101};

string str = let var {q: [e, i], r, s: error MyError(err = err), t} = baz() in // @error // @error // @error // @error
    (<error> e).message() + r.message() + err.message() + t.toString();
string str2 = let var {q: [e, i], r, s: error MyError(err = err), t} = baz() in t.toString(); // @error

function testVarInBindingPatternWithTypeIncludingError() {
    string str3 = let var {q: [e, i], r, s: error MyError(err = err), t} = baz() in // @error // @error
        (<error> e).message() + r.message() + err.message() + t.toString();
    string str4 = let var {q: [e, i], r, s: error MyError(err = err), t} = baz() in t.toString(); // @error // @error // @error // @error // @error
}

function testForEachLoopWithError() {
    foreach var e in errs { // @error

    }

    int tot = 0;
    foreach error e in errs { // @error
        tot += 1;
    }

    tot = 0;
    foreach var error(m, c) in errs { // @error // @error
        tot += 1;
    }
}

function testQueryExprsWithError() {
    error[] v = [error("a"), error("b")];

    int[] w = from var a in v // @error // @error
                select 1;

    error? x = from var error(m, c) in v // @error // @error // @error
                do {};

    error[] arr1 = [error("a"), error("b")];
    error[] arr2 = [error("a"), error("c")];

    int[] y = from var e1 in arr1 // @error // @error
                join var e2 in arr2 on true equals false // @error
                select 1;

    int val = 0;
    error? z = from var error(m1, c1) in arr1 // @error // @error // @error
                join var error(m2, c2) in arr2 on val equals 0 // @error // @error
                do {};
}

function testOnFailClauseWithError() {
    do {
        fail error("error!");
    } on fail var x {
        error y = x; // @error
    }
}

function testErrorUsedInAnonymousFunctions() {
    var e1 = error("");

    function () returns error _ = function () returns error {
        return e1;
    };

    var e2 = error("");

    function () returns error _ = () => e2;
}
