// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.runtime;
import ballerina/lang.value;

public function main() {
    io:println(testDecimalToString()); // @output 7
    io:println(testFunctionPointerToString()); // @output 41
    io:println(testMapToString()); // @output 81
    io:println(testMapToStringWithSymbol()); // @output 84
    io:println(testArrayToString()); // @output 22
    io:println(testTupleToString()); // @output 20
    io:println(testJsonToString()); // @output 18
    io:println(testObjectToString()); // @output 13
    io:println(testArrayValueToString()); // @output 30
    io:println(testFutureValueToString()); // @output future {isDone:true,result:true}
    io:println(testFutureValueToStringWithNilReturn()); // @output future {isDone:true,result:}
}

function testDecimalToString() returns int {
    decimal res3 = 8;
    string s = "test 🏹" + res3.toString();
    return s.length();
}

function testFunctionPointerToString() returns int {
    return foo(hello);
}

public function hello() returns int {
    return "say 🏖️".length();
}

function foo(function () returns int bar) returns int {
    string s = "what 💼 ";
    return s.length() + bar.toString().length();
}

function testMapToString() returns int {
    map<string> addrMap = {line1: "No. 20", line2: "Palm Grove",
        city: "Colombo 03", country: "Sri Lanka"};
    return addrMap.toString().length();
}

function testMapToStringWithSymbol() returns int {
    map<string> addrMap = {line1: "No. 20", line2: "Palm Grove 🎬",
        city: "Colombo 03", "country🔲": "Sri Lanka"};
    return addrMap.toString().length();
}

function testTupleToString() returns int {
    [int, string, string] a = [10, "John🥄", "Silva"];
    return a.toString().length();
}

function testArrayToString() returns int {
    string[] arr = ["10", "John🚰", "Silva"];
    return arr.toString().length();
}

function testJsonToString() returns int {
    json j9 = {"smile👍": "smile"};
    return j9.toString().length();
}

class Person {
    public string name = "Riyafa";
}

function testObjectToString() returns int {
    Person p3 = new Person();
    return value:toString(p3).length();
}

function testArrayValueToString() returns int {
    string[][] arr2 = [["h🤷llo", "h🤷llo", "h🤷llo"], ["h🤷llo", "h🤷llo", "h🤷llo"]];
    return arr2[0].toString().length() + arr2[0][1].toString().length();
}

function testFutureValueToString() returns string {
    future<boolean> f = start isEven(2);
    runtime:sleep(1);
    return f.toString();
}

function isEven(int n) returns boolean {
    return n % 2 == 0;
}

function testFutureValueToStringWithNilReturn() returns string {
    future<()> f = start addName();
    runtime:sleep(1);
    return f.toString();
}

function addName() {}
