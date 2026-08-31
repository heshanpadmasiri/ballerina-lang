function testElvisValueTypeNested() returns int { int|() x = (); int|() y = 3000; int b; b = x ?: y ?: x; // @error
    return b; }
function testElvisValueTypeNotMatchingTypeWithRHS() returns int { int|() x = 120; int b; b = x ?: "string"; // @error
    return b; }
function testElvisValueTypeNotMatchingTypeWithLHS() returns int { string|() x = (); int b; b = x ?: 3; // @error
    return b; }
function testElvisAsArgumentNegative() { int[] a = []; int? b = 1; a.push(b ?: ""); // @error
    byte[] c = []; byte? d = (); c.push(d ?: 256); // @error
}

int? x1 = (); byte? y1 = 255; () z1 = (); var elvisOutput1 = x1 ?: y1 ?: z1; int v1 = elvisOutput1; // @error
int? x2 = (); int:Unsigned8? y2 = 255; int:Signed8? z2 = -128; var elvisOutput2 = x2 ?: y2 ?: z2; var elvisOutput3 = x2 ?: y2 ?: x1 ?: y1 ?: z2; int v2 = elvisOutput2; // @error
int v3 = elvisOutput3; // @error
decimal? x3 = (); float? y3 = 1.213123; int:Signed16? z3 = -128; var elvisOutput4 = x3 ?: y3 ?: z3; var elvisOutput5 = x3 ?: y3 ?: x2 ?: y2 ?: x1 ?: y1 ?: z3; int v4 = elvisOutput4; // @error
int v5 = elvisOutput5; // @error
int? x4 = (); string? y4 = (); string:Char? z4 = (); string[] z5 = ["a"]; var elvisOutput6 = x4 ?: y4 ?: z4 ?: z5; int v6 = elvisOutput6; // @error

function testNestedElvisNegative() {
    int? x5 = (); byte? y5 = (); () z6 = (); var elvisOutput7 = x5 ?: y5 ?: z6; int v7 = elvisOutput7; // @error
    int? x6 = (); int:Unsigned8? y6 = (); int:Signed8? z7 = -128; var elvisOutput8 = x6 ?: y6 ?: z7; var elvisOutput9 = x6 ?: y6 ?: x5 ?: y5 ?: z6; int v8 = elvisOutput8; // @error
    int v9 = elvisOutput9; // @error
    decimal? x7 = (); float? y7 = (); int:Signed8? z8 = -128; var elvisOutput10 = x7 ?: y7 ?: z8; var elvisOutput11 = x7 ?: y7 ?: x6 ?: y6 ?: x5 ?: y5 ?: z8; int v10 = elvisOutput10; // @error
    int v11 = elvisOutput11; // @error
    int? x8 = (); string? y8 = "b"; string:Char? z9 = "c"; string[] z10 = ["a"]; var elvisOutput12 = x8 ?: y8 ?: z9 ?: z10; int v12 = elvisOutput12; // @error
}

type T1 json;
function testElvisWithJsonNegative() { json resp = (); int _ = (resp.population?.value ?: 0) / 1000000; // @error
}
function testElvisWithJsonNegative2() { json a = {x: {y: 3, z: "a", t: true}}; int _ = (a.x?.y ?: 0) / 10; // @error
    string _ = (a.x?.z ?: "") + "b"; // @error
    boolean _ = (a.x?.t ?: true) && false; // @error
}
function testElvisWithJsonNegative3() { T1 resp = (); int _ = (resp.population?.value ?: 0) / 1000000; // @error
}
function testElvisWithJsonNegative4() { json a = (); any[] b = []; int _ = (a.x?.y ?: b) / 10; // @error
}
function testElvisWithJsonNegative5() { T1 a = (); any[] b = []; int _ = (a.x?.y ?: b) / 10; // @error
}

type NonOptionalType int[]|string;
function testInvalidElvisExpr(NonOptionalType i) { int[] _ = i ?: [1, 2]; // @error
    int[]|string j = "str"; int[] _ = j ?: [1, 2, 3]; // @error
}
function testElvisExprWithBuiltInNilableUnionNegative() {
    stream<int> str = new; json j1 = 1; json _ = j1 ?: xml `text`; // @error
    anydata _ = j1 ?: str; // @error
    anydata k1 = 12; anydata _ = k1 ?: str; // @error
    any l1 = 3; any l2 = l1 ?: error("Oops!"); // @error
    boolean|int|float|decimal|string|json[] _ = j1 ?: true; // @error
    boolean|int|float|decimal|string|xml|anydata[] _ = k1 ?: str; // @error // @error
}
function testElvisExprWithFiniteTypeWithNullNegative() {
    1|null|"foo" a = 1; int _ = a ?: 3; // @error
    string _ = a ?: ""; // @error
    "foo" _ = a ?: 1; // @error // @error
    null|1 b = (); 1 _ = b ?: 3; // @error
}
function testElvisExprWithNilSubTypeLhsExprType(() w, null|null x, ()|() y, never? z) {
    int _ = w ?: 2; // @error
    int _ = x ?: 2; // @error
    int _ = y ?: 2; // @error
    int _ = z ?: 2; // @error
}
