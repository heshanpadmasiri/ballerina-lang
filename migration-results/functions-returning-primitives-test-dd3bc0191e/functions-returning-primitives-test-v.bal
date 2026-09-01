import ballerina/io;
import ballerina/jballerina.java;

// Interop function that returns a Ballerina boolean for a Java boolean.
function testReturningBBooleanJBoolean(handle receiver, handle strValue) returns boolean {
    return contentEquals(receiver, strValue);
}

function contentEquals(handle receiver, handle strValue) returns boolean = @java:Method {
    'class: "java.lang.String",
    paramTypes: ["java.lang.String"]
} external;

// Interop function that returns a Ballerina byte for a Java byte.
function testReturningBByteJByte(handle receiver) returns byte {
    return byteValue(receiver);
}

function byteValue(handle receiver) returns byte = @java:Method {
    'class: "java.lang.Long"
} external;

// Interop function that returns a Ballerina int for a Java long.
function testReturningBIntJLong(handle receiver) returns int {
    return longValue(receiver);
}

function longValue(handle receiver) returns int = @java:Method {
    name: "longValue",
    'class: "java.lang.Long"
} external;

// Interop function that returns a Ballerina float for a Java double.
function testReturningBFloatJDouble(handle receiver) returns float {
    return doubleValue(receiver);
}

function doubleValue(handle receiver) returns float = @java:Method {
    name: "doubleValue",
    'class: "java.lang.Double"
} external;

function longFromString(handle value) returns handle = @java:Method {
    name: "valueOf",
    'class: "java.lang.Long",
    paramTypes: ["java.lang.String"]
} external;

function doubleFromString(handle value) returns handle = @java:Method {
    name: "valueOf",
    'class: "java.lang.Double",
    paramTypes: ["java.lang.String"]
} external;

public function main() {
    handle stringReceiver = java:fromString("Ballerina Language");
    handle stringValue = java:fromString("Ballerina Language");
    io:println(testReturningBBooleanJBoolean(stringReceiver, stringValue)); // @output true

    handle byteReceiver = longFromString(java:fromString("4"));
    io:println(testReturningBByteJByte(byteReceiver)); // @output 4

    handle intReceiver = longFromString(java:fromString("10"));
    io:println(testReturningBIntJLong(intReceiver)); // @output 10

    handle floatReceiver = doubleFromString(java:fromString("4"));
    io:println(testReturningBFloatJDouble(floatReceiver)); // @output 4.0
}
