import ballerina/io;

public function main() {
    string[] names = lazyInitSizeZero();
    io:println(names.length()); // @output 0

    int[] intArray = addValueToIntArray();
    io:println(intArray.length()); // @output 200
    io:println(intArray[0]); // @output -10
    io:println(intArray[15]); // @output 20
    io:println(intArray[99]); // @output 2147483647
    io:println(intArray[100]); // @output -4
    io:println(intArray[115]); // @output -2147483647
    io:println(intArray[199]); // @output 6

    float[] floatArray = addValueToFloatArray();
    io:println(floatArray.length()); // @output 200
    io:println(floatArray[0]); // @output -10.0
    io:println(floatArray[15]); // @output 2.5
    io:println(floatArray[99]); // @output 2.1474836471E9
    io:println(floatArray[100]); // @output 4.3
    io:println(floatArray[115]); // @output -2.1474836477E9
    io:println(floatArray[199]); // @output 6.9

    [int, int, int] intValues = testDefaultValueOfIntArrayElement();
    io:println(intValues[0]); // @output 0
    io:println(intValues[1]); // @output 0
    io:println(intValues[2]); // @output 45

    [json, json, json] jsonValues = testDefaultValueOfJsonArrayElement();
    io:println(jsonValues[0]); // @output
    io:println(jsonValues[1]); // @output
    io:println(jsonValues[2]); // @output {"name":"supun"}

    io:println(testArrayGrowth()); // @output 2390725
}

function lazyInitSizeZero() returns string[] {
    string[] names = [];
    return names;
}

function addValueToIntArray() returns int[] {
    int[] arr = [];
    int x = 4;
    arr[0] = -10;
    arr[15] = 2 + 18;
    arr[99] = 2147483647;
    arr[100] = -x;
    arr[115] = -2147483647;
    arr[199] = 6;
    return arr;
}

function addValueToFloatArray() returns float[] {
    float[] arr = [];
    arr[0] = -10.0;
    arr[15] = 2.5;
    arr[99] = 2147483647.1;
    arr[100] = 4.3;
    arr[115] = -2147483647.7;
    arr[199] = 6.9;
    return arr;
}

function testDefaultValueOfIntArrayElement() returns [int, int, int] {
    int[] a = [];
    a[5] = 45;
    return [a[0], a[1], a[5]];
}

function testDefaultValueOfJsonArrayElement() returns [json, json, json] {
    json[] j = [];
    j[5] = {name: "supun"};
    return [j[0], j[1], j[5]];
}

function testArrayGrowth() returns int {
    float value = 100.0;
    int[] ar = [];
    int count = 0;
    while count < 20 {
        int intValue = <int> value;
        ar[intValue] = 1;
        value *= 1.7;
        count += 1;
    }
    return ar.length();
}
