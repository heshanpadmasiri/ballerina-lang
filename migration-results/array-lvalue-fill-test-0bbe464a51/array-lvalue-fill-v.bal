import ballerina/io;
import ballerina/test;

public function main() {
    PersonObj[] objectArrays = testObjectArrays();
    io:println(objectArrays.length()); // @output 2
    io:println((typeof objectArrays[0]).toString().substring(9)); // @output PersonObj
    io:println(objectArrays[0].name); // @output John Doe
    io:println((typeof objectArrays[1]).toString().substring(9)); // @output PersonObj
    io:println(objectArrays[1].name); // @output Pubudu

    PersonObj[][] twoDObjectArrays = test2DObjectArrays();
    io:println(twoDObjectArrays.length()); // @output 3
    io:println(twoDObjectArrays[0].length()); // @output 0
    io:println(twoDObjectArrays[1].length()); // @output 0
    io:println(twoDObjectArrays[2].length()); // @output 2
    io:println((typeof twoDObjectArrays[2][0]).toString().substring(9)); // @output PersonObj
    io:println(twoDObjectArrays[2][0].name); // @output John Doe
    io:println((typeof twoDObjectArrays[2][1]).toString().substring(9)); // @output PersonObj
    io:println(twoDObjectArrays[2][1].name); // @output John Doe

    testSimpleBasic2DArrays();
    testRecordArrays();
    test2DRecordArrays();
    testArraysInRecordFields();
    testArraysInObjectFields();
    testArraysInUnionTypes();
    testArraysOfTuples();
    test2DArrayInATuple();
    testFiniteTyped2DArrays();
    testMapArrayAsAnLValue();
    testMDArrayFillerValues();
    test2DObjectArrays2();
}

function testSimpleBasic2DArrays() {
    int[][] iarr = [];
    iarr[2][4] = 10;

    float[][] farr = [];
    farr[4][3] = 12.34;
    farr[2][2] = 45.67;
    farr[2][5] = 6.78;

    decimal[][] darr = [];
    darr[1][3] = 12.34;
    darr[2][2] = 45.67;
    darr[2][5] = 6.78;

    boolean[][] barr = [];
    barr[3][3] = true;

    string[][] sarr = [];
    sarr[3][3] = "foo";

    assert(<int[][]>[[], [], [0, 0, 0, 0, 10]], iarr);
    assert(<float[][]>[[], [], [0, 0, 45.67, 0, 0, 6.78], [], [0, 0, 0, 12.34]], farr);
    assert(<decimal[][]>[[], [0, 0, 0, 12.34], [0, 0, 45.67, 0, 0, 6.78]], darr);
    assert(<boolean[][]>[[], [], [], [false, false, false, true]], barr);
    assert(<string[][]>[[], [], [], ["", "", "", "foo"]], sarr);

    assert(3, iarr.length());
    assert(5, farr.length());
    assert(3, darr.length());
    assert(4, barr.length());
    assert(4, sarr.length());
}

type Person record {|
    string name = "Pubudu";
|};

function testRecordArrays() {
    Person[] arr = [];
    arr[1].name = "John Doe";
    assert(<Person[]>[{name: "Pubudu"}, {name: "John Doe"}], arr);
}

function test2DRecordArrays() {
    Person[][] arr = [];
    arr[2][1] = {name: "John Doe"};
    assert(<Person[][]>[[], [], [{name: "Pubudu"}, {name: "John Doe"}]], arr);
    assert(3, arr.length());
    assert(2, arr[2].length());
}

class PersonObj {
    string name = "John Doe";
}

function testObjectArrays() returns PersonObj[] {
    PersonObj[] arr = [];
    arr[1].name = "Pubudu";
    return arr;
}

function test2DObjectArrays() returns PersonObj[][] {
    PersonObj[][] arr = [];
    arr[2][1] = new;
    return arr;
}

class PersonObj2 {
    string name = "John Doe";

    public function init(string name = "Pubudu") {
        self.name = name;
    }
}

function test2DObjectArrays2() {
    PersonObj2[][] arr = [];
    arr[2][1] = new;
    test:assertEquals(arr[0], []);
    test:assertEquals(arr[1], []);
    test:assertEquals(arr[2].length(), 2);
}

type Foo record {
    Person[][][] arr;
};

function testArraysInRecordFields() {
    Foo f = {arr: []};
    f.arr[1][2][3] = {name: "Fernando"};
    assert(<Foo>{arr: [[], [[], [], [{name: "Pubudu"}, {name: "Pubudu"}, {name: "Pubudu"}, {name: "Fernando"}]]]}, f);
}

class FooObj {
    Person[][][] arr = [];
}

function testArraysInObjectFields() {
    FooObj f = new;
    f.arr[1][2][3] = {name: "Fernando"};
    assert(<Person[][][]>[[], [[], [], [{name: "Pubudu"}, {name: "Pubudu"}, {name: "Pubudu"}, {name: "Fernando"}]]], f.arr);
}

function testArraysInUnionTypes() {
    string[][][]|() arr = [];
    if (arr is string[][][]) {
        arr[1][2][1] = "Foo";
    }
    assert(<string[][][]>[[], [[], [], ["", "Foo"]]], arr);
}

function testArraysOfTuples() {
    [string, int][][] arr = [];
    arr[2][2] = ["foo", 10];
    assert(<[string, int][][]>[[], [], [["", 0], ["", 0], ["foo", 10]]], arr);
}

function test2DArrayInATuple() {
    [string, int[][]] tup = ["foo", []];
    tup[1][2][1] = 100;
    assert(<[string, int[][]]>["foo", [[], [], [0, 100]]], tup);
}

type Bar 0|1|2;

function testFiniteTyped2DArrays() {
    Bar[][][] arr = [];
    arr[2][1][1] = 2;
    assert(<Bar[][][]>[[], [], [[], [0, 2]]], arr);
}

function testMapArrayAsAnLValue() {
    map<int>[] arr = [];
    arr[1]["i"] = 1;
    assert(<map<int>[]>[{}, {"i": 1}], arr);
}

type unionTypeWithNil 1|"foo"|();

function testMDArrayFillerValues() {
    int[2][102] arr1 = [[11, 22, 33]];
    int[2][102] expectedArr1 = [[11,22,33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
    assert(expectedArr1, arr1);

    float[2][3][4] arr2 = [[[1,2],[3]]];
    assert(<float[2][3][4]>[[[1.0,2.0,0.0,0.0],[3.0,0.0,0.0,0.0],[0.0,0.0,0.0,0.0]],[[0.0,0.0,0.0,0.0],[0.0,0.0,0.0,0.0],[0.0,0.0,0.0,0.0]]], arr2);

    string[2][3][4] arr3 = [[["a","b"],["c","d","e","f"],["g"]]];
    assert(<string[2][3][4]>[[["a","b","",""],["c","d","e","f"],["g","","",""]],[["","","",""],["","","",""],["","","",""]]], arr3);

    unionTypeWithNil[2][4] arr4 = [[1, 1, "foo"]];
    assert(<unionTypeWithNil[2][4]>[[1,1,"foo",()],[(),(),(),()]], arr4);

    map<int[3]>[] arr5 = [];
    arr5[3]["i"] = [1,2];
    arr5[1]["k"] = [3];
    assert(<map<int[3]>[]>[{},{"k":[3,0,0]},{},{"i":[1,2,0]}], arr5);
}

function assert(anydata expected, anydata actual) {
    if (expected == actual) {
        return;
    }
    typedesc<anydata> expT = typeof expected;
    typedesc<anydata> actT = typeof actual;
    string msg = "expected [" + expected.toString() + "] of type [" + expT.toString()
                        + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
    panic error("{AssertionError}", message = msg);
}
