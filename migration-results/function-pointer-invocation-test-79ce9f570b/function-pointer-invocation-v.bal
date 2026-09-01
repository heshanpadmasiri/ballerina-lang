import ballerina/io;

public function main() {
    testFunctionPointerInvocation1();
    testFunctionPointerInvocation2();
    testFunctionPointerInvocation3();
    testFunctionPointerInvocation4();
    testFunctionPointerInvocation5();
}

function printValue(anydata value) {
    io:println(value);
}

function testFunctionPointerInvocation1() {
    string[] candidates = ["word", "word"];
    string word = "Word";
    var toKey = function (string w) returns int[] => w.toCodePointInts().sort();
    var lcWord = word.toLowerAscii();
    var key = toKey(lcWord);

    var x = from string candidate in candidates
        let string lcCand = candidate.toLowerAscii()
        where lcCand == lcWord && key == toKey(lcCand)
        select candidate;
    assertEquals(x, ["word", "word"]);

    var func1 = function () returns int[] => [1, 2];
    var y = from string _ in candidates
        select func1();
    assertEquals(y, [[1, 2], [1, 2]]);
}

function testFunctionPointerInvocation2() {
    var x = from string _ in ["A", "B", "C"]
        let function () returns int func2 = function () returns int => 23
        select func2();
    assertEquals(x, [23, 23, 23]);

    var y = from int _ in [1, 2, 3, 4]
        let function () returns int func2 = function () returns int => 23
        select function () returns int {
            int _ = func2();
            return 2;
        };
    function () returns int f1 = y[0];
    assertEquals(2, f1());

    var z = from int i in [1, 2, 3, 4]
        let function () returns (function () returns int) func = function () returns
            (function () returns int) => foo
        select function () returns int {
            function () returns int ff = func();
            int val = ff();
            return val + i;
        };
    f1 = z[0];
    assertEquals(22, f1());
}

function foo() returns int {
    return 21;
}

function testFunctionPointerInvocation3() {
    error? res1 = from var _ in [1, 2, 3, 4]
        do {
            function () returns int[] func = function () returns int[] {
                return from var i in [2] select i;
            };
            assertEquals([2], func());
        };
    assertEquals(true, res1 is ());

    var func1 = function () returns int[] => [1, 2];
    error? res2 = from var _ in [1, 2, 3, 4]
        do {
            int[] x = func1();
            assertEquals([1, 2], x);
        };
    assertEquals(true, res2 is ());
}

class Clz {
    int x = 0;
    function (string str) returns byte[] func = function (string str) returns byte[] => str.toBytes();

    public function foo(string[] candidates) returns int[][] {
        var x = from string candidate in candidates
            select self.func(candidate);
        return x;
    }
}

function testFunctionPointerInvocation4() {
    Clz clz = new;
    assertEquals([[97], [98]], clz.foo(["a", "b"]));
}

function testFunctionPointerInvocation5() {
    error? res1 = from var _ in [1, 2, 3, 4]
        do {
            function () returns int[] func = function () returns int[] {
                return from var i in [2] select i;
            };
            var a = from var x in func() select x;
            assertEquals([2], a);
        };
    assertEquals(true, res1 is ());
}

function assertEquals(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}
