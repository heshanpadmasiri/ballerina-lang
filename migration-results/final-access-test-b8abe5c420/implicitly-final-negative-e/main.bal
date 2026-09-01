class MockListener {
    public function init(int port) {
    }

    public function attach(service object {} s, string[]|string? name = ()) returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }
}

public function testFieldAsFinalParameter() returns int {
    int i = 50;
    int x = bar(i);
    return x;
}

function bar(int a) returns int {
    int i = a;
    a = 500; // @error
    return a;
}

function foo(int a) returns int {
    int i = a;
    a = 500; // @error
    return a;
}

function baz(float f, string s, boolean b, json j) returns [float, string, boolean, json] {
    f = 5.3; // @error
    s = "Hello"; // @error
    b = true; // @error
    j = {"a":"b"}; // @error
    return [f, s, b, j];
}

function finalFunction() {
    int i = 0;
}

service /FooService on new MockListener(9090) {
}

function testCompound(int a) returns int {
    a += 10; // @error
    return a;
}

listener MockListener ml = new (8080);

public function testChangingListenerVariableAfterDefining() {
    ml = new MockListener(8081); // @error
}

function testRestParamFinal(string p1, string... p2) {
    p2 = ["a", "b"]; // @error
}

function (int a, int... b) testModuleLevelRestParamFinal = function (int i, int... b) {
        b = []; // @error
    };

public function testLocalLevelRestParamFinal() {
    int[] arr = [];
    function (int a, int... b) func = function (int i, int... b) {
        b = arr; // @error
    };
}

public function testLocalLevelRestParamFinalWithVar() {
    int[] arr = [];
    var func = function (int i, int... b) {
        b = arr; // @error
    };
}
