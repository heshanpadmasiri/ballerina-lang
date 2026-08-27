import ballerina/io;

const constLength = 2;

type Rec record {
    int i?;
    int j = 10;
};

class Obj {
    int i;

    function init() {
        self.i = 1;
    }
}

class ObjInitNullable {
    int i;

    function init() returns () {
        self.i = 1;
    }
}

class Student {
    public int id;
    public string name;
    public int age;
    public decimal gpa;
    public float gre_score;
    public string university;
    public string country;

    public function init(int id = 10001, string name = "Alex", int age = 24, decimal gpa = 3.75,
                         float gre_score = 5.0, string university = "UBC", string country = "CA") {
        self.id = id;
        self.name = name;
        self.age = age;
        self.gpa = gpa;
        self.gre_score = gre_score;
        self.university = university;
        self.country = country;
    }
}

class Age {
    public int age;

    public function init(int age = 5) {
        self.age = age;
    }
}

type Person record {|
    string name = "default";
|};

public function main() {
    testObjectDynamicArrayFilling();
    testRecordTypeWithOptionalFieldsArrayFill();
    testRecordTypeWithOptionalFieldsSealedArrayFill();
    testObjectRetNullableDynamicArrayFilling();
    testObjectNoRetDynamicArrayFilling();
    testTwoDimensionalSealedArrayFill();
    createMultipleConstLiteralAutoFilledSealedArray();
    tesOneDimensionalArrayWithConstantSizeReferenceFill();
    tesTwoDimensionalArrayWithConstantSizeReferenceFill();
    testAnonRecordTypeWithDefaultValueFill();
    testServiceClassArrayFilling();
}

function testObjectDynamicArrayFilling() {
    Age[2] y = [];
    y[1] = new(10);
    assertEqualPanic(10, y[1].age);
}

function testObjectArrayFillingWithDefaultValues() {
    Student s = new(10024, "Roy", 26, 3.71, 5.4, "UoM", "SL");
    Student[] arr = [];
    arr[5] = s;

    assertEqualPanic("Alex", arr[0].name);
    assertEqualPanic("Alex", arr[3].name);
    assertEqualPanic("Roy", arr[5].name);
    assertEqualPanic(10001, arr[0].id);
    assertEqualPanic(10024, arr[5].id);
    assertEqualPanic(3.75d, arr[2].gpa);
    assertEqualPanic(3.71d, arr[5].gpa);
    assertEqualPanic(5.0, arr[4].gre_score);
    assertEqualPanic(5.4, arr[5].gre_score);
    assertEqualPanic("CA", arr[0].country);
    assertEqualPanic("SL", arr[5].country);
}

function testObjectRetNullableDynamicArrayFilling() {
    ObjInitNullable[2] y = [];
    y[1] = new();

    assertEqualPanic(1, y[0].i);
    assertEqualPanic(1, y[1].i);
}

function testObjectNoRetDynamicArrayFilling() {
    Obj[2] y = [];
    y[1] = new();

    assertEqualPanic(1, y[0].i);
    assertEqualPanic(1, y[1].i);
}

function testRecordTypeWithOptionalFieldsArrayFill() {
    Rec[] x = [];
    x[1] = {i: 1, j: 2};

    assertEqualPanic(10, x[0].j);
    assertEqualPanic(2, x[1].j);
}

function testRecordTypeWithOptionalFieldsSealedArrayFill() {
    Rec[2] x = [];
    x[1] = {i: 1, j: 2};

    assertEqualPanic(10, x[0].j);
    assertEqualPanic(2, x[1].j);
}

function testTwoDimensionalSealedArrayFill() {
    int[][2] x = [];
    x[1] = [1, 3];
    assertEqualPanic(2, x.length());
    assertEqualPanic([0, 0], x[0]);
    assertEqualPanic([1, 3], x[1]);

    int[2][3] y = [];
    assertEqualPanic(2, y.length());
    foreach var item in y {
        assertEqualPanic([0, 0, 0], item);
    }

    Rec[2][2] z = [];
    assertEqualPanic(z.length(), 2);
    foreach var item in z {
        assertEqualPanic(10, item[0].j);
        assertEqualPanic(10, item[1].j);
    }
}

const FOO_ZERO = 0;
type FOO_FOUR_THREE 4 | 3;
type BarMultiple FOO_ZERO | 1 | FOO_FOUR_THREE;

function createMultipleConstLiteralAutoFilledSealedArray() {
    BarMultiple a = 1;
    BarMultiple[5] sealedArray = [a, a];
    sealedArray[3] = a;
    assertEqualPanic(1, sealedArray[0]);
    assertEqualPanic(1, sealedArray[1]);
    assertEqualPanic(1, sealedArray[3]);
}

function tesOneDimensionalArrayWithConstantSizeReferenceFill() {
    int[constLength] a = [];
    a[1] = 2;
    assertEqualPanic(2, a.length());
    assertEqualPanic(0, a[0]);
    assertEqualPanic(2, a[1]);
}

function tesTwoDimensionalArrayWithConstantSizeReferenceFill() {
    int[2][constLength] a = [];
    a[1][0] = 3;
    assertEqualPanic(2, a.length());
    assertEqualPanic([0, 0], a[0]);
    assertEqualPanic([3, 0], a[1]);

    int[constLength][] b = [];
    b[1] = [1, 2, 3];
    assertEqualPanic(2, b.length());
    assertEqualPanic([], b[0]);
    assertEqualPanic([1, 2, 3], b[1]);
}

function testAnonRecordTypeWithDefaultValueFill() {
    record {| int i = 101; |}[3] testArray = [];
    testArray[1] = {i: 202};
    assertEqualPanic(3, testArray.length());
    assertEqualPanic(101, testArray[0].i);
    assertEqualPanic(202, testArray[1].i);
    assertEqualPanic(101, testArray[2].i);

    testAnonRecordArray(getAnonFromAnon, "Jane");
    testAnonRecordArray(getAnonFromPerson, "default");
    testAnonRecordArray(getPersonFromAnon, "John");
    testAnonRecordArray(getPersonFromPerson, "default");
}

function testAnonRecordArray(function () returns record {|string name;|}[] func, string name) {
    var resultArr = func();
    resultArr[1] = {name: "Jack"};
    assertEqualPanic(2, resultArr.length());
    assertEqualPanic(name, resultArr[0].name);
    assertEqualPanic("Jack", resultArr[1].name);
}

function getAnonFromAnon() returns record {| string name; |}[] {
    record {|
        string name = "Jane";
    |}[] arr = [];
    return arr;
}

function getAnonFromPerson() returns record {| string name; |}[] {
    Person[] arr = [];
    return arr;
}

function getPersonFromAnon() returns Person[] {
    record {|
        string name = "John";
    |}[] arr = [];
    return arr;
}

function getPersonFromPerson() returns Person[] {
    Person[] arr = [];
    return arr;
}

service class Class1 {}

service class Class2 {}

function testServiceClassArrayFilling() {
    [Class1, Class2] interceptors = [];
    assertEqualPanic(2, interceptors.length());
    assertEqualPanic(true, interceptors[0] is Class1);
    assertEqualPanic(true, interceptors[1] is Class2);
}

function assertEqualPanic(anydata expected, anydata actual, string message = "Value mismatch") {
    if (expected != actual) {
        panic error(message + " Expected : " + expected.toString() + " Actual : " + actual.toString());
    }
}

function retainIoImport() {
    _ = io:println;
}
