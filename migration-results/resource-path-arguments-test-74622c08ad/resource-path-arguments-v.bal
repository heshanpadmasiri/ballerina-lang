// Copyright (c) 2023, WSO2 LLC. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import ballerina/io;
import ballerina/jballerina.java;
import ballerina/test;

public type OrderItemTargetType typedesc<anydata>;

public client isolated class Client {
    public isolated function init() {
    }

    isolated resource function get abc/[string ...path]() returns int = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray"]
    } external;

    isolated resource function get abc/[int id]/[float v]/[string path]/[string ...paths]() returns int = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray"]
    } external;

    isolated resource function get def/[string path]/[int path1]/[string path2]/[int ...path3]() returns int = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray"]
    } external;

    isolated resource function get abc/[int id]/[string path](float f, string s) returns int = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray", "double", "io.ballerina.runtime.api.values.BString"]
    } external;

    isolated resource function get abc/[int id]/[string path]/[string p2](string a, float f, string s) returns int = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray", "io.ballerina.runtime.api.values.BString", "double", "io.ballerina.runtime.api.values.BString"]
    } external;

    isolated resource function get def/[int id]/[string path]/[string p2](string s) returns string = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.Environment", "io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray", "io.ballerina.runtime.api.values.BString"]
    } external;

    isolated resource function get ghi/[int id]/[string p1]/[string p2]/[int ...ids](string s) returns string = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResource",
        paramTypes: ["io.ballerina.runtime.api.Environment", "io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BArray", "io.ballerina.runtime.api.values.BString"]
    } external;

    isolated resource function get orderitem/[string orderId]/[string itemId](OrderItemTargetType targetType = <>) returns targetType = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResourceOne"
    } external;

    isolated resource function get orderitem(OrderItemTargetType targetType = <>) returns targetType = @java:Method {
        'class: "org/ballerinalang/nativeimpl/jvm/tests/StaticMethods",
        name: "getResourceTwo"
    } external;
}

public function testResourceFuncWithMultiplePathParams() {
    Client cl = new;
    var response = cl->/abc/[1]/[2.5]/abc/def/ghi/jkl/mno/pqr/stu/vwx/yz();
    test:assertEquals(response, 4);
    io:println(response); // @output 4

    response = cl->/abc/abc/def/ghi/jkl/mno/pqr/stu/vwx/yz();
    test:assertEquals(response, 9);
    io:println(response); // @output 9

    response = cl->/def/abc/[1001]/def/[101]/[10002]();
    test:assertEquals(response, 4);
    io:println(response); // @output 4

    response = cl->/abc/[1]/["2"](1.2, "a");
    test:assertEquals(response, 2);
    io:println(response); // @output 2

    response = cl->/abc/[1]/["2"]/["3"]("a", 1.2, "a");
    test:assertEquals(response, 3);
    io:println(response); // @output 3

    string res = cl->/def/[1]/["2"]/["3"]("a");
    test:assertEquals(res, "a");
    io:println(res); // @output a

    res = cl->/ghi/[1]/["aaa"]/["bbb"]/[4]/[5]/[6]/[7]/[8]/[9]("xyz");
    test:assertEquals(res, "xyz");
    io:println(res); // @output xyz

    res = cl->/orderitem/["1234"]/["abcd"].get();
    test:assertEquals(res, "getResourceOne");
    io:println(res); // @output getResourceOne

    res = cl->/orderitem.get();
    test:assertEquals(res, "getResourceTwo");
    io:println(res); // @output getResourceTwo
}

public function main() {
    testResourceFuncWithMultiplePathParams();
}
