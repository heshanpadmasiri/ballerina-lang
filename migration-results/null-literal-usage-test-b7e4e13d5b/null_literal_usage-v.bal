// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

json gJ = null;

function testNullAssignment() returns json {
    json j = null;
    return j;
}

function testNullInField() returns string? {
    json j = {name: "John", age: 25, location: null};
    string? l = j.location === null ? () : <string> checkpanic j.location;
    return l;
}

function testNullStringRepresentation() returns string|error {
    json j = null;
    return j.toString();
}

function testNullStringRepresentation2() returns string {
    json j = null;
    return j.toJsonString();
}

function testNullStringRepresentation3() returns string|error {
    json j = {name: "John Doe", age: 25, location: null};
    return j.toString();
}

function testNullStringRepresentation4() returns string {
    json j = {name: "John Doe", age: 25, location: null};
    return j.toString();
}

function testNullStringRepresentation5() returns string {
    json j = null;
    return j.toBalString();
}

function testNullReturn() returns json {
    return null;
}

function testNullReturn2() returns json|int {
    int x = 100;
    return x > 50 ? null : x;
}

function testNullInFnParams() returns json {
    return utilFn(null);
}

function utilFn(json j) returns json {
    return j;
}

function testNullInATuple() returns [int, json, string] {
    [int, json, string] tup = [50, null, "foo"];
    return tup;
}

function testNullWithTypeGuard() returns boolean {
    json j = {name: "John Doe", age: 25, location: null};
    json|xml val = j;

    if val is json {
        if val.location === null {
            return true;
        }
    }

    return false;
}

function testNullWithMatch() returns string {
    json j = null;

    match j {
        0 => {
            return "0";
        }
        null => {
            return "null";
        }
    }

    return "";
}

function testNullInArray() returns json {
    json[] ar = [5, null, "foo"];
    return ar[1];
}

function testNullInNestedTernaryExpr() returns json {
    json j1 = {name: "John", age: 25, location: null};
    json j2 = (j1.location === null ? "then" : "else") == "" ? null : null;
    return j2;
}

public function main() {
    io:println(testNullAssignment()); // @output
    io:println(testNullInField()); // @output
    io:println(checkpanic testNullStringRepresentation()); // @output
    io:println(testNullStringRepresentation2()); // @output null
    io:println(checkpanic testNullStringRepresentation3()); // @output {"name":"John Doe","age":25,"location":null}
    io:println(testNullStringRepresentation4()); // @output {"name":"John Doe","age":25,"location":null}
    io:println(testNullStringRepresentation5()); // @output ()
    io:println(testNullReturn()); // @output
    io:println(testNullReturn2()); // @output
    io:println(testNullInFnParams()); // @output
    [int, json, string] tuple = testNullInATuple();
    io:println(tuple[0]); // @output 50
    io:println(tuple[1]); // @output
    io:println(tuple[2]); // @output foo
    io:println(testNullWithTypeGuard()); // @output true
    io:println(testNullWithMatch()); // @output null
    io:println(testNullInArray()); // @output
    io:println(testNullInNestedTernaryExpr()); // @output
}
