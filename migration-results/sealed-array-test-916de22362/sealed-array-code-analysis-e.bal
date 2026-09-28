// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

record {|
   int[*] x = [1]; // @error
|} _ = {x:[2]};

function value(int[*] a = [1]) returns int[] { // @error
    return [10];
}

public function invalidInferredArrays() {
    function (int[*] a = [1]) returns int[] _ = value; // @error
    var _ = function(int b) returns int {[int[*]] _ = [[1]]; int[*] _ = [32]; return b;}; // @error
    var _ = function(int[3] b) returns int[*] {return [2, 3];}; // @error

    boolean b3 = true;
    if (b3) {
        int[*] _ = [12,12];
    }
}

function fn1() returns int[*] & readonly { // @error
    return [2];
}

function fn2() returns string[*]|string[1] { // @error
    return ["1"];
}

function fn3() returns int[] & readonly|string[*]|int[*] { // @error @error
    return ["1"];
}

function fn4(int[*] x = [1]) { // @error
}

[int[*]] a2 = [[1]]; // @error
[string|int[*], float] a3 = [[1], 1.2]; // @error
[int[*] & readonly, float] a4 = [[1], 1.2]; // @error

map<int[*]> a5 = {"1" : [3]}; // @error
map<float|int[*]> a6 = {"1" : [3]}; // @error
map<int[*]> a7 = {}; // @error
function (int[*] b = [1]) returns int[] _ = function(int[*] b = [1]) returns int[*] {return [2, 3];}; // @error @error @error
var _ = function(int b) returns int {[int[*]] _ = [[1]]; int[*] _ = [32]; return b;}; // @error
var _ = function(int[3] b) returns int[*] {return [2, 3];}; // @error
