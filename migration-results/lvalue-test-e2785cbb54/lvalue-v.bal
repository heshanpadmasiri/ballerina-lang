import ballerina/io;

type Foo record {
    string x = "test string";
    Bar bar = {};
    Bar bar2 = {};
    Baz baz = new;
    string s?;
};

type FooTwo record {
    int x = 1;
    Bar bar = {};
    Bar bar2 = {};
    Baz baz = new;
    string s = "hello";
};

type Bar record {
    int x = 1;
    float f = 2.0;
};

class Baz {
    string x;
    Qux q;

    isolated function init() {
        self.x = "string value";
        self.q = new;
    }
}

class BazTwo {
    int x;
    Qux q;

    function init() {
        self.x = 1;
        self.q = new;
    }
}

class Qux {
    string x = "test string";
}

int gi = 1;
int|string gsi = 2;

function testBasicValueStoreForVariable() returns boolean {
    int i;
    i = 10;
    gi = 2;
    return i == 10 && gi == 2;
}

function testValueStoreForMap() returns boolean {
    map<string> m1 = { one: "string one", two: "string two" };
    map<map<int>> m2 = { one: { x: 1, y: 2 }, two: { z: 45 } };
    m1["three"] = "string three";
    m1["four"] = "string four";
    m2["one"]["z"] = 3;
    m2["two"]["four"] = 4;
    return m1["three"] == "string three" && m1["four"] == "string four" && m2["one"]["z"] == 3 &&
            m2["two"]["four"] == 4;
}

function testValueStoreForRecord() returns boolean {
    Foo f = {};
    f.x = "hello";
    f["z"] = 2;
    f.bar = { x: 2 };
    f["bar2"] = { x: 3 };
    f.bar.f = 3.0;
    f["bar2"]["y"] = 4;
    f.s = "string for optional field";
    return f["x"] == "hello" && f["z"] == 2 && f.bar.x == 2 && f.bar2.x == 3 && f.bar.f == 3.0 &&
            f.bar2["y"] == 4 && f?.s == "string for optional field";
}

function testValueStoreForObject() returns boolean {
    Baz b = new;
    b.x = "hello world";
    b.q.x = "world";
    return b.x == "hello world" && b.q.x == "world";
}

function testBasicValueStoreForUnionVariable() returns boolean {
    int|boolean i;
    i = 120;
    gsi = "hello";
    return i == 120 && gsi == "hello";
}

function testValueStoreForMapUnion() returns boolean {
    map<string> m = { one: "string one", two: "string two" };
    map<string>|map<float> m1 = m;
    map<map<int>> m0 = { one: { x: 1, y: 2 }, two: { z: 45 } };
    map<map<int>>|map<map<map<boolean>>> m2 = m0;
    m1["three"] = "string three";
    m1["four"] = "string four";
    m2["one"]["z"] = 3;
    m2["two"]["four"] = 4;
    return m1["three"] == "string three" && m1["four"] == "string four" && m2["one"]["z"] == 3 &&
            m2["two"]["four"] == 4;
}

function testValueStoreForRecordUnion() returns boolean {
    Foo f0 = {};
    Foo|FooTwo f = f0;
    f.x = "hello";
    f["z"] = 2;
    f.bar = { x: 2 };
    f["bar2"] = { x: 3 };
    f.bar.f = 3.0;
    f["bar2"]["y"] = 4;
    f.s = "string for optional field";
    return f["x"] == "hello" && f["z"] == 2 && f.bar.x == 2 && f.bar2.x == 3 && f.bar.f == 3.0 &&
            f.bar2["y"] == 4 && f?.s == "string for optional field";
}

function testValueStoreForObjectUnion() returns boolean {
    Baz b0 = new;
    Baz|BazTwo b = b0;
    b.x = "hello world";
    b.q.x = "world";
    return b.x == "hello world" && b.q.x == "world";
}

type E record {
    int i = 10;
    string s?;
    F f = {};
};

type F record {
    float f = 1.0;
};

function testArrayFillSuccess1() returns boolean {
    int[] i = [0, 1];
    i[4] = 4;
    return i.length() == 5 && i[0] == 0 && i[1] == 1 && i[4] == 4 && i[2] == i[3] && i[2] == 0;
}

function testArrayFillSuccess2() returns boolean {
    E e1 = { i: 120, s: "hello", f: { f: 1.4 } };
    E e2 = { i: 345, f: { f: 1.4 } };
    E[] e = [e1];
    e[3] = e2;
    return e.length() == 4 && e[0] == e1 && e[3] == e2 && e[1] == e[2] && e[1].i == 10 && e[1]?.s is () &&
            e[1].f.f == 1.0;
}

type H record {
    map<int> m?;
};

class I {
    H h = {};
}

function testFillingReadOnInitializedObjectField() returns boolean {
    I i = new;
    i.h.m["one"] = 1;
    i.h.m["two"] = 2;
    map<int>? rm = i.h?.m;
    if (rm is () || rm.length() != 2) {
        return false;
    }
    return i.h?.m["one"] == 1 && i.h?.m["two"] == 2;
}

type J record {
    string s = "default value";
};

function testFillingReadOnMapPositive() returns boolean {
    map<map<int>> m1 = {};
    m1["one"]["id"] = 10;
    map<J> m2 = {};
    m2["one"]["s"] = "value";
    map<int>? m3 = m1["one"];
    if (m3 is () || m3.length() != 1) {
        return false;
    }
    J? j = m2["one"];
    if (j is () || j.length() != 1) {
        return false;
    }
    return m1["one"]["id"] == 10 && m2["one"]["s"] == "value";
}

type K record {
    J j?;
};

function testFillingReadOnRecordPositive() returns boolean {
    K k1 = {};
    K k2 = {};
    k1.j.s = "new value 1";
    k2.j.s = "new value 2";
    J? j1 = k1?.j;
    J? j2 = k2?.j;
    if (j1 is () || j2 is ()) {
        return false;
    }
    return k1?.j?.s == "new value 1" && k2["j"]["s"] == "new value 2";
}

type L record {
    int i;
};

function testFieldUpdateOfElementForMapWithNoFillerValue() returns boolean {
    map<L> m = { one: { i: 10 } };
    m["one"]["i"] = 1;
    return m["one"]["i"] == 1;
}

type M record {
    L l?;
};

function testFieldUpdateOfElementForRecordWithNoFillerValue() returns boolean {
    M m1 = { l: { i: 10 } };
    m1["l"]["i"] = 150;
    M m2 = { l: { i: 10 } };
    m2.l.i = 250;
    return m1["l"]["i"] == 150 && m2?.l?.i == 250;
}

function testArrayMemberAccessLvExprWithBuiltInIntSubTypeKeyExpr() {
    int[] a = [];
    byte b = 0;
    int:Signed32 c = 355;
    a[b] = 10;
    b = 255;
    a[b] = 30;
    a[c] = 20;
    assertEquality(356, a.length());
    assertEquality(10, a[0]);
    assertEquality(0, a[100]);
    assertEquality(0, a[254]);
    assertEquality(30, a[255]);
    assertEquality(30, a[b]);
    assertEquality(0, a[256]);
    assertEquality(20, a[355]);
    function () fn = function () {
        record {| int i; |}[] d = [];
        int:Unsigned16 e = 45;
        d[e] = {i: 1};
    };
    error? res = trap fn();
    assertTrue(res is error);
    error err = <error> res;
    assertEquality("{ballerina/lang.array}IllegalListInsertion", err.message());
    assertEquality("array of length 0 cannot be expanded into array of length 46 without filler values",
                   <string> checkpanic err.detail()["message"]);
}

function testTupleMemberAccessLvExprWithBuiltInIntSubTypeKeyExpr() {
    [int, int...] a = [-1];
    byte b = 0;
    int:Signed32 c = 355;
    a[b] = 10;
    b = 255;
    a[b] = 30;
    a[c] = 20;
    assertEquality(356, a.length());
    assertEquality(10, a[0]);
    assertEquality(0, a[100]);
    assertEquality(0, a[254]);
    assertEquality(30, a[255]);
    assertEquality(30, a[b]);
    assertEquality(0, a[256]);
    assertEquality(20, a[355]);
}

function testRecordMemberAccessLvExprWithStringCharKeyExpr() {
    record {| int a; int b; |} r = {a: 1, b: 2};
    string:Char a = "a";
    r[a] = 101;
    assertEquality(101, r.a);
    function () fn = function () {
        string:Char c = "c";
        r[c] = 20;
    };
    error? res = trap fn();
    assertTrue(res is error);
    error err = <error> res;
    assertEquality("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquality("invalid field access: field 'c' not found in record type 'record {| int a; int b; |}'",
                   <string> checkpanic err.detail()["message"]);
}

function testNilAssignmentToRecordFieldWithMemberAccessLvExprWithVariableRefKey() {
    string sa = "a";
    string sb = "b";
    record {| int a; boolean? b; |} a = {a: 1, b: true};
    a[sb] = ();
    assertEquality({a: 1, b: ()}, a);
    var fn = function () {
        a[sa] = ();
    };
    error? res = trap fn();
    assertTrue(res is error);
    error err = <error> res;
    assertEquality("{ballerina/lang.map}InherentTypeViolation", err.message());
    assertEquality("invalid value for record field 'a': expected value of type 'int', found '()'",
                   <string> checkpanic err.detail()["message"]);
    record { int a; } c = {a: 2, "b": true, "c": 1.0};
    fn = function () {
        c[sa] = ();
    };
    res = trap fn();
    assertTrue(res is error);
    err = <error> res;
    assertEquality("{ballerina/lang.map}InherentTypeViolation", err.message());
    assertEquality("invalid value for record field 'a': expected value of type 'int', found '()'",
                   <string> checkpanic err.detail()["message"]);
    c[sb] = ();
    assertEquality({a: 2, b: (), c: 1.0}, c);
    "a"|"b" ab = "b";
    a = {a: 12, b: false};
    a[ab] = ();
    assertEquality({a: 12, b: ()}, a);
    ab = "a";
    a = {a: 122, b: false};
    a[ab] = 124;
    assertEquality({a: 124, b: false}, a);
    a = {a: 123, b: false};
    "b" bStr = "b";
    a[bStr] = ();
    assertEquality({a: 123, b: ()}, a);
    fn = function () {
        ab = "a";
        a[ab] = ();
    };
    res = trap fn();
    assertTrue(res is error);
    err = <error> res;
    assertEquality("{ballerina/lang.map}InherentTypeViolation", err.message());
    assertEquality("invalid value for record field 'a': expected value of type 'int', found '()'",
                   <string> checkpanic err.detail()["message"]);
}

function assertTrue(anydata actual) {
    assertEquality(true, actual);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    io:println(testBasicValueStoreForVariable()); // @output true
    io:println(testValueStoreForMap()); // @output true
    io:println(testValueStoreForRecord()); // @output true
    io:println(testValueStoreForObject()); // @output true
    io:println(testBasicValueStoreForUnionVariable()); // @output true
    io:println(testValueStoreForMapUnion()); // @output true
    io:println(testValueStoreForRecordUnion()); // @output true
    io:println(testValueStoreForObjectUnion()); // @output true
    io:println(testFieldUpdateOfElementForMapWithNoFillerValue()); // @output true
    io:println(testFieldUpdateOfElementForRecordWithNoFillerValue()); // @output true
    io:println(testArrayFillSuccess1()); // @output true
    io:println(testArrayFillSuccess2()); // @output true
    io:println(testFillingReadOnInitializedObjectField()); // @output true
    io:println(testFillingReadOnMapPositive()); // @output true
    io:println(testFillingReadOnRecordPositive()); // @output true
    testArrayMemberAccessLvExprWithBuiltInIntSubTypeKeyExpr();
    testTupleMemberAccessLvExprWithBuiltInIntSubTypeKeyExpr();
    testRecordMemberAccessLvExprWithStringCharKeyExpr();
    testNilAssignmentToRecordFieldWithMemberAccessLvExprWithVariableRefKey();
}
