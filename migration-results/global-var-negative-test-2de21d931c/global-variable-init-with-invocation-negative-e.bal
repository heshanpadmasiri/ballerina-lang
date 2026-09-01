int i;
string s;
function (int a) t;
Foo u;

function init() {
    Foo lf;
    lf.value(); // @error // @error

    t(10); // @error // @error

    i = foo(); // @error

    u.value(); // @error // @error

    s = bar(); // @error

    t(10); // @error // @error

    t = function (int a) {};

    getFoo().value(); // @error // @error
    u = new;
}

function foo() returns int {
    return 0;
}

function bar() returns string {
    return "";
}

class Foo {
    function value() {
    }
}

function getFoo() returns Foo => new;
