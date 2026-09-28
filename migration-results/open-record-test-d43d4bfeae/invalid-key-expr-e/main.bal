type Foo record {
    string s;
    int i?;
};

function testIdentifiersAsRestFieldKeys() {
    Foo _ = {s: "str", i: 1};
    Foo _ = {"s": "str", "i": 1};
    Foo _ = {s: "str", "i": 1};
    Foo _ = {s: "str", "s2": "str 2", "i2": 1};
    Foo _ = {s: "str", s2: "str 2", i2: 1}; // @error
    Foo _ = {s: "str", s2: "str 2", "i2": 1}; // @error
}
