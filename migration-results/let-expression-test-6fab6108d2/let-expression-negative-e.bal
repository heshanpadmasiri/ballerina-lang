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

function redclaredVar() {
    int x = 5;
    int b = let int x = 4 in 2 * x; // @error
}

function undefinedVar() {
    int b = let int x = 4*y, int y = 2 in 2 * x; // @error
}

function wrongTypes() {
    int b = let int x = "hello" in 2 * x; // @error
    int c = let string x = "hello" in x; // @error
    int d = let string x = fun() in x.length(); // @error
    string p = let string x = "hello" in fun(); // @error
}

function fun() returns int {
    return 1;
}

function invalidTypesWithAnonymousRecord() {
    record {
        byte i;
        int j?;
    } rec1 = let int v = 160 in {i: v}; // @error

    record {
        string i;
        int j?;
    } rec2 = let string v = "160" in {i: v, j: "invalid"}; // @error

    rec2.j = 2.0; // @error
}

class FooClass {
    public function init(int m) {
    }
}

function testLetWithClass() {
    FooClass foo = let int m = 5 in new (m, m); // @error
}

function testSelfReferencingVarInLet() {
    string s = let string[] ar = [s] in ar[0]; // @error
    string m = let [string, string] [a, b] = [a] in a; // @error
    string n = let [string, string] [k, l] = [n] in l; // @error
    string x1 = let string x2 = x1 in let string[] x3 = [x2] in x3[0]; // @error
    [int, string] [y1, y2] = [let int x = y1, int z = y2 in z * x * 12, y2]; // @error // @error // @error // @error
    string z1 = let map<string> z2 = {z1} in z2["ar"] ?: "nil"; // @error
    string v1 = let string v2 = "A" in let string[] v3 = [func(v3)] in v3[0]; // @error
    Person pr = new;
    string a1 = let [string, string] [a2, a3] = [pr.getName(a1)] in a2; // @error
    string a4 = let [string, string] [a2, a3] = [pr.getName(a4), getString(a3)] in a2; // @error // @error
    string a5 = let [string, string] [a2, a3] = [getString(a5), getString(a3)] in a2; // @error // @error
    string a6 = let [string, string] a2 = [getString(a2), "A"] in a2[0]; // @error // @error
    string a7 = let map<string> a8 = {a7} in getString(a7); // @error // @error
    string a9 = let map<string> a8 = {"1": a8} in pr.getName(a9); // @error // @error // @error
    string a10 = let map<string> a8 = {"1": getString(a10)} in a8["1"] ?: "nil"; // @error
    string a11 = let map<string> a8 = {"1": getString(a8)} in pr.getName(a11); // @error // @error // @error
}

class Person {
    string name = "sample name";

    public function getName(string a) returns string {
        return self.name + " " + a;
    }
}

type A record {
    int a;
};

function testLetWithXMLTemplateExpression() {
    xml _ = xml `<Books>${xml `<Book>"${let A y = {a: 1} in y}"</Book>`}</Books>`; // @error
}

function func(string[] k) returns string {
    return "CDE" + k[0];
}

function getString(string s) returns string {
    return "This is a string:" + s;
}
