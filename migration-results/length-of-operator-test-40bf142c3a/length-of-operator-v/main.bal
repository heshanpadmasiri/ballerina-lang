import ballerina/io;

function arrayLengthAccessTestAssignmentCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    int length;
    length = arr.length();
    return length;
}

function arrayLengthAccessTestFunctionInvocationCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    int length;
    length = arrayLength(arr.length());
    return length;
}

function arrayLength(int x) returns int {
    return x;
}

function arrayLengthAccessTestVariableDefinitionCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    int length = arrayLength(arr.length());
    return length;
}

function arrayLengthAccessTestArrayInitializerCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    int[] tempArr = [arr.length(), x + y];
    return tempArr[0];
}

function arrayLengthAccessTestMapInitializerCase(int x, int y) returns int|error {
    int[] arr = [x, y, x + y];
    map<anydata> tempMap = {"length": arr.length()};
    int length = <int> tempMap["length"];
    return length;
}

function arrayLengthAccessTestReturnStatementCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    return arr.length();
}

function arrayLengthAccessTestMultiReturnStatementCase(int x, int y) returns [int, int, int] {
    int[] arr = [x, y, x + y];
    int[] brr = [1];
    int[] crr = [1, x + y];
    return [arr.length(), brr.length(), crr.length()];
}

function arrayLengthAccessTestTypeCastExpressionCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    int length = <int> arr.length();
    return length;
}

function arrayLengthAccessTestIfConditionCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    if arr.length() == 3 {
        return 3;
    }
    return 0;
}

function arrayLengthAccessTestBinaryExpressionCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    if arr.length() == arr.length() {
        return 3;
    }
    return 0;
}

function arrayLengthAccessTestStructFieldAccessCase(int x, int y) returns int {
    int[] arr = [x, y, x + y];
    Person jack = {name: "Jack", days: arr};
    if jack.days.length() == 3 {
        return 3;
    }
    return 0;
}

type Person record {|
    string name;
    int[] days;
|};

function arrayLengthAccessTestJSONArrayCase(int x, int y) returns int {
    json arr = [x, y, 5, 5, 6, 6];
    int length = 0;
    if arr is json[] {
        length = arr.length();
    }
    return length;
}

function lengthOfMap(int _x, int _y) returns int {
    map<anydata> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    return namesMap.length();
}

function lengthOfMapEmpty(int _x, int _y) returns int {
    map<anydata> namesMap = {};
    return namesMap.length();
}

function lengthOfString() returns [int, int, int] {
    string foo = "hello world";
    int l1 = foo.length();
    string s1 = "John";
    int l2 = s1.length();
    string s2 = string `Hello ${"John"}`;
    int l3 = s2.length();
    return [l1, l2, l3];
}

function lengthOfBlob() returns [int, int] {
    string s1 = "Hello";
    byte[] b1 = s1.toBytes();
    int l1 = b1.length();
    string s2 = "";
    byte[] b2 = s2.toBytes();
    int l2 = b2.length();
    return [l1, l2];
}

function lengthOfNullString() returns int {
    string foo = "";
    return foo.length();
}

function lengthOfJSONObject() returns int {
    map<json> j = {"a": "A", "b": "B"};
    return j.length();
}

public function main() {
    io:println(arrayLengthAccessTestAssignmentCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestFunctionInvocationCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestVariableDefinitionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestArrayInitializerCase(100, 5)); // @output 3
    io:println(checkpanic arrayLengthAccessTestMapInitializerCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestReturnStatementCase(100, 5)); // @output 3
    [int, int, int] multiReturn = arrayLengthAccessTestMultiReturnStatementCase(100, 5);
    io:println(multiReturn.length()); // @output 3
    io:println(multiReturn[0]); // @output 3
    io:println(multiReturn[1]); // @output 1
    io:println(multiReturn[2]); // @output 2
    io:println(arrayLengthAccessTestTypeCastExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestIfConditionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestBinaryExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestStructFieldAccessCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestJSONArrayCase(100, 5)); // @output 6
    io:println(lengthOfMap(100, 5)); // @output 4
    io:println(lengthOfMapEmpty(100, 5)); // @output 0
    [int, int, int] stringLengths = lengthOfString();
    io:println(stringLengths[0]); // @output 11
    io:println(stringLengths[1]); // @output 4
    io:println(stringLengths[2]); // @output 10
    [int, int] blobLengths = lengthOfBlob();
    io:println(blobLengths[0]); // @output 5
    io:println(blobLengths[1]); // @output 0
    io:println(lengthOfNullString()); // @output 0
    io:println(lengthOfJSONObject()); // @output 2
}
