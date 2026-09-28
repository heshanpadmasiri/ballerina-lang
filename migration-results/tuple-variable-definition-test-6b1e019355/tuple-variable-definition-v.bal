import ballerina/io;

type Foo record {
    string name;
    int age;
};

type Bar record {
    int id;
    boolean flag;
};

class FooObj {
    public string s;
    public float f;
    public byte b;
    public function init(string s, float f, byte b) {
        self.s = s;
        self.f = f;
        self.b = b;
    }
}

class BarObj {
    public boolean b;
    public int i;
    public function init(boolean b, int i) {
        self.b = b;
        self.i = i;
    }
}

function testBasic() returns [string, int, float] {
    [string, int, float] [s, i, f] = ["Fooo", 4, 6.7];
    return [s, i, f];
}

function testBasicRecursive1() returns [string, int, float] {
    [[string, int], float] [[s, i], f] = [["Fooo", 4], 6.7];
    return [s, i, f];
}

function testBasicRecursive2() returns [string, int, boolean, float] {
    [[string, int], [boolean, float]] [[s, i], [b, f]] = [["Fooo", 34], [true, 6.7]];
    return [s, i, b, f];
}

function testComplexRecursive() returns [string, int, boolean, byte, float, int] {
    [[string, [int, [boolean, byte]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] =
        [["Bal", [3, [true, 34]]], [5.6, 45]];
    return [s, i1, b, y, f, i2];
}

function testRecursiveWithExpression() returns [string, int, boolean, byte, float, int] {
    [[string, [int, [boolean, byte]]], [float, int]] a = [["Bal", [3, [true, 34]]], [5.6, 45]];
    [[string, [int, [boolean, byte]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = a;
    return [s, i1, b, y, f, i2];
}

function testTupleBindingWithRecordsAndObjects1() returns [string, int, int, boolean, string, float, byte, boolean, int] {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [[Foo, [BarObj, FooObj]], Bar] [[f, [bo, fo]], b] = [[foo, [barObj, fooObj]], bar];
    return [f.name, f.age, b.id, b.flag, fo.s, fo.f, fo.b, bo.b, bo.i];
}

function testTupleBindingWithRecordsAndObjects2() returns [string, string, int, int, boolean, string, float, byte, boolean, int, int] {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [string, [Foo, [BarObj, FooObj]], [Bar, int]] [s, [f, [bo, fo]], [b, i]] =
        [foo.name, [foo, [barObj, fooObj]], [bar, barObj.i]];
    return [s, f.name, f.age, b.id, b.flag, fo.s, fo.f, fo.b, bo.b, bo.i, i];
}

function testRecordInsideTuple() returns [string, int, boolean] {
    [string, Foo, boolean] [a, {name, age: theAge}, b] = ["Peter", {name: "Parker", age: 12}, true];
    string fullName = a + " " + name;
    return [fullName, theAge, b];
}

function testTupleVarDef1() returns [string, int, boolean] {
    [string, [int, boolean]] [a, [b, c]] = ["Ballerina", [123, true]];
    return [a, b, c];
}

function testTupleVarDef2() returns [string, int, int, boolean, string, float, byte, boolean, int] {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [[Foo, [BarObj, FooObj]], Bar] [[f, [bo, fo]], b] = [[foo, [barObj, fooObj]], bar];
    return [f.name, f.age, b.id, b.flag, fo.s, fo.f, fo.b, bo.b, bo.i];
}

function testTupleVarDef3() {
    [int, record {boolean e; string f;}] [x, y] = [1, {e: true, f: "chiran"}];
    assertEquality(1, x);
    assertEquality(true, y.e);
    assertEquality("chiran", y.f);
}

function testTupleVarDef4() {
    [int, record { boolean e; string f; }] [d, {e, ...f}] = [1, {e: true, f: "str"}];
    assertEquality(1, d);
    assertEquality(true, e);
    assertEquality("str", f["f"]);
}

function testTupleVarDefWithArray1() returns [string, int[], boolean, float[]] {
    [string, [int[], [boolean, float[]]]] [a, [b, [c, d]]] = ["Ballerina", [[123, 345], [true, [2.3, 4.5]]]];
    return [a, b, c, d];
}

function testTupleVarDefWithArray2() returns [string[], int[], boolean[], float[]] {
    [string[], [int[], [boolean[], float[]]]] [a, [b, [c, d]]] =
        [["A", "B"], [[123, 345], [[true, false], [2.3, 4.5]]]];
    return [a, b, c, d];
}

function testTupleVarDefWithArray3() returns [string[][], int[][], float[]] {
    [string[][], [int[][], float[]]] [a, [b, c]] =
        [[["A", "B"], ["C", "D"]], [[[123, 345], [12, 34, 56]], [2.3, 4.5]]];
    return [a, b, c];
}

function testTupleVarDefWithArray4() returns [string[][], int[][], float[]] {
    [string[][], [int[][], float[]]] [a, [b, c]] =
        [[["A", "B"], ["C", "D"]], [[[123, 345], [12, 34, 56]], [2.3, 4.5]]];
    return [a, b, c];
}

function testRecursiveExpressionWithVar1() returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] =
        [["Bal", [3, [true, 34]]], [5.6, 45]];
    return [s, i1, b, y, f, i2];
}

function testRecursiveExpressionWithVar2() returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] t = [["Bal", [3, [true, 34]]], [5.6, 45]];
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = t;
    return [s, i1, b, y, f, i2];
}

function fn1([[string, [int, [boolean, int]]], [float, int]] t) returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = t;
    return [s, i1, b, y, f, i2];
}

function testRecursiveExpressionWithVar3() returns [string, int, boolean, int, float, int] {
    return fn1([["Bal", [3, [true, 34]]], [5.6, 45]]);
}

function testRecursiveExpressionWithVar4() returns [string, int, boolean, int, float, int] {
    return fn1([["Bal", [3, [true, 34]]], [5.6, 45]]);
}

function testVarDefWithUnionType1() returns [string|int|float, string|float, string] {
    [string|int|float, [string|float, string]] [a, [b, c]] = [34, [6.7, "Test"]];
    return [a, b, c];
}

function testVarDefWithUnionType2() returns [string|int|float, string|float, string] {
    string|int|float v1 = 34;
    string|float v2 = 6.7;
    string v3 = "Test";
    [string|int|float, [string|float, string]] [a, [b, c]] = [v1, [v2, v3]];
    return [a, b, c];
}

function testVarDefWithUnionType3() returns [string|int|float, string|float, string] {
    [string|int|float, [string|float, string]] [a, [b, c]] = fn2();
    return [a, b, c];
}

function fn2() returns [string|int|float, [string|float, string]] {
    [string|int|float, [string|float, string]] v = [34, [6.7, "Test"]];
    return v;
}

function testVarDefWithUnionType4() returns [[string|int, int|boolean], float|[int, boolean], [string|float, string]] {
    [[string|int, int|boolean], float|[int, boolean], [string|float, string]] [[a, b], c, [d, e]] =
        [["Test", 23], 4.5, [5.7, "Foo"]];
    return [[a, b], c, [d, e]];
}

function fn3() returns [[string|int, int|boolean], float|[int, boolean], [string|float, string]] {
    [[string|int, int|boolean], float|[int, boolean], [string|float, string]] [[a, b], c, [d, e]] =
        [["Test", 23], 4.5, [5.7, "Foo"]];
    return [[a, b], c, [d, e]];
}

function testVarDefWithUnionType5() returns [[string|int, int|boolean], float|[int, boolean], [string|float, string]] {
    [[string|int, int|boolean], float|[int, boolean], [string|float, string]] [[a, b], c, [d, e]] = fn3();
    return [[a, b], c, [d, e]];
}

function testVarDefWithUnionType6() returns [int|float|string, int|boolean|string] {
    [string, int]|[int, boolean]|[float, string] [a, b] = ["Test", 23];
    return [a, b];
}

function testIgnoreVariable() returns [int, int] {
    [string, int] [_, a] = ["Test", 23];
    [string, [int, boolean]] [_, [b, _]] = ["Test", [24, true]];
    return [a, b];
}

type myErrorDetail record { int i; };

function testTupleVariableWithErrorBP() {
    [error<myErrorDetail>, [int, string]] [error(m, i = i, ...k), [p, n]] = [error("err", i = 1), [1, ""]];
    assertEquality(m, "err");
    assertEquality(i, 1);
    assertEquality(k, k);
    assertEquality(p, 1);
    assertEquality(n, "");
}

type T [int, int];

function testTupleVarDeclWithTypeReferenceTypedExpr() {
    T t = [1, 2];
    var [a, b] = t;
    assertEquality(1, a);
    assertEquality(2, b);
}

function testTupleVarDefWithRestBPContainsErrorBPWithNamedArgs() {
    [error<record {int a;}>, boolean...] [error(a = a), ...b] = [error("errorMsg", a = 6), true];
    assertEquality(6, a);
    assertEquality(true, b[0]);
}

function testTupleVarDefWithRestBPContainsErrorBPWithRestBP() {
    [error<record {|int...; |}>, boolean...] [error(...rest), ...b] = [error("errorMsg", a = 7), true];
    assertEquality(7, rest["a"]);
    assertEquality(true, b[0]);
}

type ReadOnlyTuple readonly & [int[], string];

function testReadOnlyListWithListBindingPatternInVarDecl() {
    ReadOnlyTuple t1 = [[1, 2], "s1"];
    ReadOnlyTuple [a, b] = t1;
    int[] & readonly rArr = a;
    assertEquality(<int[]> [1, 2], a);
    assertEquality(<int[]> [1, 2], rArr);
    string str = b;
    assertEquality("s1", b);
    assertEquality("s1", str);
    ReadOnlyTuple t2 = [[3], "s2"];
    var [c, d] = t2;
    rArr = c;
    assertEquality(<int[]> [3], c);
    assertEquality(<int[]> [3], rArr);
    str = d;
    assertEquality("s2", d);
    assertEquality("s2", str);
    readonly & [int[], ReadOnlyTuple] r = [[12, 34, 56], t1];
    var [e, f] = r;
    readonly & int[] a1 = e;
    assertEquality(<int[]> [12, 34, 56], a1);
    ReadOnlyTuple b1 = f;
    assertEquality(<ReadOnlyTuple> [[1, 2], "s1"], b1);
}

function getPersonDetails() returns PersonDetails {
    PersonDetails details = [{name: "Jack", married: true}, 10];
    return details;
}

type PersonDetails [record {|
    string name;
    boolean married;
|}, int];

function testTupleVariableWithAnonymousRecordType() {
    [record {|
        string name;
        boolean married;
    |}, int] [{name, married}, age] = checkpanic getPersonDetails().ensureType();
    assertEquality("Jack", name);
    assertEquality(true, married);
    assertEquality(10, age);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any expected, any actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    panic error(ASSERTION_ERROR_REASON,
                message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    var r = testBasic();
    io:println(r.length()); // @output 3
    io:println(r[0]); // @output Fooo
    io:println(r[1]); // @output 4
    io:println(r[2]); // @output 6.7
    r = testBasicRecursive1();
    io:println(r.length()); // @output 3
    io:println(r[0]); // @output Fooo
    io:println(r[1]); // @output 4
    io:println(r[2]); // @output 6.7
    var r2 = testBasicRecursive2();
    io:println(r2.length()); // @output 4
    io:println(r2[0]); // @output Fooo
    io:println(r2[1]); // @output 34
    io:println(r2[2]); // @output true
    io:println(r2[3]); // @output 6.7
    var r3 = testComplexRecursive();
    io:println(r3.length()); // @output 6
    io:println(r3[0]); // @output Bal
    io:println(r3[1]); // @output 3
    io:println(r3[2]); // @output true
    io:println(r3[3]); // @output 34
    io:println(r3[4]); // @output 5.6
    io:println(r3[5]); // @output 45
    r3 = testRecursiveWithExpression();
    io:println(r3.length()); // @output 6
    io:println(r3[0]); // @output Bal
    io:println(r3[1]); // @output 3
    io:println(r3[2]); // @output true
    io:println(r3[3]); // @output 34
    io:println(r3[4]); // @output 5.6
    io:println(r3[5]); // @output 45
    var r9 = testTupleBindingWithRecordsAndObjects1();
    io:println(r9.length()); // @output 9
    io:println(r9[0]); // @output Test
    io:println(r9[1]); // @output 23
    io:println(r9[2]); // @output 34
    io:println(r9[3]); // @output true
    io:println(r9[4]); // @output Fooo
    io:println(r9[5]); // @output 3.7
    io:println(r9[6]); // @output 23
    io:println(r9[7]); // @output true
    io:println(r9[8]); // @output 56
    var r11 = testTupleBindingWithRecordsAndObjects2();
    io:println(r11.length()); // @output 11
    io:println(r11[0]); // @output Test
    io:println(r11[1]); // @output Test
    io:println(r11[2]); // @output 23
    io:println(r11[3]); // @output 34
    io:println(r11[4]); // @output true
    io:println(r11[5]); // @output Fooo
    io:println(r11[6]); // @output 3.7
    io:println(r11[7]); // @output 23
    io:println(r11[8]); // @output true
    io:println(r11[9]); // @output 56
    io:println(r11[10]); // @output 56
    var r4 = testRecordInsideTuple();
    io:println(r4.length()); // @output 3
    io:println(r4[0]); // @output Peter Parker
    io:println(r4[1]); // @output 12
    io:println(r4[2]); // @output true
    r4 = testTupleVarDef1();
    io:println(r4.length()); // @output 3
    io:println(r4[0]); // @output Ballerina
    io:println(r4[1]); // @output 123
    io:println(r4[2]); // @output true
    r9 = testTupleVarDef2();
    io:println(r9.length()); // @output 9
    io:println(r9[0]); // @output Test
    io:println(r9[1]); // @output 23
    io:println(r9[2]); // @output 34
    io:println(r9[3]); // @output true
    io:println(r9[4]); // @output Fooo
    io:println(r9[5]); // @output 3.7
    io:println(r9[6]); // @output 23
    io:println(r9[7]); // @output true
    io:println(r9[8]); // @output 56
    testTupleVarDef3();
    testTupleVarDef4();
    var a1 = testTupleVarDefWithArray1();
    io:println(a1.length()); // @output 4
    io:println(a1[0]); // @output Ballerina
    io:println(a1[1][0]); // @output 123
    io:println(a1[1][1]); // @output 345
    io:println(a1[2]); // @output true
    io:println(a1[3][0]); // @output 2.3
    io:println(a1[3][1]); // @output 4.5
    var a2 = testTupleVarDefWithArray2();
    io:println(a2.length()); // @output 4
    io:println(a2[0][0]); // @output A
    io:println(a2[0][1]); // @output B
    io:println(a2[1][0]); // @output 123
    io:println(a2[1][1]); // @output 345
    io:println(a2[2][0]); // @output true
    io:println(a2[2][1]); // @output false
    io:println(a2[3][0]); // @output 2.3
    io:println(a2[3][1]); // @output 4.5
    var a3 = testTupleVarDefWithArray3();
    io:println(a3.length()); // @output 3
    io:println(a3[0][0][0]); // @output A
    io:println(a3[0][0][1]); // @output B
    io:println(a3[0][1][0]); // @output C
    io:println(a3[0][1][1]); // @output D
    io:println(a3[1][0][0]); // @output 123
    io:println(a3[1][0][1]); // @output 345
    io:println(a3[1][1][0]); // @output 12
    io:println(a3[1][1][1]); // @output 34
    io:println(a3[1][1][2]); // @output 56
    io:println(a3[2][0]); // @output 2.3
    io:println(a3[2][1]); // @output 4.5
    a3 = testTupleVarDefWithArray4();
    io:println(a3.length()); // @output 3
    io:println(a3[0][0][0]); // @output A
    io:println(a3[0][0][1]); // @output B
    io:println(a3[0][1][0]); // @output C
    io:println(a3[0][1][1]); // @output D
    io:println(a3[1][0][0]); // @output 123
    io:println(a3[1][0][1]); // @output 345
    io:println(a3[1][1][0]); // @output 12
    io:println(a3[1][1][1]); // @output 34
    io:println(a3[1][1][2]); // @output 56
    io:println(a3[2][0]); // @output 2.3
    io:println(a3[2][1]); // @output 4.5
    var r6 = testRecursiveExpressionWithVar1();
    io:println(r6.length()); // @output 6
    io:println(r6[0]); // @output Bal
    io:println(r6[1]); // @output 3
    io:println(r6[2]); // @output true
    io:println(r6[3]); // @output 34
    io:println(r6[4]); // @output 5.6
    io:println(r6[5]); // @output 45
    r6 = testRecursiveExpressionWithVar2();
    io:println(r6.length()); // @output 6
    io:println(r6[0]); // @output Bal
    io:println(r6[1]); // @output 3
    io:println(r6[2]); // @output true
    io:println(r6[3]); // @output 34
    io:println(r6[4]); // @output 5.6
    io:println(r6[5]); // @output 45
    r6 = testRecursiveExpressionWithVar3();
    io:println(r6.length()); // @output 6
    io:println(r6[0]); // @output Bal
    io:println(r6[1]); // @output 3
    io:println(r6[2]); // @output true
    io:println(r6[3]); // @output 34
    io:println(r6[4]); // @output 5.6
    io:println(r6[5]); // @output 45
    r6 = testRecursiveExpressionWithVar4();
    io:println(r6.length()); // @output 6
    io:println(r6[0]); // @output Bal
    io:println(r6[1]); // @output 3
    io:println(r6[2]); // @output true
    io:println(r6[3]); // @output 34
    io:println(r6[4]); // @output 5.6
    io:println(r6[5]); // @output 45
    var u = testVarDefWithUnionType1();
    io:println(u.length()); // @output 3
    io:println(u[0]); // @output 34
    io:println(u[1]); // @output 6.7
    io:println(u[2]); // @output Test
    u = testVarDefWithUnionType2();
    io:println(u.length()); // @output 3
    io:println(u[0]); // @output 34
    io:println(u[1]); // @output 6.7
    io:println(u[2]); // @output Test
    u = testVarDefWithUnionType3();
    io:println(u.length()); // @output 3
    io:println(u[0]); // @output 34
    io:println(u[1]); // @output 6.7
    io:println(u[2]); // @output Test
    var c = testVarDefWithUnionType4();
    io:println(c.length()); // @output 3
    io:println(c[0][0]); // @output Test
    io:println(c[0][1]); // @output 23
    io:println(c[1]); // @output 4.5
    io:println(c[2][0]); // @output 5.7
    io:println(c[2][1]); // @output Foo
    c = testVarDefWithUnionType5();
    io:println(c.length()); // @output 3
    io:println(c[0][0]); // @output Test
    io:println(c[0][1]); // @output 23
    io:println(c[1]); // @output 4.5
    io:println(c[2][0]); // @output 5.7
    io:println(c[2][1]); // @output Foo
    var u6 = testVarDefWithUnionType6();
    io:println(u6.length()); // @output 2
    io:println(u6[0]); // @output Test
    io:println(u6[1]); // @output 23
    var ignored = testIgnoreVariable();
    io:println(ignored.length()); // @output 2
    io:println(ignored[0]); // @output 23
    io:println(ignored[1]); // @output 24
    testTupleVariableWithErrorBP();
    testTupleVarDeclWithTypeReferenceTypedExpr();
    testTupleVarDefWithRestBPContainsErrorBPWithNamedArgs();
    testTupleVarDefWithRestBPContainsErrorBPWithRestBP();
    testReadOnlyListWithListBindingPatternInVarDecl();
    testTupleVariableWithAnonymousRecordType();
}
