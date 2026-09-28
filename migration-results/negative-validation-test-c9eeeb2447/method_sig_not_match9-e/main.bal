import ballerina/jballerina.java;

function decimalParamAsObjectAndReturn(decimal a1) returns decimal = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
