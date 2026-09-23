function testJsonPositive() returns json {
    json j1;
    json j2 = ();
    j1 = {"name":"Jack"};
    j1 = +j2; // @error
    return j1;
}

function testJsonNegative() returns json {
    json j1;
    json j2 = ();
    j1 = {"name":"Jack"};
    j1 = -j2; // @error
    return j1;
}

function testJsonNot() returns json {
    json j1;
    json j2 = ();
    j1 = {"name":"Jack"};
    j1 = !j2; // @error
    return j1;
}

function testNotOperator() returns int {
    int i = !10; // @error
    return i;
}

function testIncompatibleSubtypesWithUnaryOperators() {
    int:Unsigned8 x1 = -7; // @error
    int:Signed8 x2 = +1000; // @error
    byte x3 = 0;
    byte x4 = ~x3; // @error
    int:Unsigned8 x5 = 0;
    int:Unsigned8 x6 = ~x5; // @error
}

function testIncompatibleUnaryOperations() {
    decimal x1 = ~12.5d; // @error
    float x2 = +~12.5; // @error
    anydata x3 = ~12d; // @error
    anydata x4 = !12d; // @error
}

type A -2|-1|0|1|2;
type B 0f|1f;

function testStaticTypeOfUnaryExpr() {
    A x = -2;
    A _ = -x; // @error
    B y = 0f;
    B _ = -y; // @error
}

type C 0|1f;
type D 0|1|"ABC";
const decimal E = 1.25;
type F 3.45d|1.25d|45.6d;
type G "Me";
type des G|decimal|2.0d|2.0d;
type DecimalType1 E|des|F|G;
type DecimalType2 1d|2d|"me";

function testStaticTypeOfOperandContainsMixType() {
    C x = 0;
    int _ = -x; // @error
    D y = 0;
    int _ = -y; // @error
    decimal|DecimalType1 a = 25346.45d;
    decimal|string _ = +a; // @error
    DecimalType1 b = 1.25;
    decimal|string _ = -b; // @error
    decimal|DecimalType2 c = 1d;
    string|decimal _ = +c; // @error
}
