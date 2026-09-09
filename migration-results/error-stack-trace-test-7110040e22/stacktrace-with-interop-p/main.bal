import ballerina/jballerina.java;

public function testErrorStacktraceWithInterop() {
    errorStacktraceTest();
}

function errorStacktraceTest() = @java:Method { // @panic
    'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods"
} external;

public function main() {
    testErrorStacktraceWithInterop();
}
