function testNegative1() {
    [string, int, float] [s, i, f] = ["D", 4, 6.7];
    [int, byte, boolean] [s, i, r, t] = [4, 6, true]; // @error
}

function testNegative2() {
    [string, int, float] [s1, i1] = ["D", 4, 6.7]; // @error
    [string, int, float] [s2, i2, r2, t2] = ["D", 4, 6.7]; // @error
    [[string, int], float] [[s3, [i3, r3]], f3] = [["D", 4], 6.7]; // @error
}

function testNegative3() {
    [string, int, float] [s1, i1, f1] = ["D", 4, 6.7, 45]; // @error
    [int, byte, NoFillerObject] [s2, i2, r2] = [4, 6]; // @error
    [string, int, float] [s3, i3, f3] = [4, 5.6, "3"]; // @error @error @error
}

function testNegative4() {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [[Foo, [BarObj, FooObj]], Bar] [[f, [bo, fo]], b] = [[bar, [fooObj, barObj]], foo]; // @error @error @error @error
}

function testNegative5() {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [Foo, [BarObj, FooObj], Bar] [f, [bo, fo], b] = [bar, fooObj, foo]; // @error @error @error
}

function testNegative6() {
    Foo foo = {name: "Test", age: 23};
    Bar bar = {id: 34, flag: true};
    FooObj fooObj = new ("Fooo", 3.7, 23);
    BarObj barObj = new (true, 56);
    [int, Foo, [BarObj, string, FooObj], Bar, boolean] [i, fr, [bo, s, fo], br, b] = [bar, 12, [fooObj, "DD", barObj], foo, true]; // @error @error @error @error @error
}

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

function testInvalidTupleVarDef1() {
    [[string, [int, [boolean, int]]], [float, int]] t = [["Bal", [3, [true, 34]]], [5.6, 45]];
    any a = t;
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = a; // @error
}

function testInvalidTupleVarDef2() returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] t = [["Bal", [3, [true, 34]]], [5.6, 45]];
    any a = t;
    return fn1(a);
}

function fn1(any t) returns [string, int, boolean, int, float, int] {
    [[string, [int, [boolean, int]]], [float, int]] [[s, [i1, [b, y]]], [f, i2]] = t; // @error
    return [s, i1, b, y, f, i2];
}

function testIgnoredVariables() {
    [string, int, float] [_, _, _] = ["D", 4, 6.7]; // @error
}

function testInvalidTupleVarDef3() {
    string|int [p, q] = [0, 0]; // @error
}

type NoFillerObject object {
};

type T [int];

function testTupleVarDeclWithTypeReferenceTypedExprNegative() {
    T t = [1];
    var [a, b] = t; // @error
}

type Ints int;
type IntsOrStrings int|string;

function testTupleVarDeclWithInvalidTypeReferenceType() {
    [int, int] i = [1, 2];
    Ints [a, b] = i; // @error
    IntsOrStrings [c, d] = i; // @error
}

type ReadOnlyTuple readonly & [int[], string];

function testReadOnlyListWithListBindingPatternInVarDeclNegative() {
    ReadOnlyTuple t1 = [[1, 2], "s1"];
    [string[] & readonly, string] [a, b] = t1; // @error

    ReadOnlyTuple [c, d] = t1;
    int[] arr = [];
    c = arr; // @error

    var [e, _] = t1;
    e = arr; // @error
}
