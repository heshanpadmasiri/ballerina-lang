function testInvalidExplicitTypeFromString() {
    string s1 = "Ballerina says Hello World";
    string s2 = getString(s1);

    float f1 = <float> s1; // @error
    anydata f2 = <float> s2; // @error

    anydata d1 = <decimal> s1; // @error
    decimal d2 = <decimal> s2; // @error

    int i1 = <int> s1; // @error
    anydata i2 = <int> s2; // @error

    anydata b1 = <byte> s1; // @error
    byte b2 = <byte> s2; // @error

    anydata bl1 = <boolean> s1; // @error
    boolean bl2 = <boolean> s2; // @error
}

function testInvalidCastFromBasicTypeToBasicType() {
    int i = 1;
    string s = "test string";
    float f = 1.0;
    boolean b = true;
    decimal d = 10.0;

    string s1 = <string> i; // @error
    boolean b1 = <boolean> i; // @error

    string s2 = <string> f; // @error
    boolean b2 = <boolean> f; // @error

    string s3 = <string> d; // @error
    boolean b3 = <boolean> d; // @error

    int ci1 = <int> b; // @error
    string cs1 = <string> b; // @error
    float cf1 = <float> b; // @error
    decimal cd1 = <decimal> b; // @error

    int ci2 = <int> s; // @error
    boolean cb1 = <boolean> s; // @error
    float cf2 = <float> s; // @error
    decimal cd2 = <decimal> s; // @error
}

function testInvalidCastToUnionWithMultipleBasicNumericTypes() {
    float f = 1.0;
    int|decimal cid1 = <int|decimal> f; // @error
}

function getString(string s) returns string {
    return s;
}

