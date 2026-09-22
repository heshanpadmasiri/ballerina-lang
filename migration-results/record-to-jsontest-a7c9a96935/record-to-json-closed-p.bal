type Foo record {|
    int i = 10;
    string s = "foo";
    float f = 12.34;
    decimal d = 23.456;
    boolean b = true;
    byte byt = 127;
    json j = {"name": "Pubudu"};
|};

public function main() {
    Foo f = {};
    json j = f;
    assert(<map<json>>{"i": 10, "s": "foo", "f": 12.34, "d": 23.456d, b: true, "byt": 127,
        "j": {"name": "Pubudu"}}, j);

    map<json> mJ = <map<json>>j;
    mJ["newField"] = 20; // @panic
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
