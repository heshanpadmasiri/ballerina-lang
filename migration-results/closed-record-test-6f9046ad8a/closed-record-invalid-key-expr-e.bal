type Foo record {|
    string s;
    int i?;
|};
float f = 1.0;
string s = "not s";
function getInt() returns int { return 1; }
function getString(string s) returns string { return s; }
function testInvalidExprAsRecordKey() {
    Foo f1 = {s: "str", [f]: 1.0}; // @error
    Foo f2 = {[getString("s")]: "str"}; // @error
    Foo f3 = {s: "str", [getInt()]: 1}; // @error
    Foo f4 = {s: "str", [getString(true)]: 1}; // @error
    Foo f5 = {[s]: "str"}; // @error
    error e = error("test error");
    Foo f6 = {s: "str", [getString("e")]: e}; // @error
}
function testNonExistentKeyInOptionalType() {
    Foo? f1 = {s: "foo", invalid: 123}; // @error
    ()|Foo f2 = {s: "foo", x: 123, y: "hello", z: 34.56}; // @error
}
