function test1(int|string|true? x) {
    while x is int { int _ = x; break; }
    while x == true { true _ = x; break; }
    while x != true { int|string? _ = x; break; }
    while !(x == true) { int|string? _ = x; break; }
    while !(x == ()) { int|string|boolean _ = x; break; }
    int _ = x; // @error
}

function test2(int|string x, boolean|float y) {
    while x is int && y is float { int _ = x; float _ = y; }
    while x is int || y is float {
        int _ = x; // @error
        int|string _ = x;
        float _ = y; // @error
        float|boolean _ = y;
    }
    while true && x is int { int _ = x; }
    while !(true && x is int) { int _ = x; } // @error
    while true || x is int { int _ = x; } // @error
    while !(false || x is int) { string _ = x; }
}

function test3(int|string x) {
    while x is int { int _ = x; return; }
    string _ = x; // @error
}

type A record {| int i; |};
type B record {| string i; |};
function test7(A|B x) {
    while x !is A { B _ = x; } // @error
}
type C A|B;
function test8(C v) {
    while v !is B { A _ = v; } // @error
}

type V record {| int i; |};
type W record {| string s; |};
type X record {| int s; |};
type Y record {| float f; |};
function test16(V|W|X|Y v) {
    while !(v is V|W) { X|Y _ = v; } // @error
    while v !is V|W|X { Y _ = v; }
}
function test17([int]|[string] x) {
    while x !is [int] {
        [string] _ = x; // @error
        [int|string] _ = x;
        [int]|[string] _ = x;
    }
}
function test18(([int]|[string]) & readonly x) {
    while x !is [int] {
        [string] _ = x;
        [string] & readonly _ = x;
        [int] _ = x; // @error
    }
}
function test19(int[]|string[] x) {
    while x !is int[] {
        string[] _ = x; // @error
        (int|string)[] _ = x;
        int[]|string[] _ = x;
    }
}
function test20(int[] & readonly|string[] & readonly x) {
    while x !is int[] {
        string[] _ = x;
        int[] _ = x; // @error
        string[] & readonly _ = x;
    }
}
function test21() {
    int|boolean|string x = "x";
    while x !is int {
        do {
            if x is boolean { return; }
            string _ = x;
        }
        string _ = x; // @error
    }
    int|boolean|string y = "y";
    while y !is int {
        {
            if y is boolean { return; }
            string _ = y;
        }
        string _ = y; // @error
    }
}
