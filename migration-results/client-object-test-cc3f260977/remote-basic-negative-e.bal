remote function test1(string value) { // @error
}

remote function test2(string value) { // @error
}

remote function test3(string value) returns int = external; // @error

client class Foo {
    function abc(string value) returns int {
        return 10;
    }

    remote function pqr(string value) returns boolean {
        return false;
    }

    remote function xyz(string value) returns float {
        return 10.0;
    }
}

function testFunc1() {
    Foo x = new;
    var y = x.pqr("test"); // @error
    var z = x->abc("test"); // @error
}

function testFunc2() {
    XXX x = new; // @error
    var y = x->foo(); // @error

    map<any> m = {};
    _ = m->keys(); // @error

    Bar b = new;
    _ = b->action1("value"); // @error
}

class Bar {
    function action1(string x) returns int {
        return 10;
    }
}

Foo gep = new;

function testFunc5() {
    var y = gep->pqr("test");
    var z = gep.pqr("test"); // @error
}

function testFunc6(Foo ep, string b) {
    var y = ep->pqr("test");
    var z = ep.pqr("test"); // @error
}

function testFunc9(string s) returns boolean {
    Foo ep;
    string a = "abc";
    return ep->pqr("test");
}

function testFunc10(string s) {
    Foo ep;
    string a = "abc";
    var y = ep->pqr("test");
}

class Baz {
    remote function action1(string s) returns int { // @error
        return 10;
    }

    function nonAction(float f) returns string {
        return "done";
    }

    remote function action2(int i) { // @error
    }
}

class dummy {
    Foo ff = new;

    function nonAction1(float f) returns string {
        _ = self.ff->pqr("test");
        return "done";
    }
}

client class Client {
    remote function foo() {
    }

    function bar() {
    }
}

function testRemoteMethodCallAction() {
    Client cl = new;
    cl.foo(); // @error
    cl->bar(); // @error
}

client class DoubleMethod {
    remote function a() returns int {
        return 0;
    }

    function a() returns int { // @error
        return 2;
    }
}

client class DoubleMethodOtherOrder {
    function a() returns int {
        return 2;
    }

    remote function a() returns int { // @error
        return 0;
    }
}

client class DoubleRemoteMethod {
    remote function a() {
    }

    remote function a() { // @error
    }
}

function clientFunc() {
    var x = client object {
        remote function a() returns int {
            return 0;
        }

        function a() returns int { // @error
            return 2;
        }
    };

    var y = client object {
        function a() returns int {
            return 2;
        }

        remote function a() returns int { // @error
            return 0;
        }
    };

    var z = client object {
        remote function a() {
        }

        remote function a() { // @error
        }
    };
}
