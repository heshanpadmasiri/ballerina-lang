import ballerina/io;
import ballerina/jballerina.java;

public function main() {
    byte byteValue = 100;
    io:println(shortByteValue(testCreateJShortFromBByte(byteValue))); // @output 100
    io:println(characterValue(testCreateJCharacterFromBByte(byteValue))); // @output 100
    io:println(integerByteValue(testCreateJIntegerFromBByte(byteValue))); // @output 100
    io:println(longByteValue(testCreateJLongFromBByte(byteValue))); // @output 100
    io:println(floatValue(testCreateJFloatFromBByte(byteValue))); // @output 100.0
    io:println(doubleValue(testCreateJDoubleFromBByte(byteValue))); // @output 100.0

    int intValue = 4;
    io:println(byteLongValue(testCreateJByteFromBInt(intValue))); // @output 4
    io:println(shortLongValue(testCreateJShortFromBInt(intValue))); // @output 4
    io:println(characterValue(testCreateJCharacterFromBInt(intValue))); // @output 4
    io:println(integerLongValue(testCreateJIntFromBInt(intValue))); // @output 4
    io:println(floatLongValue(testCreateJFloatFromBInt(intValue))); // @output 4
    io:println(doubleLongValue(testCreateJDoubleFromBInt(intValue))); // @output 4

    float floatValue = 4.0;
    io:println(byteDoubleValue(testCreateJByteFromBFloat(floatValue))); // @output 4.0
    io:println(shortDoubleValue(testCreateJShortFromBFloat(floatValue))); // @output 4.0
    io:println(characterDoubleValue(testCreateJCharacterFromBFloat(floatValue))); // @output 4.0
    io:println(integerDoubleValue(testCreateJIntFromBFloat(floatValue))); // @output 4.0
    io:println(longDoubleValue(testCreateJLongFromBFloat(floatValue))); // @output 4.0
    io:println(floatDoubleValue(testCreateJFloatFromBFloat(floatValue))); // @output 4.0
}

public function testCreateJShortFromBByte(byte value) returns handle => createJShortFromBByte(value);
public function createJShortFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Short", paramTypes: ["short"]
} external;

public function testCreateJCharacterFromBByte(byte value) returns handle => createJCharacterFromBByte(value);
public function createJCharacterFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Character", paramTypes: ["char"]
} external;

public function testCreateJIntegerFromBByte(byte value) returns handle => createJIntegerFromBByte(value);
public function createJIntegerFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Integer", paramTypes: ["int"]
} external;

public function testCreateJLongFromBByte(byte value) returns handle => createJLongFromBByte(value);
public function createJLongFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Long", paramTypes: ["long"]
} external;

public function testCreateJFloatFromBByte(byte value) returns handle => createJFloatFromBByte(value);
public function createJFloatFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Float", paramTypes: ["float"]
} external;

public function testCreateJDoubleFromBByte(byte value) returns handle => createJDoubleFromBByte(value);
public function createJDoubleFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Double", paramTypes: ["double"]
} external;

public function testCreateJByteFromBInt(int value) returns handle => createJByteFromBInt(value);
public function createJByteFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Byte", paramTypes: ["byte"]
} external;

public function testCreateJShortFromBInt(int value) returns handle => createJShortFromBInt(value);
public function createJShortFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Short", paramTypes: ["short"]
} external;

public function testCreateJCharacterFromBInt(int value) returns handle => createJCharacterFromBInt(value);
public function createJCharacterFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Character", paramTypes: ["char"]
} external;

public function testCreateJIntFromBInt(int value) returns handle => createJIntFromBInt(value);
public function createJIntFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Integer", paramTypes: ["int"]
} external;

public function testCreateJFloatFromBInt(int value) returns handle => createJFloatFromBInt(value);
public function createJFloatFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Float", paramTypes: ["float"]
} external;

public function testCreateJDoubleFromBInt(int value) returns handle => createJDoubleFromBInt(value);
public function createJDoubleFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Double", paramTypes: ["double"]
} external;

public function testCreateJByteFromBFloat(float value) returns handle => createJByteFromBFloat(value);
public function createJByteFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Byte", paramTypes: ["byte"]
} external;

public function testCreateJShortFromBFloat(float value) returns handle => createJShortFromBFloat(value);
public function createJShortFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Short", paramTypes: ["short"]
} external;

public function testCreateJCharacterFromBFloat(float value) returns handle => createJCharacterFromBFloat(value);
public function createJCharacterFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Character", paramTypes: ["char"]
} external;

public function testCreateJIntFromBFloat(float value) returns handle => createJIntFromBFloat(value);
public function createJIntFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Integer", paramTypes: ["int"]
} external;

public function testCreateJLongFromBFloat(float value) returns handle => createJLongFromBFloat(value);
public function createJLongFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Long", paramTypes: ["long"]
} external;

public function testCreateJFloatFromBFloat(float value) returns handle => createJFloatFromBFloat(value);
public function createJFloatFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Float", paramTypes: ["float"]
} external;

function shortByteValue(handle value) returns int = @java:Method {
    'class: "java.lang.Short", name: "byteValue"
} external;
function characterValue(handle value) returns int = @java:Method {
    'class: "java.lang.Character", name: "charValue"
} external;
function integerByteValue(handle value) returns int = @java:Method {
    'class: "java.lang.Integer", name: "byteValue"
} external;
function longByteValue(handle value) returns int = @java:Method {
    'class: "java.lang.Long", name: "byteValue"
} external;
function floatValue(handle value) returns float = @java:Method {
    'class: "java.lang.Float", name: "floatValue"
} external;
function doubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Double", name: "doubleValue"
} external;

function byteLongValue(handle value) returns int = @java:Method {
    'class: "java.lang.Byte", name: "longValue"
} external;
function shortLongValue(handle value) returns int = @java:Method {
    'class: "java.lang.Short", name: "longValue"
} external;
function integerLongValue(handle value) returns int = @java:Method {
    'class: "java.lang.Integer", name: "longValue"
} external;
function floatLongValue(handle value) returns int = @java:Method {
    'class: "java.lang.Float", name: "longValue"
} external;
function doubleLongValue(handle value) returns int = @java:Method {
    'class: "java.lang.Double", name: "longValue"
} external;

function byteDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Byte", name: "doubleValue"
} external;
function shortDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Short", name: "doubleValue"
} external;
function characterDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Character", name: "charValue"
} external;
function integerDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Integer", name: "doubleValue"
} external;
function longDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Long", name: "doubleValue"
} external;
function floatDoubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Float", name: "doubleValue"
} external;
