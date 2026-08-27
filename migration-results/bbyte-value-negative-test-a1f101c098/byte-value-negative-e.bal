function invalidByteLiteral() {
    byte b1 = 345; // @error
    byte b2 = -123; // @error
    byte b3 = 256; // @error
    byte b4 = -1; // @error
    byte b5 = 12.3; // @error
    byte b6 = -34.6; // @error
    byte b7 = 0.0; // @error
    byte[] a1 = [1, 2, -2]; // @error
    byte[] a2 = [1, 256, 45]; // @error
    byte[] a3 = [1, 2.3, 34, -56, 257]; // @error @error @error
    byte[] a4 = [1, -2.3, 3.4, 4, 46777]; // @error @error @error

    int x = 45;
    byte y = x; // @error

    float w = 4.0;
    byte z = w; // @error

    string r = "4";
    byte s = r; // @error

    int x1 = -123;
    byte x2 = trap <byte> x1; // @error

    int x3 = 256;
    byte x4 = trap <byte> x3; // @error

    int x5 = 12345;
    byte x6 = trap <byte> x5; // @error
}

function testUnreachableByteMatchStmt3() {
    var result = foo(2);
    int a = result is int ? 333 : (result is byte ? 777 : (result is string[] ? 666 : result)); // @error
}

function testUnreachableByteMatchStmt4() {
    var result = foo(2);
    int a = result is int ? 333 : (result is byte ? 777 : (result is string[] ? 666 : result)); // @error
}

function foo (int a) returns (byte|int|string[]) {
    if (a == 1) {
        return check trap <byte>12;
    } else if (a == 3) {
        return 267;
    }
    return ["ba", "le"];
}
