import ballerina/io;

int GLB = 0;
string GLB_STRING = "global";

function getInt() returns int => 100;
function getFloat() returns float => 1.1;
function getString() returns string => "default";
function getRecord() returns FooRecord => {a: "default2", b: 150, c: true, d: 33.3};

type FooRecord record {|
    string a;
    int b;
    boolean c;
    float d;
|};

class FooObject {
    string a;
    int b;
    function init(string a, int b) { self.a = a; self.b = b; }
}

class ObjectOne {
    string a;
    boolean b;
    int c;
    float d;
    FooRecord e;
    FooObject f;
    function init(string a = getString(), boolean b = true, int c = getInt(), float d = 1.1,
                  FooRecord e = {a: "default", b: 50, c: false, d: 11.1}, FooObject f = new ("def", 200)) {
        self.a = a; self.b = b; self.c = c; self.d = d; self.e = e; self.f = f;
    }
    function getValues() returns [string, boolean, int, float, FooRecord, FooObject] =>
        [self.a, self.b, self.c, self.d, self.e, self.f];
}

class ObjectTwo {
    int a;
    string b;
    float c;
    FooRecord d;
    function init(int a = getInt() + 5 + getInt(), string b = "def" + getString(),
                  float c = getFloat() + <float>getInt(), FooRecord d = getRecord()) {
        self.a = a; self.b = b; self.c = c; self.d = d;
    }
    function getValues() returns [int, string, float, FooRecord] => [self.a, self.b, self.c, self.d];
}

class ObjectThree {
    function attachedFunction1(string a = GLB_STRING, int b = getInt(),
                               FooRecord c = {a: "default", b: 50, c: false, d: 11.1})
            returns [string, int, FooRecord] => [a, b * 2, c];
    function attachedFunction2(int a = getInt() + 10 + getInt(), string b = "def" + getString() + GLB_STRING,
                               float c = getFloat() + <float>getInt(), FooRecord d = getRecord())
            returns [int, string, float, FooRecord] => [a, b, c, d];
}

class ObjectFour {
    function attachedFunction1(string a = GLB_STRING, int b = getInt(),
                               FooRecord c = {a: "default", b: 50, c: false, d: 11.1})
            returns [string, int, FooRecord] => [a, b * 2, c];
    function attachedFunction2(int a = getInt() + 10 + getInt(), string b = "def" + getString() + GLB_STRING,
                               float c = getFloat() + <float>getInt(), FooRecord d = getRecord())
            returns [int, string, float, FooRecord] => [a, b, c, d];
}

class ObjectFive {
    function foo(int x = getInt(), float y = getFloat()) returns [int, float] => [x * 2, y * 2.0];
}

class ObjectSix {
    function foo(int x = getInt() * 2, float y = getFloat() * 2.0) returns [int, float] => [x * 2, y * 2.0];
}

function testObjectInitWithDefaultValues() returns [[string, boolean, int, float, FooRecord, FooObject], [string, boolean, int, float, FooRecord, FooObject]] {
    ObjectOne o1 = new;
    ObjectOne o2 = new (a = "given", b = false, c = 99, e = {a: "given2", b: 49, c: true, d: 10.9}, f = new ("def2", 199));
    return [o1.getValues(), o2.getValues()];
}

function testObjectInitWithDefaultValues2() returns [[int, string, float, FooRecord], [int, string, float, FooRecord]] {
    ObjectTwo o1 = new;
    ObjectTwo o2 = new (a = 10, d = {a: "given", b: 49, c: false, d: 10.9});
    return [o1.getValues(), o2.getValues()];
}

function testObjectAttachedFunction1() returns [[string, int, FooRecord], [string, int, FooRecord]] {
    ObjectThree o = new;
    return [o.attachedFunction1(), o.attachedFunction1(a = "given", c = {a: "given2", b: 140, c: true, d: 22.2})];
}

function testObjectAttachedFunction2() returns [[int, string, float, FooRecord], [int, string, float, FooRecord]] {
    ObjectThree o = new;
    return [o.attachedFunction2(), o.attachedFunction2(b = "given", d = {a: "given2", b: 140, c: true, d: 22.2})];
}

function testObjectAttachedFunction3() returns [[string, int, FooRecord], [string, int, FooRecord]] {
    ObjectFour o = new;
    return [o.attachedFunction1(), o.attachedFunction1(a = "given", c = {a: "given2", b: 140, c: true, d: 22.2})];
}

function testObjectAttachedFunction4() returns [[int, string, float, FooRecord], [int, string, float, FooRecord]] {
    ObjectFour o = new;
    return [o.attachedFunction2(), o.attachedFunction2(b = "given", d = {a: "given2", b: 140, c: true, d: 22.2})];
}

function testObjectCasting1() returns [[int, float], [int, float], [int, float], [int, float]] {
    ObjectFive o1 = new;
    ObjectSix o2 = o1;
    return [o2.foo(), o2.foo(x = 20), o2.foo(x = 20, y = 11.1), o2.foo(y = 11.1)];
}

function testObjectCasting2() returns [[int, float], [int, float], [int, float], [int, float]] {
    ObjectSix o1 = new;
    ObjectFive o2 = o1;
    return [o2.foo(), o2.foo(x = 40), o2.foo(x = 40, y = 22.2), o2.foo(y = 22.2)];
}

public function main() {
    var r1 = testObjectInitWithDefaultValues();
    io:println(r1[0][0]); // @output default
    io:println(r1[0][1]); // @output true
    io:println(r1[0][2]); // @output 100
    io:println(r1[0][3]); // @output 1.1
    io:println(r1[0][4].a); // @output default
    io:println(r1[0][4].b); // @output 50
    io:println(r1[0][4].c); // @output false
    io:println(r1[0][4].d); // @output 11.1
    io:println(r1[0][5].a); // @output def
    io:println(r1[0][5].b); // @output 200
    io:println(r1[1][0]); // @output given
    io:println(r1[1][1]); // @output false
    io:println(r1[1][2]); // @output 99
    io:println(r1[1][3]); // @output 1.1
    io:println(r1[1][4].a); // @output given2
    io:println(r1[1][4].b); // @output 49
    io:println(r1[1][4].c); // @output true
    io:println(r1[1][4].d); // @output 10.9
    io:println(r1[1][5].a); // @output def2
    io:println(r1[1][5].b); // @output 199

    var r2 = testObjectInitWithDefaultValues2();
    io:println(r2[0][0]); // @output 205
    io:println(r2[0][1]); // @output defdefault
    io:println(r2[0][2]); // @output 101.1
    io:println(r2[0][3].a); // @output default2
    io:println(r2[0][3].b); // @output 150
    io:println(r2[0][3].c); // @output true
    io:println(r2[0][3].d); // @output 33.3
    io:println(r2[1][0]); // @output 10
    io:println(r2[1][1]); // @output defdefault
    io:println(r2[1][2]); // @output 101.1
    io:println(r2[1][3].a); // @output given
    io:println(r2[1][3].b); // @output 49
    io:println(r2[1][3].c); // @output false
    io:println(r2[1][3].d); // @output 10.9

    var r3 = testObjectAttachedFunction1();
    io:println(r3[0][0]); // @output global
    io:println(r3[0][1]); // @output 200
    io:println(r3[0][2].a); // @output default
    io:println(r3[0][2].b); // @output 50
    io:println(r3[0][2].c); // @output false
    io:println(r3[0][2].d); // @output 11.1
    io:println(r3[1][0]); // @output given
    io:println(r3[1][1]); // @output 200
    io:println(r3[1][2].a); // @output given2
    io:println(r3[1][2].b); // @output 140
    io:println(r3[1][2].c); // @output true
    io:println(r3[1][2].d); // @output 22.2
    var r4 = testObjectAttachedFunction2();
    io:println(r4[0][0]); // @output 210
    io:println(r4[0][1]); // @output defdefaultglobal
    io:println(r4[0][2]); // @output 101.1
    io:println(r4[0][3].a); // @output default2
    io:println(r4[0][3].b); // @output 150
    io:println(r4[0][3].c); // @output true
    io:println(r4[0][3].d); // @output 33.3
    io:println(r4[1][0]); // @output 210
    io:println(r4[1][1]); // @output given
    io:println(r4[1][2]); // @output 101.1
    io:println(r4[1][3].a); // @output given2
    io:println(r4[1][3].b); // @output 140
    io:println(r4[1][3].c); // @output true
    io:println(r4[1][3].d); // @output 22.2
    var r5 = testObjectAttachedFunction3();
    io:println(r5[0][0]); // @output global
    io:println(r5[0][1]); // @output 200
    io:println(r5[0][2].a); // @output default
    io:println(r5[0][2].b); // @output 50
    io:println(r5[0][2].c); // @output false
    io:println(r5[0][2].d); // @output 11.1
    io:println(r5[1][0]); // @output given
    io:println(r5[1][1]); // @output 200
    io:println(r5[1][2].a); // @output given2
    io:println(r5[1][2].b); // @output 140
    io:println(r5[1][2].c); // @output true
    io:println(r5[1][2].d); // @output 22.2
    var r6 = testObjectAttachedFunction4();
    io:println(r6[0][0]); // @output 210
    io:println(r6[0][1]); // @output defdefaultglobal
    io:println(r6[0][2]); // @output 101.1
    io:println(r6[0][3].a); // @output default2
    io:println(r6[0][3].b); // @output 150
    io:println(r6[0][3].c); // @output true
    io:println(r6[0][3].d); // @output 33.3
    io:println(r6[1][0]); // @output 210
    io:println(r6[1][1]); // @output given
    io:println(r6[1][2]); // @output 101.1
    io:println(r6[1][3].a); // @output given2
    io:println(r6[1][3].b); // @output 140
    io:println(r6[1][3].c); // @output true
    io:println(r6[1][3].d); // @output 22.2
    var r7 = testObjectCasting1();
    io:println(r7[0][0]); // @output 400
    io:println(r7[0][1]); // @output 4.4
    io:println(r7[1][0]); // @output 40
    io:println(r7[1][1]); // @output 4.4
    io:println(r7[2][0]); // @output 40
    io:println(r7[2][1]); // @output 22.2
    io:println(r7[3][0]); // @output 400
    io:println(r7[3][1]); // @output 22.2
    var r8 = testObjectCasting2();
    io:println(r8[0][0]); // @output 200
    io:println(r8[0][1]); // @output 2.2
    io:println(r8[1][0]); // @output 80
    io:println(r8[1][1]); // @output 2.2
    io:println(r8[2][0]); // @output 80
    io:println(r8[2][1]); // @output 44.4
    io:println(r8[3][0]); // @output 200
    io:println(r8[3][1]); // @output 44.4
}
