import ballerina/jballerina.java;

function getIntFromJsonInt(int|string x) returns int = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
