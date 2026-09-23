function testBasicNegative0() {
    [string, int, float] [s, i, f] = ["D", 4, 6.7];
    [s, i, f] = ["FFF", 345, 6.77, "EFEFE"]; // @error
}
function testBasicNegative1() {
    [string, int, NoFillerObject] [s, i, f] = ["D", 4, new(6)];
    [s, i, f] = ["FFF", 345]; // @error
}
function testBasicNegative2() {
    [string, int, float] [s, i, f] = ["D", 4, 6.7];
    [s, i, f] = [22, "WWWW", true]; // @error
}
function testBasicNegative3() {
    [string, int, float] [s, i, f] = ["D", 4, 6.7];
    [s, i, f, e] = [22, "Test", true, 4444]; // @error
}
function testBasicNegative4() {
    [string, int, float] [s, i, f] = ["D", 4, 6.7];
    [s, i, f] = ["FFF", 345, 6.77];
    [int, string] [s, i] = [4, "SSSS"]; // @error
}
function testVarRefNegative1() {
    [string, int, float] [s1, i1, f1] = ["D", 4, 6.7];
    s1 = 45; // @error
    i1 = "DDD"; // @error
    f1 = true; // @error
}
function fn0() returns [float, boolean, int] { return [5.6, true, 444]; }
function testVarRefNegative2() {
    [string, int, float] [s1, i1, f1] = ["D", 4, 6.7];
    [s1, i1, f1] = fn0(); // @error
}
function testVarRefNegative3() {
    [string, int, float] [s1, i1, f1] = ["D", 4, 6.7];
    [s1, i1] = [12, "FF"]; // @error
    f1 = true; // @error
}

type Foo record { string name; int age; };
type Bar record { int id; boolean flag; };
class FooObj { public string s; public float f; public byte b; function init(string s, float f, byte b) { self.s = s; self.f = f; self.b = b; } }
class BarObj { public boolean b; public int i; function init(boolean b, int i) { self.b = b; self.i = i; } }
function testVarRefNegative4() {
    Foo foo = {name:"Test", age:23}; Bar bar = {id:34, flag:true}; FooObj fooObj = new ("Fooo", 3.7, 23); BarObj barObj = new (true, 56);
    [[Foo, [BarObj, FooObj]], Bar] [[f, [bo, fo]], b] = [[foo, [barObj, fooObj]], bar];
    [[f, [bo, fo]], b] = [[bar, [fooObj, barObj]], foo]; // @error
}
function testVarRefNegative5() {
    Foo foo = {name:"Test", age:23}; Bar bar = {id:34, flag:true}; FooObj fooObj = new ("Fooo", 3.7, 23); BarObj barObj = new (true, 56);
    [[Foo, [BarObj, FooObj]], Bar] [[f, [bo, fo]], b] = [[foo, [barObj, fooObj]], bar];
    [f, [bo, fo], b] = [bar, fooObj, foo]; // @error
}
function testVarRefNegative6() {
    Foo foo = {name:"Test", age:23}; Bar bar = {id:34, flag:true}; FooObj fooObj = new ("Fooo", 3.7, 23); BarObj barObj = new (true, 56);
    [int, Foo, [BarObj, string, FooObj], Bar, boolean] [i, fr, [bo, s, fo], br, b] = [12, foo, [barObj, "DDD", fooObj], bar, true];
    [i, fr, [bo, s, fo], br, b] = [bar, 12, [fooObj, "DD", barObj], foo, true]; // @error
}
function testInvalidTupleVarDef1() {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = [["Bal", [3, [true, 34]]], [5.6, 45]];
    [[string, [int, [boolean, int]]], [float, int]] t = [["Bal", [3, [true, 34]]], [5.6, 45]];
    any a = t;
    [[s, [i1, [b, y]]], [f, i2]] = a; // @error
}
function testInvalidTupleVarDef2() returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = [["Bal", [3, [true, 34]]], [5.6, 45]];
    [[string, [int, [boolean, int]]], [float, int]] t = [["Bal", [3, [true, 34]]], [5.6, 45]];
    any a = t;
    [[s, [i1, [b, y]]], [f, i2]] = fn1(a); // @error
    return [s, i1, b, y, f, i2];
}
function fn1(any t) returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = t; // @error
    return [s, i1, b, y, f, i2];
}
function testFieldAndIndexBasedVarRefs() returns [anydata, anydata] {
    [int, [string, boolean]] t1 = [2002, ["S1", true]]; map<anydata> m = {};
    [m["var1"], [m["var2"], _]] = t1; // @error
    return [m["var1"], m["var2"]];
}
class NoFillerObject { function init(int i) {} }
function testIncompatibleTypesWithRest() {
    [int, string, boolean...] a1 = [12, "ABC", false, true, false]; var [a, ...b] = a1;
    boolean[] x = b; // @error
    var [...c] = a1;
    [int, string, string] y = c; // @error
}
function testSelfReferencingVariables() {
    [int, int] [a, b] = [a, b]; // @error
    [[string, int], float] [[c, d], e] = [[c, d], 6.7]; // @error
    [any[], float] [f, g] = [[f, 4], 6.7]; // @error
    [[string, [int, [boolean, string], float[]], int[]], float] [[h, [i, [j, k], l], m], n] = [["A", [i, [j, "B"], l], m], n]; // @error
}
type ReadOnlyTuple readonly & [int[], string];
function testReadOnlyTupleWithListBindingPatternInDestructuringAssignmentNegative() {
    ReadOnlyTuple t1 = [[1, 2], "s1"]; string[] & readonly a; string b;
    [a, b] = t1; // @error
    readonly & [int[], ReadOnlyTuple] t2 = [[12, 34, 56], t1]; readonly & string[] c; readonly & int[] d;
    [c, [d, _]] = t2; // @error
    int[] arr = []; d = arr; // @error
}
function testInvalidTupleVarRefWithMismatchingTypes() {
    [int, int] a = [10, 20]; var [a1, a2, ...a3] = a; // @error
    [[int, string], int[]] b = [[10, "a"], [20, 30, 40, 50]]; var [b1, b2, ...b3] = b; // @error
    [[int, string], int[]] c = [[10, "a"], [20, 30, 40, 50]]; var [[c1, c2, ...c3], c4] = c; // @error
}
