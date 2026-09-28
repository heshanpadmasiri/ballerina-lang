import ballerina/jballerina.java;

function returnStringForBUnionFromJava() returns int|float|string = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
