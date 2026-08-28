function testUninitializedClosureVars() {
    string a;

    var bazz = function () {
        string _ = a + "aa"; // @error
    };

    bazz();

    string b;
    int count;

    var bar = function () {
        count += 10; // @error

        b = b + "bb"; // @error
    };

    bar();
}

public function lambdaInitTest() {
    int localVar;
    int localVar2;

    worker w1 {
        localVar = 4;
        int _ = localVar;
        int _ = localVar2; // @error
    }

    var _ = function () {
        localVar = 2;
        int _ = localVar;
        int _ = localVar2; // @error
    };

    int _ = localVar; // @error
    int _ = localVar2; // @error
}
