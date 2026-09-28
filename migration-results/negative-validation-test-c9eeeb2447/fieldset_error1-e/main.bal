import ballerina/jballerina.java;

public function interopFieldSetError() {
    isEmpty(true);
}

function isEmpty(boolean arg) = @java:FieldSet { // @error
    name:"isEmpty",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
