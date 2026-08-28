const R1 = "first reason";
const R2 = "second reason";

type E1 distinct error;
type E2 distinct error;

function foo() returns E1? {
    int _ = check bar(); // @error
}

function bar() returns int|E2 {
    return error E2(R1);
}

public function main() {
    E1? x = foo(); // @error
}

public function baz() {
    worker w1 returns error? {
        if (0 < 1) {
            return error("generic error");
        }

        5 -> w2;
    }

    worker w2 returns E1? {
        int _ = check <- w1; // @error
    }

    E1? res = wait w2; // @error
}

type LhsErr distinct error;
type LhsErrTwo distinct error;

public function fooBar() returns LhsErr? {
    int|LhsErrTwo x = check fbar(); // @error @error
    int y = check fFoo(); // @error @error
    int|LhsErr z = check fFoo(); // @error @error
    int|LhsErrTwo q = check fFoo(); // @error @error
}

function fbar() returns int|error {
    return error("");
}

function fFoo() returns LhsErrTwo|int {
    return error("");
}

function testCheckedExprWithNoErrorType1() {
    int|error i = 10;
    int _ = check i; // @error
}

function testCheckedExprWithNoErrorType2() {
    int|error i = 10;
    int _ = getInt(check i) + check i; // @error @error
}

function getInt(int x) returns int {
    return x + 1;
}

function testCheckedExprWithNoErrorType3() {
    int|error i = error("Error");
    int _ = check i; // @error
}

function testOnFailWithCheckInLambdaFunction() {
    function _ = function() {
        do {
            function _ = function() {
                string _ = check getVal(""); // @error
            };
        } on fail {
        }
    };
}

function getVal(string str) returns string|error {
    return "";
}

function testOnFailWithCheckInWorkers() {
    string[] s = [];
    worker A {
        s.forEach(function(string k) {
            string _ = check getVal2(); // @error
        });
    } on fail {
    }
}

function getVal2() returns string|error {
    return "";
}
