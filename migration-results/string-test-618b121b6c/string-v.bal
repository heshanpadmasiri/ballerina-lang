import ballerina/io;

function hasPrefix(string s, string prefix) returns boolean {
    return s.startsWith(prefix);
}

function hasSuffix(string s, string suffix) returns boolean {
    return s.endsWith(suffix);
}

function indexOf(string s, string str) returns int? {
    return s.indexOf(str);
}

function substring(string s, int beginIndex, int endIndex) returns string {
    return s.substring(beginIndex, endIndex);
}

function toLower(string s) returns string {
    return s.toLowerAscii();
}

function toUpper(string s) returns string {
    return s.toUpperAscii();
}

function trim(string s) returns string {
    return s.trim();
}

function intValueOf(int i) returns string {
    return i.toString();
}

function floatValueOf(float f) returns string {
    return f.toString();
}

function booleanValueOf(boolean b) returns string {
    return b.toString();
}

function stringValueOf(string s) returns string {
    return s.toString();
}

function xmlValueOf(xml x) returns string {
    return x.toString();
}

function jsonValueOf(json j) returns string? {
    return j.toJsonString();
}

function lengthOfStr(string j) returns int {
    return j.length();
}

function toByteArray(string l) returns byte[] {
    return l.toBytes();
}

public function main() {
    io:println(booleanValueOf(true)); // @output true
    io:println(floatValueOf(1.3450000286102295).substring(0, 5)); // @output 1.345
    io:println(hasPrefix("Expendables", "Ex")); // @output true
    io:println(hasSuffix("One Two", "Two")); // @output true
    io:println(indexOf("Lion in the town", "in")); // @output 5
    io:println(indexOf("Lion🦁 in the town", "in")); // @output 6
    io:println(indexOf("Lion🦁 in the town", "🦁")); // @output 4
    io:println(indexOf("Lion🦁 in the town", "Lion")); // @output 0
    io:println(intValueOf(25)); // @output 25
    io:println(jsonValueOf({name: "chanaka"})); // @output {"name":"chanaka"}
    io:println(lengthOfStr("Bandwagon")); // @output 9
    io:println(stringValueOf("This is a String")); // @output This is a String
    io:println(substring("testValues", 0, 9)); // @output testValue
    io:println(substring("test💇🏾‍♂️Values", 0, 12)); // @output test💇🏾‍♂️Val
    io:println(substring("test👩🏼‍⚖️️️Values", 0, 4)); // @output test
    io:println(substring("test👩🏾‍🍼️️Values", 0, 8)); // @output test👩🏾‍🍼
    io:println(toLower("COMPANY")); // @output company
    io:println(toUpper("company")); // @output COMPANY
    io:println(trim(" This is a String ")); // @output This is a String
    io:println(xmlValueOf(xml `<test>name</test>`)); // @output <test>name</test>
    byte[] bytes = toByteArray("Sample Ballerina Byte Array Content");
    io:println(bytes.length()); // @output 35
    io:println(bytes[0]); // @output 83
    io:println(bytes[1]); // @output 97
    io:println(bytes[2]); // @output 109
    io:println(bytes[3]); // @output 112
    io:println(bytes[4]); // @output 108
    io:println(bytes[5]); // @output 101
    io:println(bytes[6]); // @output 32
    io:println(bytes[7]); // @output 66
    io:println(bytes[8]); // @output 97
    io:println(bytes[9]); // @output 108
    io:println(bytes[10]); // @output 108
    io:println(bytes[11]); // @output 101
    io:println(bytes[12]); // @output 114
    io:println(bytes[13]); // @output 105
    io:println(bytes[14]); // @output 110
    io:println(bytes[15]); // @output 97
    io:println(bytes[16]); // @output 32
    io:println(bytes[17]); // @output 66
    io:println(bytes[18]); // @output 121
    io:println(bytes[19]); // @output 116
    io:println(bytes[20]); // @output 101
    io:println(bytes[21]); // @output 32
    io:println(bytes[22]); // @output 65
    io:println(bytes[23]); // @output 114
    io:println(bytes[24]); // @output 114
    io:println(bytes[25]); // @output 97
    io:println(bytes[26]); // @output 121
    io:println(bytes[27]); // @output 32
    io:println(bytes[28]); // @output 67
    io:println(bytes[29]); // @output 111
    io:println(bytes[30]); // @output 110
    io:println(bytes[31]); // @output 116
    io:println(bytes[32]); // @output 101
    io:println(bytes[33]); // @output 110
    io:println(bytes[34]); // @output 116
}
