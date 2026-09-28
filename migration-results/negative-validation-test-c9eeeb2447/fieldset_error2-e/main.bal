import ballerina/jballerina.java;

public function interopFieldSetError() {
    isEmpty(2, true);
}

function isEmpty(int receiver, boolean arg) = @java:FieldSet { // @error
    name:"isEmpty",
    'class:"org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;
