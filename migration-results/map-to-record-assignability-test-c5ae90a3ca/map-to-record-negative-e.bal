function testMapToRecordNegative() {
    map<int> mInt = {"a": 1, "b": 2};
    record {| string...; |} rInt = mInt; // @error

    map<any> mAny = {"a": 1, "b": "Foo"};
    record {} rAnydata = mAny; // @error

    map<string> m = {"a": "aaa", "b": "bbb"};
    record {|
        string a;
        string...;
    |} r = m; // @error
}

type Foo record {|
    int a;
    int...;
|};

type Bar record {|
    int a;
|};

type Baz record {|
    int a;
    int b?;
    int...;
|};

function testSubtyping() {
    map<Foo> m1 = {"bb": {a: 10}};
    record {|
        Bar...;
    |} r1 = m1; // @error

    map<Bar> m2 = {"bb": {a: 10}, "x": {a: 20}};
    record {|
        Baz x?;
        Foo...;
    |} r2 = m2;
}
