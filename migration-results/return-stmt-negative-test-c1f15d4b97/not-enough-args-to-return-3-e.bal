function testNotEnoughArgsToReturn3(string s) returns [string, string, int] {
    return split(s), // @error
        "sameera"; // @error
}

function split(string s) returns string {
    return s;
}
