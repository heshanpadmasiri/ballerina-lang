class Foo {
    public int age = 0;
    public string name = "";
    function init() {}
    function init() {} // @error
}

class Bar {
    private function init() {} // @error
}

class Person {
    string name;
    int age;
    function init() returns error? { self.name = check getError(); self.age = 25; }
}

function getError() returns string|error {
    return error("failed to create Person object", f = "foo");
}

function testInit() {
    Person p1 = new; // @error
    Person p2 = new Person(); // @error
}

class Person2 {
    string name;
    function init() returns string? { // @error
        self.name = "";
        return "foo";
    }
}

class Person3 {
    string name;
    function init() returns error { // @error
        self.name = "";
        return error("failed to create Person3");
    }
}

type FooErrData record {| string f; string message?; error cause?; |};
type FooErr error<FooErrData>;
type BarErrData record {| string b; string message?; error cause?; |};
type BarErr error<BarErrData>;

class Person4 {
    string name;
    function init() returns FooErr|BarErr { // @error
        self.name = "";
        return error FooErr("Foo Error", f = "foo");
    }
}

class Too {
    public function init() {}
    function name() { self.init(); }
}

function callInitFunction() {
    Too t = new;
    t.init(); // @error
}
