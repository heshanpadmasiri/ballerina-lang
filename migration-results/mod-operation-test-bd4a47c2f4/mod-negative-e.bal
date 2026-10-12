const A = 10;
const B = 20;

type C A|B;

function modIncompatibleTypes() {
    C a = 10;
    string b = "ABC";
    float|int c = 12;
    string|string:Char e = "D";

    int i1 = a % b; // @error
    int i2 = a % c; // @error
    string i3 = b % e; // @error
}

function testImplicitConversion() {
    float a = 1;
    decimal b = 1;
    int c = 1;
    var x1 = a % b; // @error
    any x2 = a % b; // @error
    anydata x5 = c % a; // @error
    anydata x6 = c % b; // @error

    C d = 10;
    float e = 12.25;
    var y1 = d % e; // @error
    any y2 = d % e; // @error
}
