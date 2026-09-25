import ballerina/jballerina.java;

function newInstanceMethods() returns handle = @java:Constructor {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function uncheckedErrorDetail(handle receiver) returns int = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external; // @panic

public function main() {
    handle receiver = newInstanceMethods();
    int _ = uncheckedErrorDetail(receiver);
}
