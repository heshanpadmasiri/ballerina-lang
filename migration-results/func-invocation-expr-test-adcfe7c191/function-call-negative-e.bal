function testInvalidArgType() {
    string val = "sample";
    intArgTest(val); // @error
}

function intArgTest(int val) {
    string result = val.toString() + "abc";
}

function testUndefinedFunction() {
    foo(); // @error
}

private function testMyFunc() { // @error

}

function testInvalidArgsViaVararg() {
    var a = [1, true, false];
    [float, string...] b = [1.0, "str"];

    string s = bar(1, ...a); // @error
    int i = bar(1, ...["hello", false]); // @error

    _ = bar(1, false, ...[1, "world"]); // @error
    bar(...b); // @error

    baz(1, ...a); // @error
    baz(...b); // @error
}

function testInvalidIndividualArgsWithVararg() {
    boolean[] a = [true, false];

    _ = bar(i = 1, ...a); // @error

    _ = baz("str", ...a); // @error

    var fn = function () returns [boolean, boolean...] {
        return [true, false, false];
    };

    int i = bar(1, 1.0, ...fn()); // @error
}

function bar(int i, boolean... b) returns int {
    return i;
}

function baz(string s, float f = 2.0, boolean... b) {
}

function testInvalidArrayArg() {
    int[1] a = [1];
    int m = allInts(...a); // @error

    (int|string)[3] b = [1, 2, 3];
    int n = allInts(...b); // @error
    int o = intsWithStringRestParam(...b); // @error

    int[5] c = [1, 2, 3, 1, 2];
    int p = intParam(...c); // @error

    int[] d = [1, 1, 2, 2, 1];
    int q = intsWithStringRestParam(...c); // @error
    int r = intsWithStringRestParam(...d); // @error

    anydata[] e = [1, 2, 3, 4];
    int s = intRestParam(...b); // @error
    int t = intRestParam(...e); // @error
}

function allInts(int i, int j, int... k) returns int {
    int tot = i + j;
    foreach int x in k {
        tot += x;
    }
    return tot;
}

function intsWithStringRestParam(int i, int j, string... k) returns int {
    return 2 * (i + j + k.length());
}

function intRestParam(int... i) returns int {
     int tot = 0;
     foreach int x in i {
         tot += x;
     }
     return tot;
}

function intParam(int i) returns int => i;

function invalidNamedArg1() returns error {
     int[] y = [5,6];
     string x = "5";
     _ = int:sum(ns=y); // @error
     _ = int:sum(ss=y); // @error
     _ = check int:fromString(s=x);
     _ = check int:fromString(s=y); // @error
     _ = check int:fromString(ss=x); // @error
}

function testFuncWithNilReturnTypeWithoutVariableAssignment() {
    f1(); // @error
    f2(); // @error
    f3(); // @error
}

function f1() returns ()|int|() => ();
function f2() returns 1|null => null;
function f3() returns null|1|null => null;

function invalidRestParam() {
    int x = 1;
    func1(i = x); // @error
    func1(i = 2); // @error
    func2(x, i = x); // @error
    func2(t = x, i = x); // @error
}

function func1(int... i) {}

function func2(int t, int... i) {}
