function testMultiValueInSingleContext(string s) returns [string, int, string] {
    return [split(s), 5, "ss"]; // @error
}

function split(string s) returns [string, int] {
    return [s, 4];
}
