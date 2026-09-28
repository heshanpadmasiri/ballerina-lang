type Foo record {|
    string s;
    string|int...;
|};

type Bar record {|
    string s;
    string|int|float...;
|};

function testRestFieldToRestField2() returns Bar {
    Foo f = {s: "qwerty", "rest1": "asdf", "rest2": 123};
    Bar b = f;
    b["rest3"] = 23.45; // @panic
    return b;
}

public function main() {
    _ = testRestFieldToRestField2();
}
