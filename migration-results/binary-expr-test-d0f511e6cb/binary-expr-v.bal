import ballerina/io;

public function main() {
    io:println(makeChild(true, true)); // @output true
    io:println(makeChild(true, false)); // @output false
    io:println(makeChild(false, true)); // @output false
    io:println(makeChild(false, false)); // @output false

    io:println(multiBinaryANDExpression(true, false, true)); // @output false
    io:println(multiBinaryORExpression(true, false, true)); // @output true
    io:println(multiBinaryExpression(true, false, true)); // @output false

    [int, byte, byte, byte] bitwiseResults = bitwiseAnd(5, 6, 7, 8);
    io:println(bitwiseResults[0]); // @output 4
    io:println(bitwiseResults[1]); // @output 5
    io:println(bitwiseResults[2]); // @output 0
    io:println(bitwiseResults[3]); // @output 0

    binaryAndWithQuery();
    binaryOrWithQuery();
}

function makeChild(boolean stone, boolean value) returns (boolean) {
    boolean result = false;
    // stone and valuable
    if (stone && value) {
        result = true;
        // same as above
    } else if (value && stone) {
        result = true;
    } else if (value || !stone) {
        result = false;
        // not stone or valuable
    } else if (!stone || !value) {
        result = false;
    } else if (stone || !value) {
        result = false;
    }
    return result;
}

function multiBinaryANDExpression(boolean one, boolean two, boolean three) returns (boolean) {
    return one && two && three;
}

function multiBinaryORExpression(boolean one, boolean two, boolean three) returns (boolean) {
    return one || two || three;
}

function multiBinaryExpression(boolean one, boolean two, boolean three) returns (boolean) {
    return (!one || (two && three)) || (!three || (one && two));
}

function bitwiseAnd(int a, int b, byte c, byte d) returns [int, byte, byte, byte] {
    [int, byte, byte, byte] res = [0, 0, 0, 0];
    res[0] = a & b;
    res[1] = a & c;
    res[2] = c & d;
    res[3] = b & d;
    return res;
}

function binaryAndWithQuery() {
    int? i = 3;
    boolean result = i is int && (from var _ in [1, 2]
        where i + 2 == 5
        select 2) == [2, 2];
    assertTrue(result);
}

function binaryOrWithQuery() {
    int? i = 3;
    boolean result = i is () || (from var _ in [1, 2]
        where i + 2 == 5
        select 2) == [2, 2];
    assertTrue(result);
}

function assertTrue(boolean actual) {
    if actual {
        return;
    }
    panic error(string `expected 'true', found '${actual.toString()}'`);
}
