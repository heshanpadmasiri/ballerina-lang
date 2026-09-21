import ballerina/io;
import ballerina/jballerina.java;

function handleValue(int value) returns handle = @java:Method {
    'class: "java.lang.Long",
    name: "valueOf",
    paramTypes: ["long"]
} external;

function getHandle() returns handle? {
    handle? h = ();
    return h;
}

function getHandleValueAsAParameter(handle h) returns handle {
    return h;
}

function acceptHandleValueWithAny(any a) returns handle {
    handle h = <handle>a;
    return h;
}

function testHandleValueEquality(handle h1, handle h2) returns boolean {
    return h1 === h2;
}

function testHandleValueInequality(handle h1, handle h2) returns boolean {
    return h1 !== h2;
}

handle? modLevelH = ();

function setAndGetModuleLevelHandleValue(handle h) returns handle {
    modLevelH = h;
    return <handle>modLevelH;
}

function testUnionsWithHandleType(handle|string|int h) returns string {
    if h is int {
        return "int";
    } else if h is string {
        return "string";
    }
    return "handle";
}

function testArrayAccessOfHandleValues(handle[] hArray, int index) returns handle {
    return hArray[index];
}

function testArrayStoreOfHandleValues(handle[] hArray, int index, handle h) returns handle[] {
    hArray[index] = h;
    return hArray;
}

function testCreateArrayOfHandleValues(handle h1, handle h2, handle h3, handle h4, int index) returns handle {
    handle[4] hArray = [h1, h2, h3, h4];
    return hArray[index];
}

function testCreateMapOfHandleValues(handle h1, handle h2, handle h3, handle h4) returns handle? {
    map<handle> hMap = {key1: h1, key2: h2, key3: h3, key4: h4};
    return hMap["key2"];
}

type Material record {
    int id;
    string name;
    handle h;
};

function testCreateRecordWithHandleValues(handle h1, handle h2) returns handle {
    Material m = {id: 10, name: "plastic", h: h1};
    m.h = h2;
    return m.h;
}

type MyList [int, handle, handle, string];

function testCreateTuplesWithHandleValues(handle h1, handle h2) returns handle {
    MyList list = [5, h1, h2, "this is a tuple value"];
    int i;
    string s;
    handle h3;
    handle h4;
    [i, h3, h4, s] = list;
    _ = i;
    _ = h4;
    _ = s;
    return h3;
}

class Person {
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    handle data;

    function init(handle data) {
        self.data = data;
    }

    function getData() returns handle {
        return self.data;
    }

    function getName() returns string {
        return self.name;
    }

    function getAge() returns int {
        return self.age;
    }

    function setData(handle h) {
        self.data = h;
    }
}

function testCreateObjectWithHandleValues(handle h1, handle h2) returns handle {
    Person person = new(h1);
    person.setData(h2);
    return person.getData();
}

public function main() {
    io:println(getHandle()); // @output

    handle parameterValue = handleValue(1);
    io:println(getHandleValueAsAParameter(parameterValue)); // @output 1

    handle anyValue = handleValue(2);
    io:println(acceptHandleValueWithAny(anyValue)); // @output 2

    handle equalityOne = handleValue(3);
    handle equalityTwo = handleValue(4);
    io:println(testHandleValueEquality(equalityOne, equalityOne)); // @output true
    io:println(testHandleValueEquality(equalityOne, equalityTwo)); // @output false

    handle inequalityOne = handleValue(5);
    handle inequalityTwo = handleValue(6);
    io:println(testHandleValueInequality(inequalityOne, inequalityOne)); // @output false
    io:println(testHandleValueInequality(inequalityOne, inequalityTwo)); // @output true

    handle moduleValue = handleValue(7);
    io:println(setAndGetModuleLevelHandleValue(moduleValue)); // @output 7

    handle unionHandle = handleValue(8);
    io:println(testUnionsWithHandleType(unionHandle)); // @output handle
    io:println(testUnionsWithHandleType("String handle value")); // @output string
    io:println(testUnionsWithHandleType(10)); // @output int

    handle[] accessValues = [handleValue(9), handleValue(10), handleValue(11), handleValue(12), handleValue(13)];
    io:println(testArrayAccessOfHandleValues(accessValues, 2)); // @output 11

    handle[] storeValues = [handleValue(14), handleValue(15), handleValue(16), handleValue(17), handleValue(18)];
    handle storedValue = handleValue(19);
    io:println(testArrayStoreOfHandleValues(storeValues, 3, storedValue)[3]); // @output 19

    handle arrayOne = handleValue(20);
    handle arrayTwo = handleValue(21);
    handle arrayThree = handleValue(22);
    handle arrayFour = handleValue(23);
    io:println(testCreateArrayOfHandleValues(arrayOne, arrayTwo, arrayThree, arrayFour, 3)); // @output 23

    handle mapOne = handleValue(24);
    handle mapTwo = handleValue(25);
    handle mapThree = handleValue(26);
    handle mapFour = handleValue(27);
    io:println(<handle>testCreateMapOfHandleValues(mapOne, mapTwo, mapThree, mapFour)); // @output 25

    handle recordOne = handleValue(28);
    handle recordTwo = handleValue(29);
    io:println(testCreateRecordWithHandleValues(recordOne, recordTwo)); // @output 29

    handle tupleOne = handleValue(30);
    handle tupleTwo = handleValue(31);
    io:println(testCreateTuplesWithHandleValues(tupleOne, tupleTwo)); // @output 30

    handle objectOne = handleValue(32);
    handle objectTwo = handleValue(33);
    io:println(testCreateObjectWithHandleValues(objectOne, objectTwo)); // @output 33
}
