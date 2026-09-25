// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.value;
function testFreezeOnValuesOfNonAnydataType() {
    PersonObj p = new;
    PersonObj q = value:cloneReadOnly(p); // @error
}

function testFreezeOnMapWithoutAnydata() {
    map<PersonObj> m1 = {};
    _ = m1.cloneReadOnly(); // @error
}

function testFreezeOnArrayWithoutAnydata() {
    PersonObj[] a1 = [];
    _ = a1.cloneReadOnly(); // @error

    (PersonObjTwo|PersonObj)?[] a2 = [];
    _ =  a2.cloneReadOnly(); // @error
}

function testFreezeOnTupleWithoutAnydata() {
    PersonObj po = new;
    PersonObjTwo po2 = new;
    [PersonObj|PersonObjTwo, PersonObjTwo] t1 = [po, po2];
    _ = t1.cloneReadOnly(); // @error
}

function testFreezeOnRecordWithoutAnydata() {
    Department d1 = { head: new };
    _ = d1.cloneReadOnly(); // @error
}

function testInvalidAssignmentWithFreeze() {
    map<string|PersonObj> m = {};
    map<string|PersonObj> m1 = m.cloneReadOnly(); // @error

    map<[string|PersonObj, FreezeAllowedDepartment|float]> m2 = {};
    map<[any, any]> m3 = m2.cloneReadOnly(); // @error

    (boolean|PersonObj|float)?[] a1 = [];
    (boolean|PersonObj|float)?[] a2 = a1.cloneReadOnly(); // @error

    any[] a3 = a1.cloneReadOnly(); // @error

    [string|PersonObj, FreezeAllowedDepartment|float] t1 = ["", 0.0];
    [string|PersonObj, FreezeAllowedDepartment|float] t2 = t1.cloneReadOnly(); // @error

    FreezeAllowedDepartment fd = { head: "" };
    FreezeAllowedDepartment fd2 = fd.cloneReadOnly(); // @error

    string|PersonObj u1 = "hi";
    string|PersonObj u2 = u1.cloneReadOnly(); // @error
}

function testFreezeOnError() {
    error e = error("test error");
    _ = e.cloneReadOnly(); // @error
}

function testInvalidComplexMapFreeze() {
    map<string|PersonObj> m1 = {};
    PersonObj p = new;

    m1["one"] = "one";
    m1["two"] = p;

    map<string|PersonObj>|error res = m1.cloneReadOnly(); // @error
}

function testInvalidComplexArrayFreeze()  {
    (string|stream<int>|float)?[] a1 = [];
    int[] intList = [10, 20, 30, 40, 50];
    stream<int> p = intList.toStream();
    a1[0] = 2.0;
    a1[1] = "hello world";
    a1[2] = p;

    (string|stream<int>|float)?[]|error res = a1.cloneReadOnly(); // @error
}

function testInvalidComplexRecordFreeze() {
    PersonObj p = new;
    PersonObj p1 = new;
    PersonObj p2 = new;
    FreezeAllowedDepartment2 fd = { head: p, "e1": p1, "e2": 10 };
    FreezeAllowedDepartment2|error res = fd.cloneReadOnly(); // @error
}

function testInvalidComplexTupleFreeze() {
    PersonObj p = new;
    [int, string|PersonObj|float, boolean] t1 = [1, p, true];
    any|error res = t1.cloneReadOnly(); // @error
}

function testInvalidComplexUnionFreeze() {
    PersonObj p = new;
    int|Department|PersonObj u1 = p;

    int|Department|PersonObj|error res = u1.cloneReadOnly(); // @error
}

function testErrorValueFreeze() {
    error e = error("test error");
    anydata|error val = e;

    anydata res = val.cloneReadOnly(); // @error
}

class PersonObj {
    string name = "";

    function getName() returns string {
        return self.name;
    }
}

class PersonObjTwo {
    string id = "";

    function getId() returns string {
        return self.id;
    }
}

type Department record {|
    PersonObj head;
    PersonObjTwo...;
|};

type FreezeAllowedDepartment record {|
    PersonObj|string head;
    (PersonObjTwo|string)...;
|};

type FreezeAllowedDepartment2 record {|
    PersonObj|string head;
    (PersonObj|int)...;
|};

