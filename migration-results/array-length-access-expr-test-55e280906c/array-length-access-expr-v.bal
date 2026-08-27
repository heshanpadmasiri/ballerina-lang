import ballerina/io;

public function main() {
    io:println(arrayLengthAccessTestAssignmentCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestFunctionInvocationCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestVariableDefinitionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestArrayInitializerCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestMapInitializerCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestReturnStatementCase(100, 5)); // @output 3

    [int, int, int] multiReturns = arrayLengthAccessTestMultiReturnStatementCase(100, 5);
    io:println(multiReturns[0]); // @output 3
    io:println(multiReturns[1]); // @output 1
    io:println(multiReturns[2]); // @output 2

    io:println(arrayLengthAccessTestTypeCastExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestIfConditionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestBinaryExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestStructFieldAccessCase(100, 5)); // @output 3
}

function arrayLengthAccessTestAssignmentCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int length;
    length = arr.length();
    return length;
}

function arrayLengthAccessTestFunctionInvocationCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int length;
    length = arrayLength(arr.length());
    return length;
}

function arrayLength(int x) returns int {
    return x;
}

function arrayLengthAccessTestVariableDefinitionCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int length = arrayLength(arr.length());
    return length;
}

function arrayLengthAccessTestArrayInitializerCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int[] tempArr = [arr.length(), x + y];
    return tempArr[0];
}

function arrayLengthAccessTestMapInitializerCase(int x, int y) returns int|error {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    map<any> tempMap = {"length": arr.length()};
    int length;
    length = <int> tempMap["length"];
    return length;
}

function arrayLengthAccessTestReturnStatementCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    return arr.length();
}

function arrayLengthAccessTestMultiReturnStatementCase(int x, int y) returns [int, int, int] {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int[] brr = [];
    brr[0] = 1;
    int[] crr = [];
    crr[0] = 1;
    crr[1] = x + y;
    return [arr.length(), brr.length(), crr.length()];
}

function arrayLengthAccessTestTypeCastExpressionCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    int length = arr.length();
    return length;
}

function arrayLengthAccessTestIfConditionCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    if arr.length() == 3 {
        return 3;
    }
    return 0;
}

function arrayLengthAccessTestBinaryExpressionCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    if arr.length() == arr.length() {
        return 3;
    }
    return 0;
}

function arrayLengthAccessTestStructFieldAccessCase(int x, int y) returns int {
    int[] arr = [];
    arr[0] = x;
    arr[1] = y;
    arr[2] = arr[0] + arr[1];
    Person jack = {name: "Jack", days: arr};
    if jack.days.length() == 3 {
        return 3;
    }
    return 0;
}

type Person record {
    string name;
    int[] days;
};
