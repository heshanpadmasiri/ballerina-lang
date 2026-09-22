import ballerina/io;
import ballerina/jballerina.java;

function testReturningBIntJByte(handle receiver) returns int {
    return getBIntJByte(receiver);
}

function getBIntJByte(handle receiver) returns int = @java:Method {
    name: "byteValue",
    'class: "java.lang.Long"
} external;

function testReturningBIntJShort(handle receiver) returns int {
    return getBIntJShort(receiver);
}

function getBIntJShort(handle receiver) returns int = @java:Method {
    name: "shortValue",
    'class: "java.lang.Long"
} external;

function testReturningBIntJChar(handle receiver) returns int {
    return getBIntJChar(receiver) + 3;
}

function getBIntJChar(handle receiver) returns int = @java:Method {
    name: "charValue",
    'class: "java.lang.Character"
} external;

function testReturningBIntJInt(handle receiver) returns int {
    return getBIntJInt(receiver);
}

function getBIntJInt(handle receiver) returns int = @java:Method {
    name: "intValue",
    'class: "java.lang.Long"
} external;

function testReturningBFloatJByte(handle receiver) returns float {
    return getBFloatJByte(receiver);
}

function getBFloatJByte(handle receiver) returns float = @java:Method {
    name: "byteValue",
    'class: "java.lang.Double"
} external;

function testReturningBFloatJShort(handle receiver) returns float {
    return getBFloatJShort(receiver);
}

function getBFloatJShort(handle receiver) returns float = @java:Method {
    name: "shortValue",
    'class: "java.lang.Double"
} external;

function testReturningBFloatJChar(handle receiver) returns float {
    return getBFloatJChar(receiver);
}

function getBFloatJChar(handle receiver) returns float = @java:Method {
    name: "charValue",
    'class: "java.lang.Character"
} external;

function testReturningBFloatJInt(handle receiver) returns float {
    return getBFloatJInt(receiver);
}

function getBFloatJInt(handle receiver) returns float = @java:Method {
    name: "intValue",
    'class: "java.lang.Double"
} external;

function testReturningBFloatJFloat(handle receiver) returns float {
    return getBFloatJFloat(receiver);
}

function getBFloatJFloat(handle receiver) returns float = @java:Method {
    name: "floatValue",
    'class: "java.lang.Double"
} external;

function newLong(int value) returns handle = @java:Constructor {
    'class: "java.lang.Long",
    paramTypes: ["long"]
} external;

function newDouble(float value) returns handle = @java:Constructor {
    'class: "java.lang.Double",
    paramTypes: ["double"]
} external;

function newCharacter(int value) returns handle = @java:Constructor {
    'class: "java.lang.Character",
    paramTypes: ["char"]
} external;

public function main() {
    handle longReceiver = newLong(10);
    io:println(testReturningBIntJByte(longReceiver)); // @output 10
    io:println(testReturningBIntJShort(longReceiver)); // @output 10
    io:println(testReturningBIntJInt(longReceiver)); // @output 10

    handle charReceiver = newCharacter(68);
    io:println(testReturningBIntJChar(charReceiver)); // @output 71

    handle doubleReceiver = newDouble(4.0);
    io:println(testReturningBFloatJByte(doubleReceiver)); // @output 4.0
    io:println(testReturningBFloatJShort(doubleReceiver)); // @output 4.0
    io:println(testReturningBFloatJInt(doubleReceiver)); // @output 4.0
    io:println(testReturningBFloatJFloat(doubleReceiver)); // @output 4.0

    io:println(testReturningBFloatJChar(charReceiver)); // @output 68.0
}
