import ballerina/io;

var intValue = 10;

var stringValue = "Ballerina";

var decimalValue = 100.0d;

var booleanValue = true;

var byteValue = <byte>2;

var floatValue = 2.0;

function testGetInt() returns int {
    return intValue;
}

function testGetString() returns string {
    return stringValue;
}

function testGetDecimal() returns decimal {
    return decimalValue;
}

function testGetBoolean() returns boolean {
    return booleanValue;
}

function testGetByte() returns byte {
    return byteValue;
}

function testGetFloat() returns float {
    return floatValue;
}

// ---------------------------------------------------------------------------------------------------------------------

var value = getValue();

function getValue() returns map<string> {
    map<string> m = { "k": "v" };
    return m;
}

function testFunctionInvocation() returns map<string> {
    return value;
}

// ---------------------------------------------------------------------------------------------------------------------

map<string> data = { "x": "y" };

var v = data;

function testVarAssign() returns map<string> {
    return v;
}

public function main() {
    io:println(testGetInt()); // @output 10
    io:println(testGetString()); // @output Ballerina
    io:println(testGetDecimal()); // @output 100.0
    io:println(testGetBoolean()); // @output true
    io:println(testGetByte()); // @output 2
    io:println(testGetFloat()); // @output 2.0
    io:println(testFunctionInvocation()); // @output {"k":"v"}
    io:println(testVarAssign()); // @output {"x":"y"}
}
