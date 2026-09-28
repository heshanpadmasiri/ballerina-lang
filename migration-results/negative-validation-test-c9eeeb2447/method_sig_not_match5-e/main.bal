import ballerina/jballerina.java;

public function acceptStringErrorReturnWhichThrowsCheckedException(string s) = @java:Method { // @error
    'class:"org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;
