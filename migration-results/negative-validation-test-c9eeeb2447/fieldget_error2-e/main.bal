import ballerina/jballerina.java;

public function interopFieldGetError() {
    boolean ans = isEmpty(2); // @error
}

function isEmpty(int arg) returns boolean = @java:FieldGet { // @error
    name:"isEmpty",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
