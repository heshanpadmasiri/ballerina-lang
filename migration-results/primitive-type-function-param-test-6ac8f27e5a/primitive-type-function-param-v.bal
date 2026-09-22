import ballerina/io;
import ballerina/jballerina.java;

public function main() {
    handle boxedBoolean = testCreateBoxedBooleanFromBBoolean(true);
    io:println(booleanValue(boxedBoolean)); // @output true

    handle boxedByte = testCreateBoxedByteFromBByte(130);
    io:println(signedByteValue(boxedByte)); // @output -126

    handle boxedLong = testCreateBoxedLongFromBInt(100000000);
    io:println(longValue(boxedLong)); // @output 100000000

    handle boxedDouble = testCreateBoxedDoubleFromBFloat(30000000.00);
    io:println(doubleValue(boxedDouble)); // @output 3.0E7
}

public function testCreateBoxedBooleanFromBBoolean(boolean value) returns handle {
    return createBoxedBooleanFromBBoolean(value);
}

function createBoxedBooleanFromBBoolean(boolean value) returns handle = @java:Constructor {
    'class: "java.lang.Boolean",
    paramTypes: ["boolean"]
} external;

function booleanValue(handle value) returns boolean = @java:Method {
    'class: "java.lang.Boolean",
    name: "booleanValue",
    paramTypes: []
} external;

public function testCreateBoxedByteFromBByte(byte value) returns handle {
    return createBoxedByteFromBByte(value);
}

function createBoxedByteFromBByte(byte value) returns handle = @java:Constructor {
    'class: "java.lang.Byte",
    paramTypes: ["byte"]
} external;

function signedByteValue(handle value) returns int {
    int unsignedValue = byteValue(value);
    return unsignedValue > 127 ? unsignedValue - 256 : unsignedValue;
}

function byteValue(handle value) returns int = @java:Method {
    'class: "java.lang.Byte",
    name: "byteValue",
    paramTypes: []
} external;

public function testCreateBoxedLongFromBInt(int value) returns handle {
    return createBoxedLongFromBInt(value);
}

function createBoxedLongFromBInt(int value) returns handle = @java:Constructor {
    'class: "java.lang.Long",
    paramTypes: ["long"]
} external;

function longValue(handle value) returns int = @java:Method {
    'class: "java.lang.Long",
    name: "longValue",
    paramTypes: []
} external;

public function testCreateBoxedDoubleFromBFloat(float value) returns handle {
    return createBoxedDoubleFromBFloat(value);
}

function createBoxedDoubleFromBFloat(float value) returns handle = @java:Constructor {
    'class: "java.lang.Double",
    paramTypes: ["double"]
} external;

function doubleValue(handle value) returns float = @java:Method {
    'class: "java.lang.Double",
    name: "doubleValue",
    paramTypes: []
} external;
