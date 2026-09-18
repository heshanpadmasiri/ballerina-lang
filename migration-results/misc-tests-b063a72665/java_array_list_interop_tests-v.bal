import ballerina/io;
import ballerina/jballerina.java;

public function main() {
    [handle, int, string] result = interopWithJavaArrayList();
    io:println(java:toString(result[0]) ?: ""); // @output [Ballerina, Language, Specification]
    io:println(result[1]); // @output 3
    io:println(result[2]); // @output Specification
}

public function interopWithJavaArrayList() returns [handle, int, string] {
    handle aList = newArrayListWithInitialSize(10);
    boolean _ = addElement(aList, java:fromString("Ballerina"));
    boolean _ = addElement(aList, java:fromString("Language"));
    boolean _ = addElement(aList, java:fromString("Specification"));
    handle element = getElement(aList, 2);
    string? strElement = java:toString(element);
    int listSize = size(aList);
    return [arrayListToString(aList), listSize, strElement ?: ""];
}

public function newArrayListWithInitialSize(int initialSize) returns handle = @java:Constructor {
    'class: "java.util.ArrayList",
    paramTypes: ["int"]
} external;

public function addElement(handle receiver, handle e) returns boolean = @java:Method {
    name: "add",
    'class: "java.util.ArrayList"
} external;

public function arrayListToString(handle receiver) returns handle = @java:Method {
    'class: "java.util.ArrayList",
    name: "toString"
} external;

public function size(handle receiver) returns int = @java:Method {
    'class: "java.util.ArrayList"
} external;

public function getElement(handle receiver, int index) returns handle = @java:Method {
    name: "get",
    'class: "java.util.ArrayList"
} external;
