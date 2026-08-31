import ballerina/io;

type ACTION GET|POST;

const GET = "GET";
const POST = "POST";

function testTypeConstants() returns ACTION {
    return GET;
}

const constActionWithType = "GET";

function testConstWithTypeAssignmentToType() returns ACTION {
    ACTION action = constActionWithType;
    return action;
}

const constActionWithoutType = "GET";

function testConstWithoutTypeAssignmentToType() returns ACTION {
    ACTION action = constActionWithoutType;
    return action;
}

function testConstAndTypeComparison() returns boolean {
    return "GET" == GET;
}

function testTypeConstAsParam() returns boolean {
    return typeConstAsParam(GET);
}

function typeConstAsParam(ACTION a) returns boolean {
    return "GET" == a;
}

const boolean booleanWithType = false;

type BooleanTypeWithType booleanWithType;

function testBooleanTypeWithType() returns BooleanTypeWithType {
    BooleanTypeWithType t = false;
    return t;
}

const booleanWithoutType = true;

type BooleanTypeWithoutType booleanWithoutType;

function testBooleanTypeWithoutType() returns BooleanTypeWithoutType {
    BooleanTypeWithoutType t = true;
    return t;
}

const int intWithType = 40;

type IntTypeWithType intWithType;

function testIntTypeWithType() returns IntTypeWithType {
    IntTypeWithType t = 40;
    return t;
}

const intWithoutType = 20;

type IntTypeWithoutType intWithoutType;

function testIntTypeWithoutType() returns IntTypeWithoutType {
    IntTypeWithoutType t = 20;
    return t;
}

const byte byteWithType = 240;

type ByteTypeWithType byteWithType;

function testByteTypeWithType() returns ByteTypeWithType {
    ByteTypeWithType t = 240;
    return t;
}

const float floatWithType = 4.0;

type FloatTypeWithType floatWithType;

function testFloatTypeWithType() returns FloatTypeWithType {
    FloatTypeWithType t = 4.0;
    return t;
}

const floatWithoutType = 2.0;

type FloatTypeWithoutType floatWithoutType;

function testFloatTypeWithoutType() returns FloatTypeWithoutType {
    FloatTypeWithoutType t = 2.0;
    return t;
}

const decimal decimalWithType = 4.0;

type DecimalTypeWithType decimalWithType;

function testDecimalTypeWithType() returns DecimalTypeWithType {
    DecimalTypeWithType t = 4.0;
    return t;
}

const string stringWithType = "Ballerina is awesome";

type StringTypeWithType stringWithType;

function testStringTypeWithType() returns StringTypeWithType {
    StringTypeWithType t = "Ballerina is awesome";
    return t;
}

const stringWithoutType = "Ballerina rocks";

type StringTypeWithoutType stringWithoutType;

function testStringTypeWithoutType() returns StringTypeWithoutType {
    StringTypeWithoutType t = "Ballerina rocks";
    return t;
}

public function main() {
    io:println(testTypeConstants()); // @output GET
    io:println(testConstWithTypeAssignmentToType()); // @output GET
    io:println(testConstWithoutTypeAssignmentToType()); // @output GET
    io:println(testConstAndTypeComparison()); // @output true
    io:println(testTypeConstAsParam()); // @output true
    io:println(testBooleanTypeWithType()); // @output false
    io:println(testBooleanTypeWithoutType()); // @output true
    io:println(testIntTypeWithType()); // @output 40
    io:println(testIntTypeWithoutType()); // @output 20
    io:println(testByteTypeWithType()); // @output 240
    io:println(testFloatTypeWithType()); // @output 4.0
    io:println(testFloatTypeWithoutType()); // @output 2.0
    io:println(testDecimalTypeWithType()); // @output 4.0
    io:println(testStringTypeWithType()); // @output Ballerina is awesome
    io:println(testStringTypeWithoutType()); // @output Ballerina rocks
}
