import ballerina/io;
import ballerina/jballerina.java;

function newByteArrayOutputStream() returns handle = @java:Constructor {
    'class: "java.io.ByteArrayOutputStream"
} external;

function newDataOutputStream(handle byteAOS) returns handle = @java:Constructor {
    'class: "java.io.DataOutputStream"
} external;

function writeBoolean(handle dataOS, boolean value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeByte(handle dataOS, byte value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeShort(handle dataOS, int value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeChar(handle dataOS, int value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeInt(handle dataOS, int value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeLong(handle dataOS, int value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeFloat(handle dataOS, float value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function writeDouble(handle dataOS, float value) returns error? = @java:Method {
    'class: "java.io.DataOutputStream"
} external;

function toByteArray(handle byteAOS) returns handle = @java:Method {
    'class: "java.io.ByteArrayOutputStream"
} external;

function newByteArrayInputStream(handle bytes) returns handle = @java:Constructor {
    'class: "java.io.ByteArrayInputStream"
} external;

function newDataInputStream(handle byteAIS) returns handle = @java:Constructor {
    'class: "java.io.DataInputStream"
} external;

function readBoolean(handle dataIS) returns boolean | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readByte(handle dataIS) returns byte | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readShort(handle dataIS) returns int | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readChar(handle dataIS) returns int | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readInt(handle dataIS) returns int | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readLong(handle dataIS) returns int | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readFloat(handle dataIS) returns float | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

function readDouble(handle dataIS) returns float | error = @java:Method {
    'class: "java.io.DataInputStream"
} external;

public function main() returns error? {
    handle byteAOS = newByteArrayOutputStream();
    handle dataOS = newDataOutputStream(byteAOS);
    check writeBoolean(dataOS, true);
    check writeByte(dataOS, 8);
    check writeShort(dataOS, 567);
    check writeChar(dataOS, 65);
    check writeInt(dataOS, 345866);
    check writeLong(dataOS, 42343242);
    check writeFloat(dataOS, 234242423.0);
    check writeDouble(dataOS, 8781233342322.324234);

    handle byteAIS = newByteArrayInputStream(toByteArray(byteAOS));
    handle dataIS = newDataInputStream(byteAIS);
    io:println(check readBoolean(dataIS)); // @output true
    io:println(check readByte(dataIS)); // @output 8
    io:println(check readShort(dataIS)); // @output 567
    io:println(check readChar(dataIS)); // @output 65
    io:println(check readInt(dataIS)); // @output 345866
    io:println(check readLong(dataIS)); // @output 42343242
    io:println(check readFloat(dataIS)); // @output 2.34242416E8
    io:println(check readDouble(dataIS)); // @output 8.781233342322324E12
}
