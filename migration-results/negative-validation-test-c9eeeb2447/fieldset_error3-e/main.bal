import ballerina/jballerina.java;

public function interopFieldSetError() {
    isAvailable();
}

function isAvailable() = @java:FieldSet { // @error
    name:"isAvailable",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
