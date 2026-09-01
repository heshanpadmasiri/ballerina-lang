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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

function testBasicTypes() {
    _ = start add(5, 2);
    future<int> f1 = start add(5, 2);
    future<boolean> f2 = start status();
    future<string> f3 = start concat("foo");

    int result1 = checkpanic wait f1;
    boolean result2 = checkpanic wait f2;
    string result3 = checkpanic wait f3;

    assertEquality(7, result1);
    assertEquality(true, result2);
    assertEquality("hello foo", result3);
    io:println(result1); // @output 7
    io:println(result2); // @output true
    io:println(result3); // @output hello foo
}

function testBasicTypesWithoutFutureConstraint() {
    future f1 = start add(5, 2);
    future f2 = start status();
    future f3 = start concat("foo");

    any|error result1 = wait f1;
    any|error result2 = wait f2;
    any|error result3 = wait f3;

    assertEquality(7, result1);
    assertEquality(true, result2);
    assertEquality("hello foo", result3);
    io:println(result1); // @output 7
    io:println(result2); // @output true
    io:println(result3); // @output hello foo
}

function testRefTypes() {
    future<xml> a = start xmlFile();
    future<json> b = start getJson();

    xml x = checkpanic wait a;
    json y = checkpanic wait b;

    assertEquality(xml `aaa`, x);
    assertEquality(5, y);
    io:println(x); // @output aaa
    io:println(y); // @output 5
}

function testRefTypesWithoutFutureConstraint() {
    future a = start xmlFile();
    future b = start getJson();

    any|error x = wait a;
    any|error y = wait b;

    assertEquality(xml `aaa`, x);
    assertEquality(5, y);
    io:println(x); // @output aaa
    io:println(y); // @output 5
}

function testArrayTypes() {
    future<int[]> a = start intArray();

    int[] x = checkpanic wait a;

    assertEquality(intArray(), x);
    io:println(x); // @output [1,2,3]
}

function testArrayTypesWithoutFutureConstraint() {
    future a = start intArray();

    any|error x = wait a;

    assertEquality(intArray(), x);
    io:println(x); // @output [1,2,3]
}

function testRecordTypes() {
    future<Person> a = start getNewPerson();

    Person x = checkpanic wait a;

    assertEquality(getNewPerson(), x);
    io:println(x); // @output {"name":"Jane","age":25,"spouse":"John","gender":"female"}
}

function testRecordTypesWithoutFutureConstraint() {
    future a = start getNewPerson();

    any|error x = wait a;

    assertEquality(getNewPerson(), x);
    io:println(x); // @output {"name":"Jane","age":25,"spouse":"John","gender":"female"}
}

function testObjectTypes() {
    future<PersonA> a = start getPersonAObject();

    PersonA x = checkpanic wait a;
    string name = x.getName();

    assertEquality("sample name", name);
    io:println(name); // @output sample name
}

function testObjectTypesWithoutFutureConstraint() {
    future a = start getPersonAObject();

    any x = checkpanic wait a;
    PersonA personA = <PersonA>x;

    int expectedAge = getPersonAObject().age;
    string expectedName = getPersonAObject().name;
    assertEquality(expectedAge, personA.age);
    assertEquality(expectedName, personA.name);
    io:println(personA.age); // @output 10
    io:println(personA.name); // @output sample name
}

function testCustomErrorFuture() {
    future<error> te = start getError();

    error x = wait te;

    assertEquality("SimpleErrorType", x.message());
    io:println(x.message()); // @output SimpleErrorType
}

function testCustomErrorFutureWithoutConstraint() {
    future te = start getError();

    any|error x = wait te;
    string str = (<error>x).toString();

    assertEquality(getError().toString(), str);
    io:println(str); // @output error("SimpleErrorType",message="Simple error occurred")
}

function add(int i, int j) returns int {
    int k = i + j;
    return k;
}

function concat(string name) returns string {
    return "hello " + name;
}

function status() returns boolean {
    return true;
}

function xmlFile() returns xml {
    xml x1 = xml `aaa`;
    return x1;
}

function getJson() returns json {
    json j = 5;
    return j;
}

function intArray() returns int[] {
    int[] j = [1, 2, 3];
    return j;
}

public class PersonA {
    public int age = 10;
    public string name = "sample name";

    public function getName() returns string {
        return self.name;
    }
}

public function getPersonAObject() returns PersonA {
    return new PersonA();
}

type Person record {
    string name = "John";
    int age = 30;
    string spouse?;
};

function getNewPerson() returns Person {
    Person p = {name: "Jane", age: 25, spouse: "John", "gender": "female"};
    return p;
}

function getError() returns error {
    error simpleError = error("SimpleErrorType", message = "Simple error occurred");
    return simpleError;
}

function testFutureTyping() {
    Foo foo1 = {i: 1, "j": "hello"};
    Foo foo2 = {i: 2, "j": "world"};

    future<Foo> f1 = start getFoo();
    any a1 = f1;
    boolean a1IsFoo = a1 is future<Foo>;
    boolean a1IsRecord = a1 is future<record {}>;
    boolean a1IsIntOrFoo = a1 is future<int|Foo>;
    boolean a1IsRecordOrArray = a1 is future<record {}|int[]>;
    boolean a1IsBar = a1 is future<Bar>;
    assertEquality(true, a1IsFoo);
    assertEquality(true, a1IsRecord);
    assertEquality(true, a1IsIntOrFoo);
    assertEquality(true, a1IsRecordOrArray);
    assertEquality(false, a1IsBar);
    io:println(a1IsFoo); // @output true
    io:println(a1IsRecord); // @output true
    io:println(a1IsIntOrFoo); // @output true
    io:println(a1IsRecordOrArray); // @output true
    io:println(a1IsBar); // @output false

    future<Foo|Bar> f2 = start getFoo();
    future<Foo|Bar|int[]> f3 = f2;
    any a2 = f3;
    boolean a2IsFoo = a2 is future<Foo>;
    boolean a2IsRecord = a2 is future<record {}>;
    boolean a2IsIntOrFoo = a2 is future<int|Foo>;
    boolean a2IsRecordOrArray = a2 is future<record {}|int[]>;
    boolean a2IsBar = a2 is future<Bar>;
    assertEquality(true, a2IsFoo);
    assertEquality(true, a2IsRecord);
    assertEquality(true, a2IsIntOrFoo);
    assertEquality(true, a2IsRecordOrArray);
    assertEquality(false, a2IsBar);
    io:println(a2IsFoo); // @output true
    io:println(a2IsRecord); // @output true
    io:println(a2IsIntOrFoo); // @output true
    io:println(a2IsRecordOrArray); // @output true
    io:println(a2IsBar); // @output false
}

type Foo record {
    int i;
};

type Bar record {|
    float f;
|};

function getFoo() returns Foo => {i: 1, "j": "hello"};

function getFooOrBar() returns Foo|Bar => {i: 2, "j": "world"};

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if (expected is anydata && actual is anydata && expected == actual) {
        return;
    }

    if (expected === actual) {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
                 message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    testBasicTypes();
    testBasicTypesWithoutFutureConstraint();
    testRefTypes();
    testRefTypesWithoutFutureConstraint();
    testArrayTypes();
    testArrayTypesWithoutFutureConstraint();
    testRecordTypes();
    testRecordTypesWithoutFutureConstraint();
    testObjectTypes();
    testObjectTypesWithoutFutureConstraint();
    testCustomErrorFuture();
    testCustomErrorFutureWithoutConstraint();
    testFutureTyping();
}
