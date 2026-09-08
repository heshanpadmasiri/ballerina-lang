type IntMax 127;
type BooleanOrStringValue true|"abc";

function testJsonAccessWithCheckNegative(json j) returns error? {
    (1|2)[] _ = check j.a; // @error
    string|xml _ = check j.b; // @error
    "foo"|xml[] _ = check j.b; // @error
    int[]|BooleanOrStringValue _ = check j.c; // @error
    IntMax|1d|map<int> _ = check j.d; // @error
}
