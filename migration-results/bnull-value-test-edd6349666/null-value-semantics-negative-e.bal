function testInvalidFunctionCallWithNull() returns (any) {
    string? s = ();
    return foo(s);
}

function foo(string? s) returns (string?) {
    return s;
}

function testLogicalOperationOnNull1() returns (boolean) {
    xml? x = ();
    return (() > x); // @error
}

function testNullForValueType1() {
    int a = (); // @error
}

function testArithmaticOperationOnNull() returns (any) {
    return (null + null); // @error
}

function testNullForValueType2() {
    string s = (); // @error
}

function testNullForValueType3() {
    json j = null;
}

function testArithmaticOperationOnNull2() returns (any) {
    return (() + ()); // @error
}

type A A[]|int;
type Person record {| string name; |};

function testNullValueNegativeScenarios() {
    string a = null; // @error
    string|int b = null; // @error
    map<string> c = null; // @error
    A d = null; // @error
    int[] e = [null]; // @error
    [string, int] f = [null, 2]; // @error
    Person g = null; // @error
}
