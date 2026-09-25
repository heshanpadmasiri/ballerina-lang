function testConstrainedMapAssignNegative() returns map<int> {
    map<any> testMap = {};
    return testMap; // @error incompatible types: expected 'map<int>', found 'map'
}

function testConstrainedMapRecordLiteralNegative() returns map<int> {
    map<int> testMap = {index_1: 1, index_2: "two"}; // @error incompatible types: expected 'int', found 'string'
    return testMap;
}

function testConstrainedMapIndexBasedAssignNegative() returns map<string> {
    map<string> testMap = {};
    testMap["name"] = 24; // @error incompatible types: expected 'string', found 'int'
    return testMap;
}

function testConstrainedMapAssignDifferentConstraintsNegative() returns map<int> {
    map<string> testMap = {};
    return testMap; // @error incompatible types: expected 'map<int>', found 'map<string>'
}

type Person record {
    string name;
    int age;
    string address;
};

type Employee record {
    string name;
    int age;
};

function testInvalidMapPassAsArgument() returns map<Person> {
    map<Employee> testMap = {};
    map<Person> m = returnMap(testMap); // @error incompatible types: expected 'map<Person>', found 'map<Employee>'
    return m;
}

function returnMap(map<Person> m) returns map<Person> {
    return m;
}

function testInvalidAnyMapPassAsArgument() returns map<Person> {
    map<any> testMap = {};
    map<Person> m = returnMap(testMap); // @error incompatible types: expected 'map<Person>', found 'map'
    return m;
}
