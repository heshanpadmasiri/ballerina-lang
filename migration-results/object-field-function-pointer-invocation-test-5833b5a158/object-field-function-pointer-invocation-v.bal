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
    assertEquals(1, f.f());
    assertEquals(foo(), f.fooDel());

    D d = new ();
    assertEquals(f.foo(), d.foo());

    T t = new F();
    assertEquals(1, t.f());
}

public isolated function testInvocationOfObjectFieldWithMutableState() {
    Proxy proxy = new (10);
    proxy.inc();
    assertEquals(11, proxy.get());
    proxy.dec();
    assertEquals(10, proxy.get());

    proxy.dec();
    proxy.dec();
    proxy.dec();
    proxy.dec();
    proxy.dec();
    assertEquals(5, proxy.get());
}

isolated function assertEquals(anydata|error expected, anydata|error actual) {
    if (actual is anydata && expected is anydata && actual == expected) {
        return;
    } else if (actual === expected) {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    io:println("");
    panic error("expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    testInvocationOfObjectField();
    testInvocationOfObjectFieldWithMutableState();
}
