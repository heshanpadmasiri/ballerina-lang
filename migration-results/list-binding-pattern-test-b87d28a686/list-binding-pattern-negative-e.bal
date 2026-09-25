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

function testListMatchPatternNegative() returns string {
    any v1 = 0;
    match v1 {
        var a => { // @error
            return "var a";
        }
        var [a, b] => { // @error unreachable pattern
            return "var [a, b]";
        }
    }

    any v2 = 0; // @error unreachable code
    match v2 {
        var a | var [a, b] => { // @error unreachable pattern, all match patterns should contain same set of variables
            return "var a | var [a, b]";
        }
    }

    int v3 = 2; // @error unreachable code
    match v3 {
        var [a, b] => { // @error pattern will not be matched
            return "var [a, b]";
        }
        [var [a], var [b]] => { // @error pattern will not be matched
            return "[var [a], var [b]]";
        }
    }

    [int, int] v5 = [1, 2];
    match v5 {
        _ | var [a, b] => { // @error unreachable pattern
            return "_ | var [a, b]";
        }
    }

    return "No match"; // @error unreachable code
}

function testListOfMatchPatternsNegative() returns string {
    [int, int] v1 = [1, 2];
    match v1 {
        [var a, 2] | var [a, b] => { // @error match patterns should contain same set of variables
            return "match1";
        }
    }

    [int, int] v2 = [1, 2]; // @error unreachable code
    match v2 {
        [var a, 2] | var [a, b] | var [a, b, c] => { // @error match patterns should contain same set of variables
                                                     // pattern will not be matched, unreachable pattern
            return "match1";
        }
    }

    return "No match"; // @error unreachable code
}

const X = 2;
const Y = 4;
function testSameMatchPatternsNegative1() {
    [any, any] v = [1, 2];
    match v {
        var [a, b] | var [a, b] => { // @error unreachable pattern
        }
        var [a, b, c] if a is int => { // @error pattern will not be matched, unreachable pattern
        }
        var [a, b, c] if b is int => { // @error pattern will not be matched, unreachable pattern
        }
        var [a, b, c] if a is int => { // @error pattern will not be matched, unreachable pattern
        }
    }
}

function testSameMatchPatternsNegative2(any v) {
    match v {
        var [a, b] => {} // @error
        var [c, d] => {} // @error unreachable pattern
    }
}

function testSameMatchPatternsNegative3(any v) {
    match v {
        var [a, ...b] => {} // @error
        var [c, ...d] => {} // @error unreachable pattern
    }
}

function testSameMatchPatternsNegative4(any v) {
    match v {
        var [x, ...y] => {} // @error
        var [a, b, ...c] => {} // @error unreachable pattern
    }
}

function testSameMatchPatternsNegative5(any v) {
    match v {
        var [a, b, ...c] => {} // @error
        var [x, y, ...z] => {} // @error unreachable pattern
    }
}

function testUnreachablePattern1() {
    [int, int] v = [1, 3];

    match v {
        var [a, b] => { // @error
        }
        [1, 3] => { // @error unreachable pattern
        }
    }
}

function testUnreachablePattern2() {
    [int, [string]] v = [1, ["3"]];

    match v {
        var [a, [b]] => { // @error
        }
        [1, ["3"]] => { // @error unreachable pattern
        }
    }
}

function testUnreachablePattern3() {
    [int, [any]] v = [1, ["3"]];

    match v {
        var [a, [b]] => { // @error
        }
        [1, ["3"]] => { // @error unreachable pattern
        }
    }
}

function testUnreachablePattern4() {
    [[int, [string]]] v = [[1, ["3"]]];

    match v {
        [[1, var [b]]] => { // @error
        }
        [[1, ["3"]]] => { // not an unreachable pattern
        }
    }
}

function testUnreachablePattern5() {
    [any, any] v = [1, 2];
    match v {
        [_, _] => {}
        [1, 2] => {} // @error unreachable pattern
     }
}

function testUnmatchedPattensForSizeMismatchWithClosedArray(int[3] val) {
    match val {
        var [a, _, c, d] => { // @error
        }
        var [a, b, c, d] => { // @error
        }
        var [a, b] => { // @error
        }
    }
}
