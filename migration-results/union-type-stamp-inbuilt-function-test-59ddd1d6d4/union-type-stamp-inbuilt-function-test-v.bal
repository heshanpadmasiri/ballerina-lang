import ballerina/io;
import ballerina/test;

type Employee record {
    string name;
    string status;
    string batch;
};

type JsonMap map<json>;

type Person record {|
    string name;
    string status;
    string batch;
    string school;
|};

type Teacher record {
    string name;
    int age;
    string status;
    string batch;
    string school;
};

function stampUnionToRecord() returns Employee|error {
    int|float|Employee unionVar = {name: "Raja", status: "single", batch: "LK2014", "school": "Hindu College"};
    Employee|error employee = unionVar.cloneWithType(Employee);
    return employee;
}

function stampUnionToJSON() returns json|error {
    int|float|json unionVar = {name: "Raja", status: "single", batch: "LK2014", school: "Hindu College"};
    json|error jsonValue = unionVar.cloneWithType(json);
    return jsonValue;
}

type XmlType xml;

function stampUnionToXML() {
    int|float|xml unionVar = xml `<book>The Lost World</book>`;
    xml xmlValue = checkpanic unionVar.cloneWithType(XmlType);
    test:assertEquals(xmlValue, xml `<book>The Lost World</book>`);
}

type IntMap map<int>;

function stampUnionToIntMap() {
    int|float|map<int> unionVar = {"a": 1, "b": 2};
    map<int> mapValue = checkpanic unionVar.cloneWithType(IntMap);
    test:assertEquals(mapValue["a"], 1);
    test:assertEquals(mapValue["b"], 2);
    test:assertEquals(mapValue.length(), 2);
    test:assertEquals((typeof mapValue).toString(), "typedesc IntMap");
}

type EmployeeMap map<Employee>;

function stampUnionToConstraintMap() {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> teacherMap = {"a": p1, "b": p2};
    int|float|map<Teacher> unionVar = teacherMap;
    map<Employee> mapValue = checkpanic unionVar.cloneWithType(EmployeeMap);
    test:assertEquals(mapValue["a"], p1);
    test:assertEquals(mapValue["b"], p2);
    test:assertEquals(mapValue.length(), 2);
    test:assertEquals((typeof mapValue).toString(), "typedesc EmployeeMap");
}

function stampUnionToAnydata() returns anydata|error {
    int|float|string|boolean unionValue = "mohan";
    anydata|error anydataValue = unionValue.cloneWithType(anydata);
    return anydataValue;
}

type StringString [string, string];

function stampUnionToTuple() returns [string, string]|error {
    int|float|[string, string] unionVar = ["mohan", "LK2014"];
    [string, string]|error tupleValue = unionVar.cloneWithType(StringString);
    return tupleValue;
}

function stampUnionToAnydataV2() returns anydata|error {
    int|float|string|boolean unionValue = "mohan";
    anydata|error anydataValue = unionValue.cloneWithType(anydata);
    return anydataValue;
}

type UnionTypedesc typedesc<int|float|map<Teacher>>;

function stampUnionToConstraintMapToUnion() returns int|float|map<Teacher>|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> teacherMap = {"a": p1, "b": p2};
    int|float|map<Teacher> unionVar = teacherMap;
    int|float|map<Teacher>|error mapValue = unionVar.cloneWithType(UnionTypedesc);
    return mapValue;
}

public function main() returns error? {
    Employee employee = check stampUnionToRecord();
    io:println(employee.length()); // @output 4
    test:assertEquals((typeof employee).toString(), "typedesc Employee");
    test:assertTrue(employee.batch is string);
    test:assertTrue(employee["school"] is string);
    io:println(employee.batch); // @output LK2014
    io:println(employee["school"]); // @output Hindu College

    json jsonValue = check stampUnionToJSON();
    if jsonValue is map<json> {
        io:println(jsonValue.length()); // @output 4
        test:assertEquals((typeof jsonValue).toString(), "typedesc map<json>");
        test:assertTrue(jsonValue["batch"] is string);
        test:assertTrue(jsonValue["school"] is string);
        io:println(jsonValue["batch"]); // @output LK2014
        io:println(jsonValue["school"]); // @output Hindu College
    } else {
        return error("expected a map<json>");
    }

    stampUnionToXML();
    stampUnionToIntMap();
    stampUnionToConstraintMap();

    anydata anydataValue = check stampUnionToAnydata();
    test:assertTrue(anydataValue is string);
    io:println(anydataValue); // @output mohan

    [string, string] tupleValue = check stampUnionToTuple();
    io:println(tupleValue[0]); // @output mohan
    io:println(tupleValue[1]); // @output LK2014

    anydata anydataValueV2 = check stampUnionToAnydataV2();
    test:assertTrue(anydataValueV2 is string);
    io:println(anydataValueV2); // @output mohan

    int|float|map<Teacher> constraintMap = check stampUnionToConstraintMapToUnion();
    if constraintMap is map<Teacher> {
        io:println(constraintMap.length()); // @output 2
        test:assertTrue(constraintMap.hasKey("a"));
        test:assertTrue(constraintMap.hasKey("b"));
        test:assertEquals((typeof constraintMap["a"]).toString(), "typedesc Teacher");
        test:assertEquals((typeof constraintMap["b"]).toString(), "typedesc Teacher");
        Teacher? teacherA = constraintMap["a"];
        if teacherA is Teacher {
            test:assertTrue(teacherA.age is int);
            test:assertTrue(teacherA.school is string);
            test:assertTrue(teacherA.batch is string);
        } else {
            return error("expected Teacher entry a");
        }
        Teacher? teacherB = constraintMap["b"];
        if teacherB is Teacher {
            test:assertTrue(teacherB.age is int);
            test:assertTrue(teacherB.school is string);
            test:assertTrue(teacherB.batch is string);
        } else {
            return error("expected Teacher entry b");
        }
    } else {
        return error("expected a map<Teacher>");
    }
}
