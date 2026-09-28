import ballerina/jballerina.java;

public function acceptIntErrorUnionReturnWhichThrowsCheckedException(int flag) returns int = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
