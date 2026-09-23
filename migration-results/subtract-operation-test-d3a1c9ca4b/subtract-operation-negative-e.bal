function incompatibleSubtract() {
    float f;
    f = 5 - "foo"; // @error
}

function sunstractJson() {
    json j1;
    json j2;
    json j3;
    j1 = {"name":"Jack"};
    j2 = {"state":"CA"};
    j3 = j1 - j2; // @error
}

const A = 10;
const B = 20;
type C A|B;

function subtractIncompatibleTypes() {
    C a = 10;
    string b = "ABC";
    float|int c = 12;
    string|string:Char e = "D";
    int i1 = a - b; // @error
    int i2 = a - c; // @error
    string i3 = b - e; // @error
}

function testImplicitConversion() {
    float a = 1;
    decimal b = 1;
    int c = 1;
    var x1 = a - b; // @error
    any x2 = a - b; // @error
    var x3 = a - c; // @error
    any x4 = b - c; // @error
    anydata x5 = c - a; // @error
    C d = 10;
    float e = 12.25;
    var y1 = d - e; // @error
    any y2 = d - e; // @error
}

function overflowBySubtraction() {
    int num1 = -9223372036854775808; // @error
    int num2 = 1;
    int ans = num1 - num2;
}
