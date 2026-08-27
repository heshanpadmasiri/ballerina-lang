import ballerina/io;
import ballerina/test;

int num = 0;
string str = "a";

class ArrayTest {
    int num = 0;

    function getNum() returns int {
        self.num += 1;
        return 2;
    }

    function testArrayInitWithSelfVars() {
        int[] arr = [0, 1, self.num, self.getNum(), self.num, num, getNum(), num];
        test:assertEquals(arr, [0, 1, 0, 2, 1, 1, 2, 2], "Array values are not equal");
    }
}

function testArrayInitWithGlobalVars() {
    int[] arr = [1, num, 3, getNum(), num];
    test:assertEquals(arr, [1, 0, 3, 1, 1], "Array values are not equal");

    string[] arr2 = ["q", str, "w", getStr(), "e", str];
    test:assertEquals(arr2, ["q", "ab", "w", "ab", "e", "ab"], "Array values are not equal");

    ArrayTest arrayTest = new ArrayTest();
    arrayTest.testArrayInitWithSelfVars();
}

function getNum() returns int {
    num = num + 1;
    return num;
}

function getStr() returns string {
    str = str + "b";
    return str;
}

function arrayInitTest() returns int {
    int[] arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    int size = 11;
    int index = 0;
    int sum = 0;

    arr[5] = 50;
    while index < size {
        sum += arr[index];
        index += 1;
    }
    return sum;
}

function arrayReturnTest() returns string[] {
    string[] animals;
    animals = ["Lion", "Cat", "Leopard", "Dog", "Tiger", "Croc"];
    return animals;
}

function testNestedArrayInit() returns int[][] {
    int[][] array = [[1, 2, 3], [6, 7, 8, 9]];
    return array;
}

function testArrayOfMapsInit() returns map<any>[] {
    map<any> addressOne = {city: "Colombo", "country": "SriLanka"};
    map<any> addressTwo = {city: "Kandy", "country": "SriLanka"};
    map<any> addressThree = {city: "Galle", "country": "SriLanka"};
    map<any>[] array = [{address: addressOne}, {address: addressTwo}, {address: addressThree}];
    return array;
}

function floatArrayInitWithInt() returns float[] {
    float[] abc = [2, 4, 5];
    return abc;
}

public type FiniteType "Terminating"|"NotTerminating"|"BestEffort"|"NotBestEffort";

function finiteTypeArray() returns FiniteType {
    FiniteType?[]? var1 = ["Terminating"];
    if var1 is FiniteType?[] {
        var temp = var1[0];
        if temp is FiniteType {
            return temp;
        }
    }
    panic error("FAILED TEST");
}

function testInferredArrayInitWithInGrpExpr() {
    anydata[*] arr = (([1, 2, "a"]));
    assertEquality(arr.length(), 3);
    assertEquality(arr[0], 1);
    assertEquality(arr[1], 2);
    assertEquality(arr[2], "a");
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("AssertionError", message = "expected '" + expected.toString() +
        "', found '" + actual.toString() + "'");
}

public function main() {
    io:println(arrayInitTest()); // @output 110

    string[] animals = arrayReturnTest();
    io:println(animals.length()); // @output 6
    io:println(animals[0]); // @output Lion
    io:println(animals[1]); // @output Cat
    io:println(animals[5]); // @output Croc

    io:println(finiteTypeArray()); // @output Terminating

    int[][] nested = testNestedArrayInit();
    io:println(nested.length()); // @output 2
    io:println(nested[0].length()); // @output 3
    io:println(nested[0][0]); // @output 1
    io:println(nested[0][1]); // @output 2
    io:println(nested[0][2]); // @output 3
    io:println(nested[1].length()); // @output 4
    io:println(nested[1][0]); // @output 6
    io:println(nested[1][1]); // @output 7
    io:println(nested[1][2]); // @output 8
    io:println(nested[1][3]); // @output 9

    map<any>[] addresses = testArrayOfMapsInit();
    io:println(addresses.length()); // @output 3
    map<any> addressOne = <map<any>> addresses[0]["address"];
    map<any> addressTwo = <map<any>> addresses[1]["address"];
    map<any> addressThree = <map<any>> addresses[2]["address"];
    io:println(addressOne["city"]); // @output Colombo
    io:println(addressTwo["city"]); // @output Kandy
    io:println(addressThree["city"]); // @output Galle

    float[] floats = floatArrayInitWithInt();
    io:println(floats.length()); // @output 3
    io:println(floats[0]); // @output 2.0
    io:println(floats[1]); // @output 4.0
    io:println(floats[2]); // @output 5.0

    testInferredArrayInitWithInGrpExpr();
    testArrayInitWithGlobalVars();
}
