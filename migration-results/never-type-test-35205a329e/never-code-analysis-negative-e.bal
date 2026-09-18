// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function testFunctionWithNeverReturnTypeReturningNil() returns never { // @error
    string _ = "hello";
}

public function testNeverReturnFuncInvWithPanic() {
    panic unreached(); // @error
}

function unreached() returns never {
    panic error("error!!!");
}

function testCheckWithNeverTypeExpr() returns error? {
    any _ = check unreached(); // @error // @error
    any _ = checkpanic unreached(); // @error // @error
    return;
}

function testNeverTypeRequiredAndDefaultableParamInInv() {
   passIntValue(unreached(), unreached()); // @error // @error
}

function passIntValue(int a, int b = 2) {

}

function num() returns error {
    return unreached(); // @error
}

function testInvalidUsageOfExprOfNeverInGroupedExpr() returns error? {
    error? x = check (unreached()); // @error // @error // @error
    return;
}

public type Foo record {
    never w;
    record {|
        *Foo;
    |} x;
};

public type Bar record {
    record {|
        *Bar;
        never x?;
    |} x;
};

function testCyclicInclusionViaFieldWithNever() {
    Foo _ = {}; // error: expression of type 'never' or equivalent to type 'never' not allowed here // @error
    Bar _ = {x: {}}; // OK
}

function testReturnUnionOfNever1() returns never|never { // @error
} // error
function testReturnUnionOfNever2() returns never|never|never { // @error
} // error

type Never never;

function testReturnUnionOfNever3() returns never|Never { // @error
} // error

function testReturnUnionOfNever4() returns never|Never|Never { // @error
} // error

function testReturnUnionOfNever5() returns never|int {
} // error // @error

function testReturnUnionOfNever6() returns int|Never {
} // error // @error

type NeverNever never|Never;

function testReturnUnionOfNever7() returns NeverNever { // @error
} // error

function testReturnUnionOfNever8() returns NeverNever|never { // @error
} // error

type BazNever Baz|never; // never
type Baz never|never; // never

function testReturnUnionOfNever9() returns BazNever { // @error
} // error

function testReturnUnionOfNever10() returns Baz { // @error
} // error

function testReturnUnionOfNever11() {
    function() returns never _ = function() returns never|never { // @error
    };

    function() returns never _ = function() returns NeverNever|never { // @error
    };
} // error
