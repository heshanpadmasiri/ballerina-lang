function testInvaidAssignmentToVariable() {
    int i = "hello"; // @error
}

class A {
    string x = "hello";
}

function testInvalidObjectLvExpr() {
    A a = new;
    a.y = 1; // @error
    a["x"] = "hello"; // @error
}

type B record {
    string x = "world";
    int y?;
};

function testInvalidOptionalFieldAccesOnLhs() {
    B m = { y: 34 };
    m?.x += "qwer"; // @error
    m?.y += 1; // @error
}

class ObjectWithInvalidFillingReadOnUninitializedField {
    map<int[]> s;

    function init() {
        self.s["one"][0] = 1;
    }
}

type C record {
    map<int>? m = ();
};

class D {
    C c = {};
}

function testInvalidFillingReadOnInitializedObjectField() {
    D d = new;
    d.c.m["one"] = 1; // @error
}

type E record {
    string x;
};

type F record {
    map<int>? m = ();
    E? e;
};

function testInvalidRecordFieldAccessLvExpr() {
    E e = { x: "hello" };
    e.y = 1; // @error
    F f = { m: { "one": 1 }, e: () };
    f.m["two"] = 2; // @error
    f.e.x = "ddd"; // @error
}

function testListMemberAccessLvExprWithIntBuiltInSubTypeKeyExprNegative() {
    int[] a = [];
    byte b = 0;
    a[b] = ""; // @error
    int:Signed32 c = 0;
    a[c] = true; // @error
}

function testRecordMemberAccessLvExprWithStringCharKeyExprNegative() {
    record {|
        int:Signed8 a;
        int:Signed8 b;
        int:Signed8 cd;
    |} r = {a: 1, b: 2, cd: 3};
    string:Char a = "a";
    r[a] = 200; // @error
}

function testNilAssignmentToRecordFieldWithMemberAccessLvExprWithVariableRefKeyNegative() {
    string str = "a";
    record {| int a; |} a = {a: 1};
    a[str] = (); // @error
    record {||} b = {};
    b[str] = (); // @error
    record {| never a?; never b?; |} c = {};
    c[str] = (); // @error
    "a" aStr = "a";
    a[aStr] = (); // @error
}
