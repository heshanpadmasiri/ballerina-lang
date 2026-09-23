import ballerina/io;
import ballerina/lang.'float as floats;
import ballerina/lang.'int as ints;

function intToFloat(int value) returns float {
    float result;
    result = <float>value;
    return result;
}

function intToString(int value) returns string {
    string result;
    result = value.toString();
    return result;
}

function intToAny(int value) returns any {
    any result;
    result = value;
    return result;
}

function floatToInt(float value) returns int {
    int result;
    result = <int>value;
    return result;
}

function floatToString(float value) returns string {
    string result;
    result = value.toString();
    return result;
}

function floatToAny(float value) returns any {
    any result;
    result = value;
    return result;
}

function stringToInt(string value) returns int|error {
    int result;
    result = check ints:fromString(value);
    return result;
}

function stringToFloat(string value) returns float|error {
    float result;
    result = check floats:fromString(value);
    return result;
}

function stringToAny(string value) returns any {
    any result;
    result = value;
    return result;
}

function booleanToString(boolean value) returns string {
    string result;
    result = value.toString();
    return result;
}

function booleanToAny(boolean value) returns any {
    any result;
    result = value;
    return result;
}

function anyToInt() returns int|error {
    int i = 5;
    any a = i;
    int value;
    value = check trap <int>a;
    return value;
}

function anyToFloat() returns float|error {
    float f = 5.0;
    any a = f;
    float value;
    value = check trap <float>a;
    return value;
}

function anyToString() returns string {
    string s = "test";
    any a = s;
    string value;
    value = <string>a;
    return value;
}

function anyToBoolean() returns boolean|error {
    boolean b = false;
    any a = b;
    boolean value;
    value = check trap <boolean>a;
    return value;
}

function booleanappendtostring(boolean value) returns string {
    string result;
    result = value.toString() + "-append-" + value.toString();
    return result;
}

public function main() returns error? {
    io:println(intToFloat(55555555)); // @output 5.5555555E7
    io:println(intToString(111)); // @output 111
    io:println(intToAny(1)); // @output 1
    io:println(floatToInt(222222.44444f)); // @output 222222
    io:println(floatToString(111.333f).substring(0, 7)); // @output 111.333
    io:println(floatToAny(111.333f)); // @output 111.333
    io:println(check stringToInt("100")); // @output 100
    float|error floatResult = stringToFloat("2222.333f");
    if floatResult is error {
        io:println(floatResult.detail()["message"]); // @output 'string' value '2222.333f' cannot be converted to 'float'
    }
    io:println(stringToAny("adfs sadfasd")); // @output adfs sadfasd
    io:println(booleanToString(true)); // @output true
    io:println(booleanToAny(true)); // @output true
    io:println(booleanappendtostring(true)); // @output true-append-true
    io:println(check anyToInt()); // @output 5
    io:println(check anyToFloat()); // @output 5.0
    io:println(anyToString()); // @output test
    io:println(check anyToBoolean()); // @output false
}
