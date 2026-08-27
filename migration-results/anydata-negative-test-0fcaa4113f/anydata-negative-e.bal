// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and limitations under the License.

type Foo record {|
    int ra = 0;
    any...;
|};

class Bar {
    int oa = 0;
}

type Employee record {|
    int id;
    string name;
    float salary;
|};

type ValueType int|float|string|boolean|byte;
type DataType ValueType|json|xml|Bar|map<anydata>|anydata[]|();

function testInvalidAssignmentsWithLiterals() {
    anydata|map<int> adrl = {a: 15}; // @error
    anydata|map<int|float> adcrl = {ca: 30}; // @error
    map<json>|anydata adjl = { name: "apple", color: "red", price: 40 }; // @error
}

function testInvalidMapAssignments() {
    anydata ad;

    map<any> m = {};
    ad = m; // @error

    map<any> m2 = {};
    ad = m2; // @error

    map<Bar> mo = {};
    ad = mo; // @error

    map<function (string) returns boolean> mfp = {};
    ad = mfp; // @error

    map<typedesc<any>> mtd = {};
    ad = mtd; // @error

    map<any[]> mar = {};
    ad = mar; // @error

    map<map<map<any>>> mnested = {};
    ad = mnested; // @error

    map<Foo> mr = {};
    ad = mr; // @error

    map<[DataType, string]> mtup = {};
    ad = mtup; // @error

    map<[[DataType, string], Bar]> mtup2 = {};
    ad = mtup2; // @error

    map<DataType> mu = {};
    ad = mu; // @error
}

function testInvalidArrayAssignments() {
    anydata ad;

    Bar[] abar = [];
    ad = abar; // @error

    (function (string) returns boolean)?[] afp = [];
    ad = afp; // @error

    any[] aa = [];
    ad = aa; // @error

    typedesc<any>[] atd = [];
    ad = atd; // @error

    any[][] a2a = [];
    ad = a2a; // @error

    map<any>[] am = [];
    ad = am; // @error

    map<Bar>[] ambar = [];
    ad = ambar; // @error

    Foo[] ar = [];
    ad = ar; // @error

    DataType[] au = [];
    ad = au; // @error

    [[DataType, string], int, float][] atup = [];
    ad = atup; // @error
}

function testInvalidUnionAssignments() {
    DataType dt = "hello world!";
    anydata ad = dt; // @error
}

function testInvalidTupleAssignments() {
    [int, float, Bar] t1 = [10, 23.45, new Bar()];
    anydata ad = t1; // @error

    [DataType, int] t2 = ["hello world!", 10];
    ad = t2; // @error

    [[DataType, int], string, int] t3 = [["hello world!", 10], "foo", 20];
    ad = t3; // @error
}

function testInvalidMapInsertions() {
    map<anydata> m = {};
    m["bar"] = new Bar(); // @error

    DataType dt = "hello world!";
    m["datatype"] = dt; // @error
}

function testErrorAsAnydata() {
    error e = error("test err");
    anydata ad = e; // @error
}

function testErrorAsAMemberOfAnydata() {
     (anydata|error)[] x = [error("")];
     anydata y = x; // @error
}

type TANY table<map<any>>;
type TERR table<map<error>>;

public function testInvalidTableAssignment() {
    TANY tany = table [{"a": 2}];
    anydata _ = tany; // @error

    TERR terror = table [{"e": error("Message")}];
    anydata _ = terror; // @error
}

type Bar1 record {|
   int id;
   any a;
|};

type Foo1 record {|
   int id;
   Bar1 b;
|};

public function testInvalidJsonInvocation() {
   table<map<any>> tbl = table [
            {a: "x", b: 3},
            {c: "z", d: 5}
   ];

   json _ = tbl.toJson(); // @error

   table<Foo1> tb = table[
         {id: 1, b: {id: 1, a: 5}}
   ];

   json _ = tb.toJson(); // @error
}

function testInvalidAssignmentToReadonlyAnydata() {
    anydata a = [];
    map<anydata> a1 = {};

    anydata & readonly b = a; // @error
    anydata[] & readonly c = a; // @error
    b = a1; // @error
}
