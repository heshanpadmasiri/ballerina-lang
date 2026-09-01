function testInvalidArgsViaVararg() {
    Foo f = new;

    var a = [1, true, false];
    [float, string...] b = [1.0, "str"];

    string s = f.bar(1, ...a); // @error
    int i = f.bar(1, ...["hello", false]); // @error

    _ = f.bar(1, false, ...[1, "world"]); // @error
    f.bar(...b); // @error

    f->baz(1, ...a); // @error
    f->baz(...b); // @error
}

function testInvalidIndividualArgsWithVararg() {
    Foo f = new;

    boolean[] a = [true, false];

    _ = f.bar(i = 1, ...a); // @error

    _ = f->baz("str", ...a); // @error

    var fn = function () returns [boolean, boolean...] {
        return [true, false, false];
    };

    int i = f.bar(1, 1.0, ...fn()); // @error
}

client class Foo {
    function bar(int i, boolean... b) returns int {
        return i;
    }

    remote function baz(string s, float f = 2.0, boolean... b) {
    }
}
