import ballerina/io;

function variableDefaultValue() returns [int, boolean, string, float] {
    int i = 0;
    boolean b = false;
    string s = "";
    float f = 0.0;

    return [i, b, s, f];
}

function inlineVarInit() returns [int, boolean, string, float] {
    int i = 10;
    boolean b = true;
    string s = "hello";
    float f = 2.6;

    return [i, b, s, f];
}

function updateVarValue(int v1, boolean v3, string v4, float v5) returns [int, boolean, string, float] {
    int i = 10;
    boolean b = true;
    string s = "hello";
    float f = 2.6;

    i = v1;
    b = v3;
    s = v4;
    f = v5;

    return [i, b, s, f];
}

string str = "";
float _ = 3.14;
var _ = 10 * 30;
int x = let var _ = 10 in 10 * 20;

function wildCardLocalVariables() {
    float _ = 3.14;
    var _ = 10 * 30;
    int _ = let var _ = 10 in 10 * 20;
    string _ = foo();
    assertEquality("foo invoked", str);
}

function foo() returns string {
    str += "foo invoked";
    return str;
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    [int, boolean, string, float] defaults = variableDefaultValue();
    io:println(defaults[0]); // @output 0
    io:println(defaults[1]); // @output false
    io:println(defaults[2]); // @output
    io:println(defaults[3]); // @output 0.0

    [int, boolean, string, float] inline = inlineVarInit();
    io:println(inline[0]); // @output 10
    io:println(inline[1]); // @output true
    io:println(inline[2]); // @output hello
    io:println(inline[3]); // @output 2.6

    [int, boolean, string, float] updatedDefault = updateVarValue(56, false, "newstr", 68.3325);
    io:println(updatedDefault[0]); // @output 56
    io:println(updatedDefault[1]); // @output false
    io:println(updatedDefault[2]); // @output newstr
    io:println(updatedDefault[3]); // @output 68.3325

    [int, boolean, string, float] updated = updateVarValue(56, false, "newstr", 68.3325);
    io:println(updated[0]); // @output 56
    io:println(updated[1]); // @output false
    io:println(updated[2]); // @output newstr
    io:println(updated[3]); // @output 68.3325

    wildCardLocalVariables();
}
