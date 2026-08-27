class Foo {
    public string s = "";
}

type Bar record {
    string s = "";
};

type Baz 1|2;

public const Baz BAZ = 1;

object {
    public string s;
    public Baz z;
    public Foo foo1;
} anonObj = object { public string s = ""; public Baz z = 1; public Foo foo1 = new; };

public class ParentFoo {
    public int i = 0;
    public ChildFoo c = new(""); // @error
    public Foo f = new; // @error
    public Baz z = 1; // @error

    public function init(int i, ChildFoo c) { // @error
        self.i = i;
        self.c = c;
    }
}

class ChildFoo {
    private string name = "";

    isolated function init(string name) {
        self.name = name;
    }
}

public function fooFunc2(string s, Bar r, int i = 4, Foo... fArg) returns Foo { // @error @error @error
    Foo f = new();
    return f;
}

public function fooFunc3(string s, Bar r, int i = 4, Foo... fArg) returns [Foo, string] { // @error @error @error
    Foo f = new();
    return [f, "G"];
}

public function fooFunc1(Foo fArg) { // @error
    Foo _ = fArg;
}

public function BazFunc(Foo... fArg) returns Baz { // @error @error
    Baz z = 1;
    return z;
}

type FooRecord record {
    string s = "";
    BarRecord br = {};
};

type BarRecord record {
    string s = "";
};

record {
    string s = "";
    Baz z = 1;
    Foo foo1 = new;
    BarRecord br = {};
} anonRecord = {};

public type ParentRecord record {
    int i = 0;
    ChildFoo c = new(""); // @error
    ChildRecord r = {}; // @error
    Foo f = new; // @error
    Baz z = 1; // @error
};

type ChildRecord record {
    string name = "";
};

public function test6(record {
    string s = "";
    Baz z = 1;
    Foo foo1 = new;
    BarRecord br = {};
} anonRecord1) returns string { // @error @error @error
    return "K";
}

public function test7() returns record { // @error @error @error
    string s = "";
    Baz z = 1;
    Foo foo1 = new;
    BarRecord br = {};
} {
    record {
        string s = "";
        Baz z = 1;
        Foo foo1 = new;
        BarRecord br = {};
    } m = {};

    return m;
}
