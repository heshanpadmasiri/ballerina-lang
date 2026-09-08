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

import ballerina/io;
import ballerina/test;

function testNilArrayFill(int index, () value) returns ()[] {
    ()[] ar = [];
    ar[index] = value;
    return ar;
}

function testBooleanArrayFill(int index, boolean value) returns boolean[] {
    boolean[] ar = [];
    ar[index] = value;
    return ar;
}

function testIntArrayFill(int index, int value) returns int[] {
    int[] ar = [];
    ar[index] = value;
    return ar;
}

function testFloatArrayFill(int index, float value) returns float[] {
    float[] ar = [];
    ar[index] = value;
    return ar;
}

function testDecimalArrayFill(int index, decimal value) returns decimal[] {
    decimal[] ar = [];
    ar[index] = value;
    return ar;
}

function testStringArrayFill(int index, string value) returns string[] {
    string[] ar = [];
    ar[index] = value;
    return ar;
}

type Person record {
    string name;
    int age;
};

function testArrayOfArraysFill(int index) returns Person[][] {
    Person p = {name: "John", age: 25};
    Person[] personArr = [p, p];
    Person[][] ar = [];
    ar[index] = personArr;
    return ar;
}

function testTupleArrayFill(int index) returns [string, int][] {
    [string, int] tup = ["Hello World!", 100];
    [string, int][] ar = [];
    ar[index] = tup;
    return ar;
}

function testTupleSealedArrayFill(int index) returns [string, int][] {
    [string, int] tup = ["Hello World!", 100];
    [string, int][251] ar = []; // 251 == index + 1
    ar[index] = tup;
    return ar;
}

function testMapArrayFill(int index, map<any> value) returns map<any>[] {
    map<any>[] ar = [];
    ar[index] = value;
    return ar;
}

type Employee record {
    readonly int id;
    string name;
    float salary;
};

function testTableArrayFill(int index) {
    table<Employee> tbEmployee = table key(id) [
                    {id: 1, name: "John", salary: 50000}
        ];

    table<Employee>[] ar = [];
    ar[index] = tbEmployee;

    string name = "";
    foreach var tab in ar {
        foreach var row in tab {
            name += row.name;
        }
    }

    assertEquality("[{\"id\":1,\"name\":\"John\",\"salary\":50000.0}]", ar[index].toString());
    assertEquality("John", name.trim());
}

function testXMLArrayFill(int index) returns xml[] {
    xml value = xml `<name>Pubudu</name>`;
    xml[] ar = [];
    ar[index] = value;
    return ar;
}

function testUnionArrayFill1(int index) returns (string|int|Person|())[] {
    (string|int|Person|()) value = "Hello World!";
    (string|int|Person|())[] ar = [];
    ar[index] = value;
    return ar;
}

function testUnionArrayFill2(int index) returns (string|string)[] {
    (string|string) value = "Hello World!";
    (string|string)[] ar = [];
    ar[index] = value;
    return ar;
}

function testUnionArrayFill3(int index) returns (Person|Person|())[] {
    (Person|Person) value = {name: "John", age: 25};
    (Person|Person|())[] ar = [];
    ar[index] = value;
    return ar;
}

type LiteralsAndType 1|2|int;

function testUnionArrayFill4(int index) returns LiteralsAndType[] {
    LiteralsAndType value = 1;
    LiteralsAndType[] ar = [];
    ar[index] = value;
    return ar;
}

function testOptionalTypeArrayFill(int index) returns string?[] {
    string? value = "Hello World!";
    string?[] ar = [];
    ar[index] = value;
    return ar;
}

function testAnyArrayFill(int index) returns any[] {
    Person p = {name: "John", age: 25};
    any value = p;
    any[] ar = [];
    ar[index] = value;
    return ar;
}

function testAnySealedArrayFill(int index) returns any[] {
    Person p = {name: "John", age: 25};
    any value = p;
    any[251] ar = []; // 251 == index + 1
    ar[index] = value;
    return ar;
}

function testAnydataArrayFill(int index) returns anydata[] {
    Person p = {name: "John", age: 25};
    anydata value = p;
    anydata[] ar = [];
    ar[index] = value;
    return ar;
}

function testAnydataSealedArrayFill(int index) returns anydata[] {
    Person p = {name: "John", age: 25};
    anydata value = p;
    anydata[251] ar = []; // 251 == index + 1
    ar[index] = value;
    return ar;
}

function testByteArrayFill(int index, byte value) returns byte[] {
    byte[] ar = [];
    ar[index] = value;
    return ar;
}

function testJSONArrayFill(int index) returns json[] {
    json value = {name: "John", age: 25};
    json[] ar = [];
    ar[index] = value;
    return ar;
}

type digit 0|1|2|3|4|5|6|7|8|9;

function testFiniteTypeArrayFill1(int index) returns digit[] {
    digit value = 5;
    digit[] ar = [];
    ar[index] = value;
    return ar;
}

type FP 0.0|1.2|2.3;

function testFiniteTypeArrayFill2(int index) returns FP[] {
    FP value = 1.2;
    FP[] ar = [];
    ar[index] = value;
    return ar;
}

type bool false|true;

function testFiniteTypeArrayFill3(int index) returns bool[] {
    bool[] ar = [];
    ar[index] = true;
    return ar;
}

type state false|true|();

function testFiniteTypeArrayFill4(int index) returns state[] {
    state[] ar = [];
    ar[index] = true;
    return ar;
}

const decimal ZERO = 0;
const decimal ONE_TWO = 1.2;
const decimal TWO_THREE = 2.3;

type DEC ZERO|ONE_TWO|TWO_THREE;

function testFiniteTypeArrayFill5(int index) returns DEC[] {
    DEC value = 1.2;
    DEC[] ar = [];
    ar[index] = value;
    return ar;
}

type One 1;

function testSingletonTypeArrayFill(int index) returns One[] {
    One[] ar = [];
    ar[index] = 1;
    return ar;
}

type bTrue true;

function testSingletonTypeArrayFill1() returns bTrue[] {
    bTrue[] bTrueAr1 = [];
    bTrueAr1[1] = true;
    return bTrueAr1;
}

function testSingletonTypeArrayStaticFill() returns bTrue[] {
    bTrue[2] bTrueAr1 = [];
    bTrueAr1[1] = true;
    return bTrueAr1;
}

class Student {
    public string name;
    public int age;

    public function init(string name, int age) {
        self.name = name;
        self.age = age;
    }
}

function testSequentialArrayInsertion() returns Student[] {
    Student s = new("Grainier", 28);
    Student[] arr = [];
    int i = 0;
    while (i < 5) {
        arr[i] = s;
        i += 1;
    }
    return arr;
}

function testTwoDimensionalArrayFill() returns int[][] {
    int[][] x = [];
    x[1] = [1, 3];
    return x;
}

class Obj {
    int i;

    function init() {
        self.i = 1;
    }
}

function testArrayFillWithObjs() returns Obj[][] {
    Obj o = new;
    Obj[] objArray = [];
    objArray[0] = o;
    Obj[][] multiDimObjArray = [];
    multiDimObjArray[0] = objArray;
    multiDimObjArray[2] = objArray;
    return multiDimObjArray;
}

function testFiniteTypeArrayFill() returns DEC[] {
    DEC value = 1.2;
    DEC[] ar = [];
    ar[5] = value;

    LiteralsAndType value2 = 1;
    LiteralsAndType[] ar2 = [];
    ar2[5] = value2;
    return ar;
}

const CONST_TWO = 2;

type Foo1 1|2;
type Bar1 0|4;
type Foo2 "1"|"2";
type Bar2 "0"|"";
type nil ();
type integer int;
type sym1 112|string|int[3];
type Foo 1|2|sym1|3|[Bar,sym1];
type Bar 7|int|integer;
type sym2 Foo|Bar|boolean[];
type sym3 7|Bar|byte;
type sym4 11|0;
type sym5 11|sym4|12;
type WithFillerValSym Bar|20|sym3;
type NoFillerValSym sym2|20|sym3;
type finiteUnionType false|byte|0|0.0f|0d|""|["a"]|string:Char|int:Unsigned16;
type LiteralConstAndIntType int|CONST_TWO;
type emptyString "";

function testFiniteTypeUnionArrayFill() {
    LiteralConstAndIntType[2] arr0 = [];
    test:assertEquals(arr0, [0,0]);

    (Foo1|Bar1)[] arr1 = [];
    arr1[1] = 1;
    test:assertEquals(arr1, [0,1]);

    (Foo2|Bar2)[] arr2 = [];
    arr2[1] = "1";
    test:assertEquals(arr2, ["","1"]);

    (nil|int)[] arr3 = [];
    arr3[1] = 10;
    test:assertEquals(arr3, [(),10]);

    (Foo1|integer)[] arr4 = [];
    arr4[1] = 100;
    test:assertEquals(arr4, [0,100]);

    WithFillerValSym[] arr5 = [];
    arr5[1] = 100;
    test:assertEquals(arr5, [0,100]);

    (Bar|20|sym5)[] arr6 = [];
    arr6[1] = 100;
    test:assertEquals(arr6, [0,100]);

    (string:Char|emptyString)[] arr13 = [];
    arr13[1] = "j";
    test:assertEquals(arr13, ["","j"]);

    (string:Char|Bar2)[] arr14 = [];
    arr14[1] = "l";
    test:assertEquals(arr14, ["","l"]);

    (function () returns ())[] negativeTestFunctions = [noFillerValueCase1, noFillerValueCase2, noFillerValueCase3,
                                                        noFillerValueCase4, noFillerValueCase5, noFillerValueCase6];
    foreach var func in negativeTestFunctions {
        error? funcResult = trap func();
        test:assertTrue(funcResult is error);
        if (funcResult is error) {
            test:assertEquals("{ballerina/lang.array}IllegalListInsertion", funcResult.message());
            test:assertEquals("array of length 0 cannot be expanded into array of length 2 without filler values",
            <string>checkpanic funcResult.detail()["message"]);
        }
    }
}

function noFillerValueCase1() {
    NoFillerValSym[] arr7 = [];
    arr7[1] = 100;
}

function noFillerValueCase2() {
    finiteUnionType[] arr8 = [];
    arr8[1] = 100;
}

function noFillerValueCase3() {
    (false|0|0.0f|0d|"")[] arr9 = [];
    arr9[1] = 0;
}

function noFillerValueCase4() {
    (string|string:Char|Foo1)[] arr10 = [];
    arr10[1] = "k";
}

function noFillerValueCase5() {
    (xml:Text|xml:Comment|Foo1)[] arr11 = [];
    arr11[1] = 1;
}

function noFillerValueCase6() {
    (string:Char|"k")[] arr12 = [];
    arr12[1] = "k";
}

type Default record {|
    int id = 0;
    string name = "Tom";
|};

function testReadOnlyArrayFill() {
    int[2] & readonly arr1 = [];
    int[4][2] & readonly arr2 = [];
    [int, string][4] & readonly arr3 = [];
    map<int>[2] & readonly arr4 = [];
    Default[4] & readonly arr5 = [];
    table<Default>[2] & readonly arr6 = [];
    xml[2] & readonly arr7 = [];
    any[4] & readonly arr8 = [];

    assertEquality("[0,0]", arr1.toString());
    assertEquality("[[0,0],[0,0],[0,0],[0,0]]", arr2.toString());
    assertEquality("[[0,\"\"],[0,\"\"],[0,\"\"],[0,\"\"]]", arr3.toString());
    assertEquality("[{},{}]", arr4.toString());
    assertEquality("[{\"id\":0,\"name\":\"Tom\"},{\"id\":0,\"name\":\"Tom\"},{\"id\":0,\"name\":\"Tom\"},"+
    "{\"id\":0,\"name\":\"Tom\"}]", arr5.toString());
    assertEquality("[[],[]]", arr6.toString());
    assertEquality("[``,``]", arr7.toString());
    assertEquality("[null,null,null,null]", arr8.toString());
}

function testXMLSubtypesArrayFill() {
    string errorMsg = "{ballerina/lang.array}IllegalListInsertion";
    string errorDetails = "{\"message\":\"array of length 0 cannot be expanded into array of length 2 without" +
    " filler values\"}";

    xml:Element[] a = [];
    error? result = trap setXmlArraySecondElement(a, xml `<foo/>`);
    assertEquality(result is error, true);
    error err = <error>result;
    assertEquality(errorMsg, err.message());
    assertEquality(errorDetails, err.detail().toString());

    xml:Comment[] b = [];
    result = trap setXmlArraySecondElement(b, xml `<!-- this is a comment text -->`);
    assertEquality(result is error, true);
    err = <error>result;
    assertEquality(errorMsg, err.message());
    assertEquality(errorDetails, err.detail().toString());

    xml:ProcessingInstruction[] c = [];
    result = trap setXmlArraySecondElement(c, xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`);
    assertEquality(result is error, true);
    err = <error>result;
    assertEquality(errorMsg, err.message());
    assertEquality(errorDetails, err.detail().toString());

    xml:Text[] d = [];
    result = trap setXmlArraySecondElement(d, xml `Hello World`);
    assertEquality(result is (), true);
    assertEquality("[``,`Hello World`]", d.toString());

    xml[] e = [];
    result = trap setXmlArraySecondElement(e, xml `Hello World`);
    assertEquality(result is (), true);
    assertEquality("[``,`Hello World`]", e.toString());

    (xml|xml:Text)[] f = [];
    result = trap setXmlArraySecondElement(e, xml `Hello World`);
    assertEquality(result is (), true);
    assertEquality("[``,`Hello World`]", e.toString());
    _ = f;
}

function setXmlArraySecondElement(xml[] arr, xml element) {
    arr[1] = element;
}

type AssertionError distinct error;

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
                    message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    int index = 250;

    ()[] nilArr = testNilArrayFill(index, ());
    io:println(nilArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(nilArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(nilArr[index]); // @output

    boolean[] booleanArr = testBooleanArrayFill(index, true);
    io:println(booleanArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(booleanArr[i]); // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
    }
    io:println(booleanArr[index]); // @output true

    int[] intArr = testIntArrayFill(index, 100);
    io:println(intArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(intArr[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(intArr[index]); // @output 100

    float[] floatArr = testFloatArrayFill(index, 23.45);
    io:println(floatArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(floatArr[i]); // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
    }
    io:println(floatArr[index]); // @output 23.45

    decimal[] decimalArr = testDecimalArrayFill(index, 23.45);
    io:println(decimalArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(decimalArr[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(decimalArr[index]); // @output 23.45

    string[] stringArr = testStringArrayFill(index, "Hello World!");
    io:println(stringArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(stringArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(stringArr[index]); // @output Hello World!

    Person[][] arraysArr = testArrayOfArraysFill(index);
    io:println(arraysArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(arraysArr[i]); // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
        // @output []
    }
    io:println(arraysArr[index]); // @output [{"name":"John","age":25},{"name":"John","age":25}]

    [string, int][] tupleArr = testTupleArrayFill(index);
    io:println(tupleArr.length()); // @output 251
    foreach int i in 0 ..< index {
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        io:println(tupleArr[i][0]);
        io:println(tupleArr[i][1]);
    }
    io:println(tupleArr[index][0]); // @output Hello World!
    io:println(tupleArr[index][1]); // @output 100

    [string, int][] sealedTupleArr = testTupleSealedArrayFill(index);
    io:println(sealedTupleArr.length()); // @output 251
    foreach int i in 0 ..< index {
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        // @output
        // @output 0
        io:println(sealedTupleArr[i][0]);
        io:println(sealedTupleArr[i][1]);
    }
    io:println(sealedTupleArr[index][0]); // @output Hello World!
    io:println(sealedTupleArr[index][1]); // @output 100

    map<any> valueMap = {"1": 1};
    map<any>[] mapArr = testMapArrayFill(index, valueMap);
    io:println(mapArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(mapArr[i].length()); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(mapArr[index].length()); // @output 1
    io:println(mapArr[index]["1"]); // @output 1

    testTableArrayFill(index);

    xml[] xmlArr = testXMLArrayFill(index);
    io:println(xmlArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(xmlArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(xmlArr[index]); // @output <name>Pubudu</name>

    (string|int|Person|())[] unionArr1 = testUnionArrayFill1(index);
    io:println(unionArr1.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(unionArr1[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(unionArr1[index]); // @output Hello World!

    string[] unionArr2 = testUnionArrayFill2(index);
    io:println(unionArr2.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(unionArr2[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(unionArr2[index]); // @output Hello World!

    (Person|())[] unionArr3 = testUnionArrayFill3(index);
    io:println(unionArr3.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(unionArr3[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(unionArr3[index]); // @output {"name":"John","age":25}

    LiteralsAndType[] unionArr4 = testUnionArrayFill4(index);
    io:println(unionArr4.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(unionArr4[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(unionArr4[index]); // @output 1

    digit[] finiteArr1 = testFiniteTypeArrayFill1(index);
    io:println(finiteArr1.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(finiteArr1[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(finiteArr1[index]); // @output 5

    FP[] finiteArr2 = testFiniteTypeArrayFill2(index);
    io:println(finiteArr2.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(finiteArr2[i]); // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
        // @output 0.0
    }
    io:println(finiteArr2[index]); // @output 1.2

    bool[] finiteArr3 = testFiniteTypeArrayFill3(index);
    io:println(finiteArr3.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(finiteArr3[i]); // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
        // @output false
    }
    io:println(finiteArr3[index]); // @output true

    state[] finiteArr4 = testFiniteTypeArrayFill4(index);
    io:println(finiteArr4.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(finiteArr4[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(finiteArr4[index]); // @output true

    DEC[] finiteArr5 = testFiniteTypeArrayFill5(index);
    io:println(finiteArr5.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(finiteArr5[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(finiteArr5[index]); // @output 1.2

    string?[] optionalArr = testOptionalTypeArrayFill(index);
    io:println(optionalArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(optionalArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(optionalArr[index]); // @output Hello World!

    any[] anyArr = testAnyArrayFill(index);
    io:println(anyArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(anyArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(anyArr[index]); // @output {"name":"John","age":25}

    any[] sealedAnyArr = testAnySealedArrayFill(index);
    io:println(sealedAnyArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(sealedAnyArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(sealedAnyArr[index]); // @output {"name":"John","age":25}

    anydata[] anydataArr = testAnydataArrayFill(index);
    io:println(anydataArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(anydataArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(anydataArr[index]); // @output {"name":"John","age":25}

    anydata[] sealedAnydataArr = testAnydataSealedArrayFill(index);
    io:println(sealedAnydataArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(sealedAnydataArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(sealedAnydataArr[index]); // @output {"name":"John","age":25}

    byte[] byteArr = testByteArrayFill(index, 100);
    io:println(byteArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(byteArr[i]); // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
        // @output 0
    }
    io:println(byteArr[index]); // @output 100

    json[] jsonArr = testJSONArrayFill(index);
    io:println(jsonArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(jsonArr[i]); // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
        // @output
    }
    io:println(jsonArr[index]); // @output {"name":"John","age":25}

    One[] singletonArr = testSingletonTypeArrayFill(index);
    io:println(singletonArr.length()); // @output 251
    foreach int i in 0 ..< index {
        io:println(singletonArr[i]); // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
        // @output 1
    }
    io:println(singletonArr[index]); // @output 1

    bTrue[] singletonArr1 = testSingletonTypeArrayFill1();
    io:println(singletonArr1.length()); // @output 2
    io:println(singletonArr1[0]); // @output true
    io:println(singletonArr1[1]); // @output true

    bTrue[] staticSingletonArr = testSingletonTypeArrayStaticFill();
    io:println(staticSingletonArr.length()); // @output 2
    io:println(staticSingletonArr[0]); // @output true
    io:println(staticSingletonArr[1]); // @output true

    Student[] studentArr = testSequentialArrayInsertion();
    io:println(studentArr.length()); // @output 5

    int[][] twoDimArr = testTwoDimensionalArrayFill();
    io:println(twoDimArr.length()); // @output 2
    io:println(twoDimArr[0]); // @output []
    io:println(twoDimArr[1]); // @output [1,3]

    Obj[][] objectArr = testArrayFillWithObjs();
    io:println(objectArr.length()); // @output 3

    DEC[] finiteTypeArr = testFiniteTypeArrayFill();
    any finiteTypeArrValue = finiteTypeArr;
    io:println(finiteTypeArrValue is any[]); // @output true
    io:println(finiteTypeArr[5]); // @output 1.2

    testReadOnlyArrayFill();
    testFiniteTypeUnionArrayFill();
    testXMLSubtypesArrayFill();
}
