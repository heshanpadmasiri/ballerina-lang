import ballerina/jballerina.java;

public function interopFieldGetError() {
    boolean ans = isEmpty(); // @error
}

function isEmpty() returns boolean = @java:FieldGet { // @error
    name:"isEmpty",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
