import ballerina/io;

public function main() {
    io:println(testTernaryTypeNarrow()); // @output true
}

function testTernaryTypeNarrow() returns boolean { test1(); test2({i: 2}, {j: "s"}, {i: "s"}); return true; }
function test1() {
    int|string? x = 1; _ = x is int ? intFn(x) : stringOptFn(x);
    int|string|boolean y = 1; _ = y is string ? stringFn(y) : (y is int ? intFn(y) : booleanFn(y)); _ = y !is string ? (y is int ? intFn(y) : booleanFn(y)) : stringFn(y);
    true|false? z = true; _ = z == true ? trueFn(z) : (z == false ? falseFn(z) : nilFn(z)); _ = !(z != true) ? trueFn(z) : (z != false ? nilFn(z) : falseFn(z));
    int? a = 3; _ = a != () ? a : nilFn(a);
}
type A record {| int i; |}; type B record {| string i; |}; type C record {| string j; |};
function aFn(A x) {} function bFn(B x) {} function cFn(C x) {} function abFn(A|B x) {}
function test2(A|B x, A|C y, B|C z) { _ = x is A ? aFn(x) : abFn(x); _ = y is A ? aFn(y) : cFn(y); _ = z is B ? bFn(z) : cFn(z); }
function intFn(int x) {} function stringFn(string x) {} function stringOptFn(string? x) {} function booleanFn(boolean x) {} function trueFn(true x) {} function falseFn(false x) {} function nilFn(() x) {}
