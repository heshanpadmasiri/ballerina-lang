import ballerina/io;

class F {
    function () returns int f = function() returns int => 1;
    function () returns int fooDel = foo;

    function foo() returns int {
        return 333;
    }
}

type T object {
    function () returns int f;
};

class D {
    function () returns int foo;

    function init() {
        F f = new F();
        self.foo = f.foo;
    }
}

function foo() returns int {
    return 222;
}

isolated class CoreState {
    private int i = 0;

    isolated function inc() {
        lock {
            self.i = self.i + 1;
        }
    }

    isolated function dec() {
        lock {
            self.i = self.i - 1;
        }
    }

    isolated function get() returns int {
        lock {
            return self.i;
        }
    }

    isolated function init(int i) {
        self.i = i;
    }
}

isolated class Proxy {
    private CoreState state;

    final isolated function () inc;
    final isolated function () dec;
    final isolated function () returns int get;

    isolated function init(int i) {
        self.state = new (i);
        self.inc = self.state.inc;
        self.dec = self.state.dec;
        self.get = self.state.get;
    }
}

public function testInvocationOfObjectField() {
    F f = new ();
    var ff = start f.f();
    var fr = wait ff;
    assertEquals(1, fr);
    var fooDelF = start f.fooDel();
    var fooDel = wait fooDelF;
    assertEquals(foo(), fooDel);

    D d = new ();
    var ffooF = start f.foo();
    var ffoo = wait ffooF;
    var dfooF = start d.foo();
    var dfoo = wait dfooF;
    assertEquals(ffoo, dfoo);

    T t = new F();
    var tfF = start t.f();
    var tf = wait tfF;
    assertEquals(1, tf);
}

public isolated function testInvocationOfObjectFieldWithMutableState() {
    Proxy proxy = new (10);
    proxy.inc();

    var getF = start proxy.get();
    var getR = wait getF;
    assertEquals(11, getR);

    proxy.dec();

    getF = start proxy.get();
    getR = wait getF;
    assertEquals(10, getR);

    proxy.dec();
    proxy.dec();
    proxy.dec();
    proxy.dec();
    proxy.dec();

    getF = start proxy.get();
    getR = wait getF;
    assertEquals(5, getR);
}

public function testInvocationOfObjectFieldWithTypeInit() {
    var ff = start (new F()).f();
    var fr = wait ff;
    assertEquals(1, fr);
    var fooDelF = start (new F()).fooDel();
    var fooDel = wait fooDelF;
    assertEquals(foo(), fooDel);
}

isolated function assertEquals(anydata|error expected, anydata|error actual) {
    if (actual is anydata && expected is anydata && actual == expected) {
        return;
    } else if (actual === expected) {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    io:print("");
    testInvocationOfObjectField();
    testInvocationOfObjectFieldWithMutableState();
    testInvocationOfObjectFieldWithTypeInit();
}
