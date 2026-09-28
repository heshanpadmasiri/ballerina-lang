import ballerina/jballerina.java;

function decimalParamAndWithBigDecimal(decimal a1) returns decimal = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
