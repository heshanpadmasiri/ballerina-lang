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

function testInvalidRecordAssignment() {
    anydata ad;

    Foo foo = {a: 20};
    ad = foo; // @error

    Foo1 foo1 = {ca: 30};
    ad = foo1; // @error

    Foo2 foo2 = {ca: 40};
    ad = foo2; // @error

    Foo3 foo3 = {ca: 50};
    ad = foo3; // @error

    Foo4 foo4 = {ca: 60}; // @error
    ad = foo4; // @error

    Foo5 foo5 = {ca: 70};
    ad = foo5; // @error

    Foo6 foo6 = {ca: 80};
    ad = foo6; // @error

    Foo7 foo7 = {ca: 90};
    ad = foo7; // @error
}

type Foo record {|
    int aa = 0;
    any a;
    anydata...;
|};

type Foo1 record {|
    int ca;
    Bar2 b = {};
    anydata...;
|};

type Foo2 record {|
    int ca;
    Bar|() b = ();
    anydata...;
|};

type Foo3 record {|
    int ca;
    function (string) returns boolean fp?;
    anydata...;
|};

type Foo4 record {|
    int ca;
    typedesc<any> td;
    anydata...;
|};

type Foo5 record {|
    int ca;
    map<any> m = {};
    anydata...;
|};

type Foo6 record {|
    int ca;
    map<map<Foo2>> m = {};
    anydata...;
|};

type Foo7 record {|
    int ca;
    any[] ar = [];
    anydata...;
|};

class Bar {
    int oa = 0;
}

type Bar2 record {|
    int ra = 0;
    any...;
|};
