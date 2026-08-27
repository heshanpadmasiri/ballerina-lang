type Foo1 record {|
    string s;
    int...;
|};

annotation Foo1 f1 on type, class;

@f1 {
    s: "str",
    i: 1 // @error
}
class Bar1 {
}

type Foo3 record {|
    string s;
    int i;
    float fl;
|};

type Foo4 record {|
    string s;
    int i;
|};

Foo4 fl = {s: "str", i: 2};

annotation Foo3 f3 on type, class;

@f3 {
    i: 1,
    fl: 1.0,
    ...fl, // @error
    s: "hi" // @error
}
class Bar3 {
}
