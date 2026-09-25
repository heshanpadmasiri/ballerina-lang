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

function testListMatchPatternNegative1() returns string {
    any v = 0;
    match v {
        var a => { // @error
            return "var a";
        }
        [1, 2] => { // unreachable pattern // @error
            return "[1, 2]";
        }
    }
}

function testListMatchPatternNegative2() {
    any v = 0;
    match v {
        var a | [1, 2] => { // unreachable pattern, all match patterns should contain same set of variables // @error
        }
    }
}

function testListMatchPatternNegative3() returns string {
    int v = 2;
    match v {
        [1, 2] => { // pattern will not be matched // @error
            return "[1, 2]";
        }
        [var a, var b] => { // pattern will not be matched // @error
            return "[var a, var b]";
        }
    }
    return "";
}

function testListMatchPatternNegative4() returns string {
    [int, int] v = [1, 2];
    match v {
        _ | [var a, var b] => { // unreachable pattern // @error
            return "_ | [var a, var b]";
        }
    }

    return "No match"; // unreachable code // @error
}

function testListOfMatchPatternsNegative() returns string {
    [int, int] v1 = [1, 2];
    match v1 {
        [var a, 2] | [var a, var b] => { // match patterns should contain same set of variables // @error
            return "match1";
        }
    }

    [int, int] v2 = [1, 2]; // @error
    match v2 {
        [var a, 2] | [var a, var b] | [var a, var b, var c] => { // match patterns should contain same set of variables // @error
                                                                 // pattern will not be matched
                                                                 // unreachable pattern
            return "match1";
        }
    }

    return "No match"; // @error
}

const X = 2;
const Y = 4;
function testSameMatchPatternsNegative1() {
    [int, int] v = [1, 2];
    match v {
        [var a, 2] | [var a, 2] => { // unreachable pattern // @error
        }
        [var a, 3] => { // @error
        }
        [var a, 3] => { // unreachable pattern // @error
        }
        [2, 3] | [2, 3] => { // unreachable pattern // @error
        }
        [2, X] | [2, X] => { // unreachable pattern // @error
        }
        [2, Y] => {
        }
        [2, Y] => { // unreachable pattern // @error
        }
        [var a, 21] if a is int => {
        }
        [var a, 21] if a is int => { // unreachable pattern // @error
        }
    }
}

function testSameMatchPatternsNegative2(any v) {
    match v {
        [var a, var b] => {} // @error
        [var c, var d] => {} // unreachable pattern // @error
    }
}

function testSameMatchPatternsNegative3(any v) {
    match v {
        [var a, ...var b] => {} // @error
        [var c, ...var d] => {} // unreachable pattern // @error
    }
}

function testSameMatchPatternsNegative4(any v) {
    match v {
        [var x, ...var y] => {} // @error
        [var a, var b, ...var c] => {} // unreachable pattern // @error
    }
}

function testSameMatchPatternsNegative5(any v) {
    match v {
        [var a, var b, ...var c] => {} // @error
        [var x, var y, ...var z] => {} // unreachable pattern // @error
    }
}

function testUnreachablePattern1() {
    [int, int] v = [1, 3];

    match v {
        [var a, var b] => { // @error
        }
        [1, 3] => { // unreachable pattern // @error
        }
    }
}

function testUnreachablePattern2() {
    [int, [string]] v = [1, ["3"]];

    match v {
        [var a, [var b]] => { // @error
        }
        [1, ["3"]] => { // unreachable pattern // @error
        }
    }
}


function testUnreachablePattern3() {
    [int, [any]] v = [1, ["3"]];

    match v {
        [var a, [var b]] => { // @error
        }
        [1, ["3"]] => { // unreachable pattern // @error
        }
    }
}

function testUnreachablePattern4() {
    [[int, string]] v = [[1, "3"]];

    match v {
        [[1, var b]] => { // @error
        }
        [[1, "3"]] => { // not an unreachable pattern
        }
    }
}

function testUnreachablePattern5() {
    [any, any] v = [1, 2];
    match v {
        [_, _] => {}
        [1, 2] => {} // unreachable pattern // @error
     }
}

function testListMatchPatternNegative5() {
    any[1] a = [];
    match a {
        [var x, var y] => {} // pattern will not be matched // @error
    }
}

function testUnmatchedPattensForSizeMismatchWithClosedArray(int[3] val) {
    match val {
        [var a, _, var c, var d] => { // @error
        }
        [var a, var b, var c, var d] => { // @error
        }
        [var a, var b] => { // @error
        }
    }
}

public type T1 [string, int]|[int, string]|[int, int];
public type T2 [int, int]|[T2, T2]|[T2[], T2[]];

function testUnrechableMatchPaternWithTuples() {
    T1 t1 = [1, 1];

    match t1 {
        [var x, var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, _] => {
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, ... var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [var x, ... var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

     match t1 {
        [... var x] => {
            _ = x;
        }
        [var x, var y] => { // Warning: unreachable pattern // @error
            _ = [x, y];
        }
    }
}

function testUnrechableMatchPaternWithTuples2() {
    T2 t1 = [[1, 1], [1, 1]];

    match t1 {
        [var x, var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, _] => {
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [_, ... var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [var x, ... var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

     match t1 {
        [... var x] => {
            _ = x;
        }
        [var x, var y] => { // Warning: unreachable pattern // @error
            _ = [x, y];
        }
    }
}

public type T3 [string, int...]|[int, string, decimal...]|[int, int];
public type T4 [int, int]|[T4, T4...]|[T4[], T4[], T4, T4[]...];

function testUnrechableMatchPaternWithTuples3() {
    T3 t1 = [1, 1];

    match t1 {
        [_, ... var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [var x, ... var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

     match t1 {
        [... var x] => {
            _ = x;
        }
        [var x, var y] => { // Warning: unreachable pattern // @error
            _ = [x, y];
        }
    }
}

function testUnrechableMatchPaternWithTuples4() {
    T4 t1 = [[1, 1], [1, 1]];

    match t1 {
        [_, ... var y] => {
            _ = y;
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match t1 {
        [var x, ... var y] => {
            _ = [x, y];
        }
        [...var x] => { // Warning: unreachable pattern // @error
            _ = x;
        }
    }

     match t1 {
        [... var x] => {
            _ = x;
        }
        [var x, var y] => { // Warning: unreachable pattern // @error
            _ = [x, y];
        }
    }
}

public type T5 [string, int];

public function testUnrechableMatchPaternWithTuples5() returns string {
    T5 a = ["string", 1];
    string b;
    match a {
        [_, var x] => {
            _ = x;
            b = "string";
            return b;
        }
    }
    return b; // Error: unreachable code // @error
}

public function testUnrechableMatchPaternWithTuples6() {
    T5 a = ["string", 1];
    match a {
        [_, _] => {
        }
        [...var x] => { //Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match a {
        [var x, _] => {
            _ = x;
        }
        [...var x] => { //Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match a {
        [var x, var y] => {
            _ = x;
            _ = y;
        }
        [...var x] => { //Warning: unreachable pattern // @error
            _ = x;
        }
    }

    match a {
        [...var x] => {
            _ = x;
        }
        [var x, var y] => { //Warning: unreachable pattern // @error
            _ = x;
            _ = y;
        }
    }
}
