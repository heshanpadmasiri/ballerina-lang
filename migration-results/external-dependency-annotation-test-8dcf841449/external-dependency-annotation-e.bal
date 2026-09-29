import ballerina/http;
import ballerina/jballerina.java;

@java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on const
const int CONSTANT = 1;

@java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on annotation
annotation true Example on function;

@java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on var
int moduleVariable = 1;

@java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on listener
listener http:Listener httpListener = new (9090);

@java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on service
service / on new http:Listener(9091) {
}

function usesParameter(
    @java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on parameter
    int value
) returns
    @java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on return
    int {
    return value;
}

class MethodsAndFields {
    @java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on object_field, field
    int value = 0;

    @java:ExternalDependency
    function method() {
    }
}

type RecordWithField record {
    @java:ExternalDependency // @error annotation 'ballerina/jballerina.java:0.0.0:ExternalDependency' is not allowed on record_field, field
    int value;
};
