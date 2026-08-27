import ballerina/io;

const int FIVE = 5;

type OneToFour 1|2|3|4;
type OneToFive 1|2|3|4|FIVE;

function arrayAccessTest(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    return arr[0] + arr[1] + arr[2];
}

function testArrayAccessWithFiniteType() returns boolean {
    int x = 1;
    boolean y = true;
    string s = "hello world";
    int[] arr = [];
    OneToFour a = 1;
    arr[a] = x;
    boolean accessSuccessful = arr[1] == x;
    boolean[*] bArr = [false, true, y];
    a = 2;
    accessSuccessful = accessSuccessful && bArr[a] == y;
    string[5] sArr = ["ballerina", "hi", "this is a string", "test string", s];
    a = 4;
    string s2 = sArr[a];
    return accessSuccessful && sArr[a] == s;
}

function testArrayAccessUsingUnionWithFiniteTypes() returns boolean {
    int x = 1;
    boolean y = true;
    string s = "hello world";
    float f = 102.34;
    int[] arr = [];
    OneToFive a = 1;
    arr[a] = x;
    boolean accessSuccessful = arr[1] == x;
    boolean[*] bArr = [false, true, y];
    a = 2;
    accessSuccessful = accessSuccessful && bArr[a] == y;
    string[5] sArr = ["ballerina", "hi", "this is a string", "test string", s];
    a = 4;
    string s2 = sArr[a];
    accessSuccessful = accessSuccessful && sArr[a] == s;
    (float?)[] fArr = [(), 1.0, 123.2, (), 4.0, f];
    a = FIVE;
    return accessSuccessful && fArr[a] == f;
}

function arrayReturnTest(int x, int y) returns int[] {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[x + y] = x + y;
    return arr;
}

function arrayArgTest(int[] arr) returns int {
    return arr[0] + arr[1];
}

public function main() {
    io:println(arrayAccessTest(100, 5)); // @output 210
    io:println(testArrayAccessWithFiniteType()); // @output true
    io:println(testArrayAccessUsingUnionWithFiniteTypes()); // @output true
    int[] result = arrayReturnTest(100, 5);
    io:println(result.length()); // @output 106
    io:println(result[0]); // @output 100
    io:println(result[1]); // @output 5
    io:println(result[105]); // @output 105
    io:println(arrayArgTest([10, 1])); // @output 11
}
