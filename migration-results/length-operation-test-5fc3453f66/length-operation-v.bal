import ballerina/io;

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
    return <int> tempMap["length"];
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
    int length = <int>arr.length();
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

type Person record {
    string name;
    int[] days;
};

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

function arrayLengthAccessTestJSONArrayCase(int x, int y) returns int {
    json[] arr = [x, y, 5, 5, 6, 6];
    return arr.length();
}

function lengthOfMap() returns int {
    map<any> namesMap = {fname: "foo", lname: "bar", sname: "abc", tname: "pqr"};
    return namesMap.length();
}

function lengthOfEmptyMap() returns int {
    map<any> namesMap = {};
    return namesMap.length();
}

function lengthOfSingleXmlElement() returns int {
    xml x1 = xml `<book>The Lost World</book>`;
    return x1.length();
}

function lengthOfMultipleXmlElements() returns int {
    xml x1 = xml `<book>The Lost World</book>`;
    xml x2 = xml `Hello, world!`;
    xml x3 = xml `-Other txt-`;
    xml x4 = xml `<!--I am a comment-->`;
    xml x5 = xml `<?target data?>`;
    xml x6 = x1 + x2 + x3 + x4 + x5;
    return x6.length();
}

function lengthOfTuple() returns int {
    [int, string] a = [10, "John"];
    return a.length();
}

type Employee record {
    int id;
    string name;
    float salary;
};

type Empty record {};

function lengthOfRecord() returns int {
    Employee emp = {id: 1, name: "John", salary: 300};
    return emp.length();
}

function lengthOfEmptyRecord() returns int {
    Empty emp = {};
    return emp.length();
}

function accessLengthOfNullArray() returns int {
    int[] arr = [];
    return arr.length();
}

function accessLengthOfNullMap() returns int {
    map<any> m = {};
    return m.length();
}

function accessLengthOfNullTuple() returns int {
    [int, int] a = [0, 0];
    return a.length();
}

function accessLengthOfNullXML() returns int {
    xml t = xml `a`;
    xml x = t/*;
    return x.length();
}

function stringLengthAccessTestCase() returns int {
    string name = "Waruna";
    return name.length();
}

public function main() {
    io:println(arrayLengthAccessTestAssignmentCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestFunctionInvocationCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestVariableDefinitionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestArrayInitializerCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestMapInitializerCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestReturnStatementCase(100, 5)); // @output 3
    [int, int, int] lengths = arrayLengthAccessTestMultiReturnStatementCase(100, 5);
    io:println(lengths[0]); // @output 3
    io:println(lengths[1]); // @output 1
    io:println(lengths[2]); // @output 2
    io:println(arrayLengthAccessTestTypeCastExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestIfConditionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestBinaryExpressionCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestStructFieldAccessCase(100, 5)); // @output 3
    io:println(arrayLengthAccessTestJSONArrayCase(100, 5)); // @output 6
    io:println(lengthOfMap()); // @output 4
    io:println(lengthOfEmptyMap()); // @output 0
    io:println(lengthOfSingleXmlElement()); // @output 1
    io:println(lengthOfMultipleXmlElements()); // @output 4
    io:println(lengthOfTuple()); // @output 2
    io:println(lengthOfRecord()); // @output 3
    io:println(lengthOfEmptyRecord()); // @output 0
    _ = accessLengthOfNullArray();
    _ = accessLengthOfNullMap();
    _ = accessLengthOfNullTuple();
    _ = accessLengthOfNullXML();
    io:println(stringLengthAccessTestCase()); // @output 6
}
