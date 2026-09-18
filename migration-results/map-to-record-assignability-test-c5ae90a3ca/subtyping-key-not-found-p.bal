type Foo record {|
    int a;
    int...;
|};

type Bar record {|
    int a;
|};

function testSubtyping() {
    map<Bar> m1 = {"bb": {a: 10}};
    record {| Foo...; |} r1 = m1;
    Foo f1 = r1.get("bb");
    assert(<Foo>{a: 10}, f1);
    assert(<Bar>{a: 10}, f1);
    f1["cc"] = 20; // @panic
}

public function main() {
    testSubtyping();
}

function assert(anydata expected, anydata actual) {
    if (expected != actual) {
        typedesc<anydata> expT = typeof expected;
        typedesc<anydata> actT = typeof actual;
        string detail = "expected [" + expected.toString() + "] of type [" + expT.toString()
                            + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
        panic error("{AssertionError}", message = detail);
    }
}
