import ballerina/jballerina.java;

public function acceptIntUnionReturnWhichThrowsCheckedException(int s) returns int|string|float|boolean = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
