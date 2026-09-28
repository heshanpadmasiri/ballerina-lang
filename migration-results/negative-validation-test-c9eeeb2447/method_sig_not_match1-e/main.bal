import ballerina/jballerina.java;

public function acceptIntReturnIntThrowsCheckedException(int a) returns int = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
