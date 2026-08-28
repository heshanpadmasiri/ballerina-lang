function test1() {
    int a = 0xFFFFFFFFFFFFFFFF; // @error
    int b = 9999999999999999999; // @error

    int d = -0xFFFFFFFFFFFFFFFF; // @error
    int e = -9999999999999999999; // @error
}

function test2() {
    // This is to test preceding syntax issues.
    int x = 1
    // @error

    int g = 0672; // @error
    int h = 0912; // @error

    // This is to verify that the compilation continues.
    int y = 1
    // @error
}

type testType1 int:Signed32;
type testType2 int:Signed16;
type testType3 int:Signed8;

function testStaticTypeOfUnaryExpr() {
    int:Signed8 a = -128;
    int:Signed8 _ = -a; // @error
    int:Signed16 b = -32768;
    int:Signed16 _ = -b; // @error
    int:Signed32 c = -2147483648;
    int:Signed32 _ = -c; // @error

    testType1 d = -2147483648;
    int:Signed32 _ = -d; // @error
    testType2 e = -32768;
    int:Signed16 _ = -e; // @error
    testType3 f = -128;
    int:Signed8 _ = -f; // @error
}
