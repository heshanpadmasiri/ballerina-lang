function testInvlaidFloatValue() returns float {
    float b;
    b = 010.1; // @error
    return b;
}

function testInvlaidFloatValue2() {
    float b = 999e9999999999; // @error
    float c = 999e-9999999999; // @error
    decimal|float d = 999e9999999999; // @error
    int|decimal|float e = 99.9E99999999; // @error
    int|decimal|float f = 99.9E-99999999; // @error
}

type Bar 0x9999999p999999999999999999999999; // @error

type Bar1 0x9999999p-999999999999999999999999; // @error

type Baz 9999999999e9999999999999999999f; // @error

type Baz1 9999999999e-9999999999999999999f; // @error

0x999.9p999999999999999 x = 0x999.9p999999999999999; // @error // @error

type FloatType 9.99E+6111f; // @error

function testOutOfRangeFloat() {
    float _ = 9.99E+6111f; // @error
    9.99E+6111f _ = 9.99E+6111f; // @error // @error
    float _ = 9.99E+6111; // @error
}
