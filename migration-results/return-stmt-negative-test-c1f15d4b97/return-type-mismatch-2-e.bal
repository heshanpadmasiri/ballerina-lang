function testInputTypeMismatch(string s) returns [string, int, boolean] {
    return [split(s), 5, 5]; // @error
}

function split(string s) returns string {
    return s;
}
