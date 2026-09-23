import ballerina/io;

function concatBMP() returns string {
    string prefix = "red ";
    string s = "apple";
    return prefix + s;
}

function nonBMPLength() returns int {
    string smiley = "h😀llo";
    return smiley.length();
}

function recordStringValue() returns int {
    string smiley = "h😀llo";
    record {| string myField; |} r = {myField: smiley};
    boolean containsKey = r.hasKey("myField");
    if !containsKey {
        return -1;
    }
    return r.myField.length();
}

function testError() returns int {
    string smiley = "h🤷llo";
    error err = error(smiley);
    return err.message().length();
}

function testArrayStore() returns int {
    string[] arr = [];
    string[][] arr2 = [["h🤷llo", "h🤷llo", "h🤷llo"], ["h🤷llo", "h🤷llo", "h🤷llo"]];
    arr[0] = "h🤷llo";
    return arr[0].length() + arr2[0][1].length();
}

function testStringIndexAccess() {
    string hello = "hello👋";
    string val = hello[5];
    assert(val.length(), 1);

    string str1 = "ABCDEF";
    string:Char testChar1 = str1[1];
    assert(testChar1 is string && testChar1 is string:Char, true);

    testChar1 = str1[1][0][0];
    assert(testChar1 is string && testChar1 is string:Char, true);

    string str2 = indexAccessTestFunc(str1[0]);
    assert(str2[1] is string && str2[1] is string:Char, true);
}

function indexAccessTestFunc(string:Char character) returns string {
    assert(character, "A");
    return character + "M";
}

function anyToStringCasting() returns int {
    any a = "hello👋";
    string k = <string>a;
    return k.length();
}

function anydataToStringCast() returns int {
    anydata a = "hello👋";
    string k = <string>a;
    return k.length();
}

function assert(anydata actual, anydata expected) {
    if expected == actual {
        return;
    }
    typedesc<anydata> expT = typeof expected;
    typedesc<anydata> actT = typeof actual;
    string reason = "expected [" + expected.toString() + "] of type [" + expT.toString()
                            + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
    panic error(reason);
}

public function main() {
    io:println(concatBMP()); // @output red apple
    io:println(nonBMPLength()); // @output 5
    io:println(recordStringValue()); // @output 5
    io:println(testError()); // @output 5
    io:println(testArrayStore()); // @output 10
    testStringIndexAccess();
    io:println(anyToStringCasting()); // @output 6
    io:println(anydataToStringCast()); // @output 6
}
