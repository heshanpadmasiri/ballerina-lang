import ballerina/jballerina.java;

public function interopFieldGetError() {
    boolean ans = isAvailable(2); // @error
}

function isAvailable(int arg) returns boolean = @java:FieldGet { // @error
    name:"isAvailable",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
