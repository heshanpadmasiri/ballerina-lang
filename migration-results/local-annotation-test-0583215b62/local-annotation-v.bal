import ballerina/io;
import ballerina/jballerina.java;

// Resource-method annotations are read directly at runtime through the supplied Java reflection helper.

annotation map<int> t1 on service;
annotation map<string> t2 on object function;

int globalInt = 10;
string globalString = "hello";

public function main() {
    boolean[6] results = testAnnotEvaluation();
    io:println(results[0]); // @output true
    io:println(results[1]); // @output true
    io:println(results[2]); // @output true
    io:println(results[3]); // @output true
    io:println(results[4]); // @output true
    io:println(results[5]); // @output true
}

function testAnnotEvaluation() returns boolean[6] {
    var [a1, b1, c1] = getAnnotsAndService();
    int origGlobalInt = 10;
    string origGlobalString = "hello";

    boolean v1 = a1 is map<int> && a1["one"] == origGlobalInt && a1["two"] == 22;
    boolean v2 = b1 is map<string> && b1["strOne"] == "one" && b1["two"] == origGlobalString;

    int u1 = 321;
    string u2 = "world";
    globalInt = u1;
    globalString = u2;

    var [a2, b2, _] = getAnnotsAndService();

    boolean v3 = a2 is map<int> && a2["one"] == u1 && a2["two"] == 22;
    boolean v4 = b2 is map<string> && b2["strOne"] == "one" && b2["two"] == u2;

    typedesc<any> t = typeof c1;
    map<int>? m1 = t.@t1;
    map<string>? m2 = <map<string>?> getResourceAnnot(c1, "get", ["res"], "t2");

    boolean v5 = m1 is map<int> && m1["one"] == origGlobalInt && m1["two"] == 22;
    boolean v6 = m2 is map<string> && m2["strOne"] == "one" && m2["two"] == origGlobalString;

    return [v1, v2, v3, v4, v5, v6];
}

function getAnnotsAndService() returns [map<int>?, map<string>?, service object {}] {
    service object {} ser = @t1 {
        one: globalInt,
        two: 22
    } service object {
        @t2 {
            strOne: "one",
            two: globalString
        }
        resource function get res() {
        }
    };

    typedesc<any> t = typeof ser;
    map<int>? m1 = t.@t1;
    map<string>? m2 = <map<string>?> getResourceAnnot(ser, "get", ["res"], "t2");
    return [m1, m2, ser];
}

function getResourceAnnot(service object {} obj, string methodName, string[] path, string annotName) returns any =
@java:Method {
    'class: "org/ballerinalang/nativeimpl/jvm/servicetests/ServiceValue",
    name: "getResourceMethodAnnotations"
} external;
