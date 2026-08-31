const int CI6 = 1 + 2;
const float CF1 = 1.0 + 2.0;
const decimal CD1 = 1.0 + 2.0;
const byte CBT1 = 1;
const byte CBT2 = 2;
const byte CBT3 = CBT1 + CBT2;
const boolean CB2 = !true;
const string CS2 = "1" + "2";

type TYPE1 4;
type TYPE2 5.0|4.0f;
type TYPE3 1d|2.0d;
type TYPE4 4;
type TYPE5 true;
type TYPE6 "a";

function userDefinedTypeTests() {
    CI6 ci6 = 4; // @error
    CF1 cf1 = 4.0; // @error
    CD1 cd1 = 4.0; // @error
    CBT3 cbt3 = 4; // @error
    CB2 cb2 = true; // @error
    CS2 cs2 = "4"; // @error

    TYPE1 t1 = CI6; // @error
    TYPE2 t2 = CF1; // @error
    TYPE3 t3 = CD1; // @error
    TYPE4 t4 = CBT3; // @error
    TYPE5 t5 = CB2; // @error
    TYPE6 t6 = CS2; // @error
}

const map<int> CMI1 = {a : 1};
const map<int> CMI2 = {b : 2, c : 3};
const map<map<int>> CMI3 = {a : CMI1, CMI2, c : {d : 1}};
const map<map<map<int>>> CMI4 = {a : {b : {a : 1}}, b : CMI3};
const map<float> CMF1 = {a : 0.11, b : 2.12};
const map<map<float>> CMF2 = {c : {d : 0.11, e : 2.12}, f : CMF1};
const map<decimal> CMD1 = {a : 0.11, b : 2.12};
const map<map<decimal>> CMD2 = {c : {d : 0.11, e : 2.12}, f : CMD1};
const map<byte> CMBT = {a : 127, b : 255};
const map<boolean> CMB1 = {a : true, b : false};
const map<string> CMS1 = {a : "C", b : "S"};
const map<string> CMS2 = {b : "C", c : "S"};

const map<string> CMS1_CLONE = {...CMS1};
const map<string> CMS12_CLONE = {...CMS1, ...CMS2}; // @error

const int a = 1;
const map<int> CMI5 = {a};
const map<()> CN1 = {a : ()};
const map<map<()>> CN2 = {CN1};

type TYPE7 readonly & record {|
    readonly & record {|
        readonly & record {|
            1 a;
        |} b;
    |} a;
    readonly & record {|
        readonly & record {|
            1 a;
        |} a;
        readonly & record {|
            2 b;
            3 c;
        |} b;
        readonly & record {|
            1 d;
        |} c;
    |} b;
|};

type TYPE8 readonly & record {|
    0.11 a;
    2.12 b;
|};
type TYPE9 readonly & record {|
    0.11d a;
    2.12d b;
|};
type TYPE10 readonly & record {|
    127 a;
    255 b;
|};
type TYPE11 readonly & record {|
    true a;
    false b;
|};
type TYPE12 readonly & record {|
    "C" a;
    "S" b;
|};

function testTypesOfConstantMaps() {
    TYPE12 t1 = CMI4; // @error
    TYPE11 t2 = CMF1; // @error
    TYPE10 t3 = CMD1; // @error
    TYPE9 t4 = CMBT; // @error
    TYPE8 t5 = CMB1; // @error
    TYPE7 t6 = CMS1; // @error
    TYPE7 t7 = CMS1_CLONE; // @error
    TYPE7 t8 = CMS12_CLONE;
    TYPE7 t9 = CMI4; // @error
    CMI1 cmi4 = CMI2; // @error
    CMI4 cmi4 = {a : "C", b : "S"}; // @error
    CMF1 cmf1 = {a : 0.11, c : 2.12d}; // @error @error
    CMD1 cmd1 = {a : 0.11f, b : 2.12d}; // @error
    CMBT cmbt = {a : "C", b : "S"}; // @error @error
    CMB1 cmb1 = {a : true}; // @error
    CMS1 cms1 = {a : "S", b : "C"}; // @error @error
    CMS1_CLONE cms1_clone = {}; // @error @error
    CMI5 cmi5 = {}; // @error
    CN2 cn2 = {a : ()}; // @error @error
}

const int A = 123;
const int B = A;
const int C = B - A - 1;

function f1() {
    A _ = 1; // @error
    B _ = 2; // @error
    C _ = 3; // @error
}

function f2() {
    var a = A;
    var b = B;
    var c = C;
    a = 1;
    b = 2;
    c = 3;
    a = "1"; // @error
    b = "2"; // @error
    c = "3"; // @error
}

function f3() {
    A[] _ = [A, B, C, 1]; // @error @error
    B[] _ = [A, B, C, 1, 123]; // @error @error
    (B|C)[] _ = [A, 1, C, 123, B, -1]; // @error
    C[] _ = [A, B, C, -1, 1]; // @error @error @error
}

const X = 1;
int i = 2;
const map<int> D = {
    a: X,
    b: i, // @error
    X
};

record { string a; } _ = D;

const map<int> E = {
    a: X,
    b: 2
};
const map<map<int>> F = {
    a: E,
    b: {
        a: 1
    }
};

function f4() {
    record {| int a; string...; |} _ = D;
    record {| 1 a; |} _ = E; // @error
    readonly & record {| record {| 1 a; 2 b; |} a; record {| 3 a; |} b; |} _ = F; // @error
}

function f5() {
    var a = E;
    a.a = 1; // @error
    a.b = 1; // @error

    var b = F;
    b.a.a = 2; // @error
    b.b.a = 2; // @error
    b.b = {}; // @error
}

const G = 1;
const int H = G + 1;
G _ = 1;
G _ = 0; // @error
H _ = 2;
H _ = 0; // @error

const map<boolean> I = {a: true, b: false};
I _ = {a: true, b: false};
I _ = {}; // @error @error
I _ = {a: false}; // @error @error

const map<string> J = {
    a: "greetings",
    b: "map"
};
const map<map<string>> K = {
    a: J,
    b: {
        x: "hello",
        y: "world"
    },
    c: {
        x: "from",
        z: "Ballerina",
        b: "!"
    }
};

record {| record {| "greetings" a; "map" b; |} a; record {| "hello" x; "world" y; |} b; record {| "!" b; "from" x; "Ballerina" z; |} c; |} & readonly _ = K;
record {| record {| "greetings" a; "map" b; |}...; |} _ = K; // @error

K _ = {}; // @error @error @error
K _ = {
    b: K.b,
    a: {
        a: "greetings",
        b: "map"
    },
    c: {
        x: "from",
        z: "Ballerina",
        b: K.c.b
    }
};

function f6() {
    record {| record {| "greetings" a; "map" b; |} a; record {| "hello" x; "world" y; |} b; record {| "!" b; "from" x; "Ballerina" z; |} c; |} & readonly _ = K;
    record {| record {| "greetings" a; "map" b; |}...; |} _ = K; // @error

    K _ = {}; // @error @error @error
    K _ = {
        b: K.b,
        a: {
            a: "greetings",
            b: "map"
        },
        c: {
            x: "from",
            z: "Ballerina",
            b: K.c.b
        }
    };
}
