// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

const byte BCONST = 5;
const int ICONST = 5;
const float FCONST = 5;
const decimal DCONST = 5;
const int ICONST2 = 100;
const float FCONST2 = 100.5;
const string SCONST = "S";

type Number ICONST|DCONST|FCONST;

type Finite ICONST|ICONST2;

type FloatingPoint FCONST2|SCONST;

// Test invalid string assignment
function testDifferentLiteralKindsWithSameValue() {
    Finite f = "5"; // @error
}

type ByteType BCONST;

// Test assigning int constant to byte finite type
function testAssigningIntConstantToByteFiniteType() {
    ByteType b = ICONST;
}

type IntType ICONST;

// Test assigning byte constant to int finite type
function testAssigningByteConstantToIntFiniteType() {
    IntType i = BCONST;
}

// Test assigning float literal to int finite type
function testAssigningFloatLiteralToIntFiniteType() {
    IntType i = 23.00; // @error
}

type FloatType FCONST;

// Test assigning int constant to float finite type
function testAssigningIntConstantToFloatFiniteType() {
    FloatType f = ICONST; // @error
}

// Test assigning decimal constant to float finite type
function testAssigningDecimalConstantToFloatFiniteType() {
    FloatType f = DCONST; // @error
}

type DecimalType DCONST;

// Test assigning int constant to decimal finite type
function testAssigningIntConstantToDecimalFiniteType() {
    DecimalType d = ICONST; // @error
}

// Test assigning float constant to decimal finite type
function testAssigningFloatConstantToDecimalFiniteType() {
    DecimalType d = FCONST; // @error
}

// Test assigning an expression to a finite type
function testAssigningExpressionToFiniteType() {
    IntType i = 2 + 3; // @error
}

type StringOrIntVal "foo"|1;
type StringOrInt string|int;

function testInvalidAssignmentToDifferentType() {
    StringOrIntVal s1 = "foo";
    string s2 = s1; // @error

    StringOrInt s3 = 5;
    int s4 = s3; // @error
}

type t 1.0f|1.0d;
type t2 2.22f|3.33d;
type t3 1.0d|2.0f;
function testFiniteTypesWithDiscriminatedMembers() returns [any, any, any, any, any] {
    t a = 1.0f;
    t b = 1.0d;
    t3 ta = 2.0;
    t3 tb = 1.0f; // @error
    t3 tc = 1.0; // @error
    t|t2 c = 2.22;
    t|t2 d = 2.22f;
    t|t2 e = 3.33; // @error
    t|t2 f = 3.334d; // @error
    return [a, b, c, d, e];
}

type Foo 1f|1d|2d;
type Foo2 1|1d|2d;
type Foo4 1|decimal|2f;

function testFiniteTypeWithNumericValues() {
    Foo f2 = 2; // @error
    Foo2 f3 = 2; // @error
    Foo4 f5 = 3; // @error
    "chiran" x = 5; // @error
}

function testFiniteTypeOfNumericValues() {
    1f _ = 2; // @error
    1.0 _ = 3; // @error
    1.121 _ = 5; // @error
    1.2e12 _ = 2.1; // @error
    0x1p-1 _ = 1.2f; // @error
    0x.12p12 _ = 1.2d; // @error
    1.2e12 _ = 2.1d; // @error

    2d _ = 4; // @error
    1.2d _ = 2.1; // @error
    1.21d _ = 1.2f; // @error
    0.1219e-1 _ = 1.21d; // @error
    12.1d _ = 0x.21; // @error

    boolean b = true;
    if b {
        0x.12p12 _ = 1.2d; // @error
        1.2e12 _ = 2.1d; // @error

        2d _ = 4; // @error
        1.2d _ = 2.1; // @error
    }
}

type Float1 1f;
Float1 _ = 2; // @error

1f _ = 2; // @error
1.0 _ = 3; // @error
1.121 _ = 5; // @error
1.2e12 _ = 2.1; // @error
0x1p-1 _ = 1.2f; // @error
0x.12p12 _ = 1.2d; // @error
1.2e12 _ = 2.1d; // @error

2d _ = 4; // @error
1.2d _ = 2.1; // @error
1.21d _ = 1.2f; // @error
0.1219e-1 _ = 1.21d; // @error
12.1d _ = 0x.21; // @error

function finiteTypeFunctionParameterTest() {
    fn1(1, 2); // @error
    fn2(1, 2); // @error
}

function fn1(2d x, 1f y) {

}

function fn2(0.1219e-1 x, 0x.12p12 y) {

}

function finiteTypeFunctionReturnTypeTest() {
    2d _ = fn3(); // @error
    3f _ = fn4(); // @error
}

function fn3() returns 1f {
    return 2; // @error
}

function fn4() returns 2d {
    return "s"; // @error
}

function finiteTypeTypeCastExpr() {
    2d _ = <2f> 1; // @error
    3d _ = <4f> 4; // @error
    2f _ = <2d> 2; // @error
    3f _ = <4d> 4; // @error
    3f _ = <4f> 4; // @error
    3d _ = <4d> 4; // @error
}

type IntOrNull int|null;
type IntOrNullStr int|"null";

function testNullFiniteType() {
    IntOrNull a = 1; // OK
    IntOrNullStr b = 1; // OK

    int|null c = 1;
    int|"null" d = 1;
    null e = null;
    "null" f = "null";

    IntOrNull _ = null; // OK
    IntOrNull _ = (); // OK
    IntOrNull _ = "null"; // error // @error
    IntOrNull _ = a; // OK
    IntOrNull _ = b; // error // @error
    IntOrNull _ = c; // OK
    IntOrNull _ = d; // error // @error
    IntOrNull _ = e; // OK
    IntOrNull _ = f; // error // @error

    IntOrNullStr _ = null; // error // @error
    IntOrNullStr _ = (); // error // @error
    IntOrNullStr _ = "null"; // OK
    IntOrNullStr _ = a; // error // @error
    IntOrNullStr _ = b; // OK
    IntOrNullStr _ = c; // error // @error
    IntOrNullStr _ = d; // OK
    IntOrNullStr _ = e; // error // @error
    IntOrNullStr _ = f; // OK

    null _ = "null"; // error // @error
    "null" _ = null; // error // @error
}

type UnaryType1 -2;
type UnaryType2 string|-3;
type UnaryType3 UnaryType1|-3;

function testFiniteTypeWithUnaryMinus() {
    UnaryType2 x1 = -2; // @error
    UnaryType3 x2 = -5; // @error
}

function testFiniteTypeWithOutOfRangeValues() {
    1|5.4 _ = 92233720368547758078; // @error
    1 _ = 92233720368547758078; // @error
}

type IntOne 1;
type FloatOne 1.0;
type DecimalOne 1.0d;
type StringA "A";

function testFiniteTypeAssignableNegative() {
    IntOne intOne = 1;
    FloatOne _ = intOne; // @error
    1.0 _ = intOne; // @error
    float _ = intOne; // @error
    DecimalOne _ = intOne; // @error

    FloatOne floatOne = 1.0;
    IntOne _ = floatOne; // @error
    1 _ = floatOne; // @error
    DecimalOne _ = floatOne; // @error
    DecimalOne _ = 1.0f; // @error
    FloatOne|StringA _ = intOne; // @error
    FloatOne|StringA _ = floatOne;

    DecimalOne decimalOne = 1.0d;
    IntOne _ = decimalOne; // @error
    FloatOne _ = decimalOne; // @error
    FloatOne|IntOne _ = decimalOne; // @error
}

function testOutOfRangeWithDecimal() {
    1.7976931348623157E+309d a = 9223372036854775808; // @error
    1.7976931348623157E+309d _ = 17976931348623157000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000; // @error
}

type testType 3|-4|-9223372036854775808; // @error
function testFiniteTypeOutOfRangeWithFunction() {
    testType val = foo(); // @error
}

function foo() returns 3|-4|-9223372036854775808 { // @error
    testType val = 3; // @error
    return val;
}

type InvalidTest1 -9223372036854775808|-1|-1d|"string"; // @error
function testInvalidLiteralInFiniteType() {
    InvalidTest1 x = -1; // @error
}

function testFiniteTypeFloatWithIntegers() {
    1f a = 9223372036854775808; // @error
    1f b = 340; // @error
}
