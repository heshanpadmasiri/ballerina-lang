// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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


function testInvalidTypes(map<map<int|error>> a) {
    match a {
        var {x: p, ...oth} if p is anydata => {
            map<error> m = p; // @error
            map<map<int>> n = oth; // @error
        }
    }
}

function testInvalidTypesWithJson(json j) returns [int, map<boolean>] {
    match j {
        var {x, ...y} => {
            return [x, y]; // @error // @error
        }
        var {a: z} => {
            return [z, {a: z}]; // @error // @error
        }
    }
    return [0, {}];
}

type RecOne record {| int a; boolean b; string c; |};

function testInvalidTypesWithEmptyRestPattern(RecOne rec) {
    match rec {
        var {a, b, c, ...d} => {
            int x = d; // @error
        }
    }
}

type Person record {|
    int id;
    string name;
    boolean employed;
|};

function testInvalidTypeWithClosedRecord(Person person) {
    match person {
        var {id, ...rest} => {
            boolean a = id; // @error
            map<boolean> b = rest; // @error
        }
    }
}

type ClosedRecordWithOneField record {|
    int i;
|};

type EmptyClosedRecord record {|
|};

function testInvalidTypesWithClosedRecordUnion(ClosedRecordWithOneField|EmptyClosedRecord rec) {
    match rec {
        var {i, ...rest} => {
            string m = i; // @error
            boolean n = rest; // @error
        }
        var {...rest} => {
            string n = rest; // @error
        }
    }
}

type B map<int> & readonly;

function captureBindingPatternNegative2(B v) returns string {
    string s = "No match";

    match v {
        var x => {
            string c = x; // @error
        }
    }
    return s;
}
