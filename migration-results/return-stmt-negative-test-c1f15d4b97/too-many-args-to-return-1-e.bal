function testTooManyArgsToReturn1(string s) returns string {
    return split(s), // @error
        "sameera"; // @error
}

function split(string s) returns string {
    return s;
}
