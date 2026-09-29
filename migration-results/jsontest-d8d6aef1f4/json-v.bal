import ballerina/io;

function remove() returns json {
    json j = {"name": {"fname": "Jack", "lname": "Taylor"}, "state": "CA", "age": 20};
    map<json> jm = <map<json>>j;
    _ = jm.remove("name");
    return j;
}

function toString(json msg) returns string? {
    return msg.toJsonString();
}

function testParse(string jsonStr) returns json|error {
    return jsonStr.fromJsonString();
}

function testGetKeys() returns string[] {
    json j = {fname: "Jhon", lname: "Doe", age: 40};
    map<json> jm = <map<json>>j;
    return jm.keys();
}

function testStringToJSONConversion() returns json|error {
    string s = "{\"foo\": \"bar\"}";
    return s.fromJsonString();
}

function testJSONArrayToJsonAssignment() returns json {
    json[] j1 = [{"a": "b"}, {"c": "d"}];
    json j2 = j1;
    return j2;
}

public function testCloseRecordToMapJsonAssigment() returns [map<json>, map<json>] {
    AnotherPerson ap = {};
    Person p = {};
    map<json> pm = p;
    map<json> m = ap;
    return [pm, m];
}

type MyJson ()|boolean|int|float|decimal|string|json[]|map<json>;

public function testAssignabilityToUnion() returns MyJson|xml {
    MyJson|xml a = 1;
    json|xml b = a;
    MyJson|xml c = b;
    return c;
}

type Person record {|
    string name = "";
    int age = 10;
    string...;
|};

type AnotherPerson record {|
    string name = "";
    int age = 10 + 20;
|};

public function main() returns error? {
    io:println(remove()); // @output {"state":"CA","age":20}

    json named = {"name": {"fname": "Jack", "lname": "Taylor"}, "state": "CA", "age": 20};
    io:println(toString(named)); // @output {"name":{"fname":"Jack", "lname":"Taylor"}, "state":"CA", "age":20}

    json parsedStringJson = check testParse("\"hello\"");
    string parsedString = <string>parsedStringJson;
    io:println(parsedString); // @output hello

    int assignedInt = <int>testAssignabilityToUnion();
    io:println(assignedInt); // @output 1

    json parsedBooleanJson = check testParse("true");
    boolean parsedBoolean = <boolean>parsedBooleanJson;
    io:println(parsedBoolean); // @output true

    json parsedNumberJson = check testParse("45678");
    int parsedNumber = <int>parsedNumberJson;
    io:println(parsedNumber); // @output 45678

    json parsedNullJson = check testParse("null");
    () parsedNull = <()>parsedNullJson;
    io:println(parsedNull); // @output

    json parsedObjectJson = check testParse("{\"name\":\"supun\"}");
    map<json> parsedObject = <map<json>>parsedObjectJson;
    io:println(parsedObject); // @output {"name":"supun"}

    json parsedArrayJson = check testParse("[\"supun\",45,true,null]");
    json[] parsedArray = <json[]>parsedArrayJson;
    io:println(parsedArray); // @output ["supun",45,true,null]

    json parsedComplexJson = check testParse("{\"name\":\"supun\",\"address\":{\"street\":\"Palm Grove\"}, \"marks\":[78, 45, 87]}");
    map<json> parsedComplex = <map<json>>parsedComplexJson;
    io:println(parsedComplex); // @output {"name":"supun","address":{"street":"Palm Grove"},"marks":[78,45,87]}

    json|error malformedResult = testParse("some words without quotes");
    if malformedResult is error {
        io:println(malformedResult.detail()["message"]); // @output unrecognized token 'some' at line: 1 column: 6
    }

    string[] keys = testGetKeys();
    io:println(keys.length()); // @output 3
    io:println(keys[0]); // @output fname
    io:println(keys[1]); // @output lname
    io:println(keys[2]); // @output age

    json convertedJson = check testStringToJSONConversion();
    map<json> converted = <map<json>>convertedJson;
    io:println(converted); // @output {"foo":"bar"}

    io:println(testJSONArrayToJsonAssignment()); // @output [{"a":"b"},{"c":"d"}]

    [map<json>, map<json>] records = testCloseRecordToMapJsonAssigment();
    io:println(records[0]); // @output {"name":"","age":10}
    io:println(records[1]); // @output {"name":"","age":30}
}
