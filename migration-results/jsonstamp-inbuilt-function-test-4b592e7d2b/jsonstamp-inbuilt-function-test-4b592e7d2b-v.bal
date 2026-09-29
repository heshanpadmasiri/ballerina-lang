import ballerina/io;
import ballerina/test;

type Student record {|
    string name;
    string status;
    string batch;
    string school;
|};

type Employee record {
    string name;
    string status;
    string batch;
};

type AnydataMap map<anydata>;
type AnydataArray anydata[];
type AnydataArrayOrAnydataMap anydata[]|map<anydata>;
type StudentArray Student[];
type StringMap map<string>;

function stampJSONToAnydata() returns anydata|error {
    json jsonValue = 3;
    return jsonValue.cloneWithType(anydata);
}

function stampJSONToAnydataV2() returns anydata|error {
    json jsonValue = [1, false, null, "foo", {first: "John", last: "Pala"}];
    return jsonValue.cloneWithType(anydata);
}

function stampJSONToRecord() returns Employee|error {
    json employee = {name: "John", status: "single", batch: "LK2014"};
    return employee.cloneWithType(Employee);
}

function stampJSONToRecordV2() returns Employee|error {
    json employee = {name: "John", status: "single", batch: "LK2014", school: "Hindu College"};
    return employee.cloneWithType(Employee);
}

function stampJSONToJSON() returns json|error {
    json employee = {name: "John", status: "single", batch: "LK2014", school: "Hindu College"};
    return employee.cloneWithType(json);
}

function stampJSONToMap() {
    json employee = {name: "John", status: "single", batch: "LK2014", school: "Hindu College"};
    map<anydata> mapValue = checkpanic employee.cloneWithType(AnydataMap);
    test:assertEquals(mapValue["name"], "John");
    test:assertEquals(mapValue["status"], "single");
    test:assertEquals(mapValue["batch"], "LK2014");
    test:assertEquals(mapValue["school"], "Hindu College");
    test:assertEquals(mapValue.length(), 4);
    test:assertEquals((typeof mapValue).toString(), "typedesc AnydataMap");
}

function stampJSONToMapV2() {
    json teacher = {
        name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College",
        emp: {name: "John", status: "single", batch: "LK2014"}
    };
    map<anydata> mapValue = checkpanic teacher.cloneWithType(AnydataMap);
    test:assertEquals(mapValue["name"], "Raja");
    test:assertEquals(mapValue["age"], 25);
    test:assertEquals(mapValue["status"], "single");
    test:assertEquals(mapValue["batch"], "LK2014");
    test:assertEquals(mapValue["school"], "Hindu College");
    test:assertEquals(mapValue["emp"], {name: "John", status: "single", batch: "LK2014"});
    test:assertEquals(mapValue.length(), 6);
    test:assertEquals((typeof mapValue).toString(), "typedesc AnydataMap");
}

function stampJSONArrayToConstraintArray() returns Student[]|error {
    json employeeArray = [
        {name: "John", status: "single", batch: "LK2014", school: "Hindu College"},
        {name: "Raja", status: "married", batch: "LK2014", school: "Hindu College"}
    ];
    return employeeArray.cloneWithType(StudentArray);
}

function stampJSONArrayToAnyTypeArray() returns anydata[]|error {
    json jsonArray = [1, false, "foo", {first: "John", last: "Pala"}];
    return jsonArray.cloneWithType(AnydataArray);
}

function stampJSONToAnydataV3() returns anydata|error {
    json jsonValue = {name: "John", status: "single", batch: "LK2014"};
    return jsonValue.cloneWithType(anydata);
}

function stampJSONToUnion() returns anydata[]|map<anydata>|error {
    json jsonValue = {name: "John", status: "single", batch: "LK2014"};
    return jsonValue.cloneWithType(AnydataArrayOrAnydataMap);
}

function stampJSONArrayWithNullToAnydataArray() returns anydata[]|error {
    json jsonArray = [1, false, "foo", (), {first: "John", last: "Pala"}];
    return jsonArray.cloneWithType(AnydataArray);
}

type Foo record {|
    string[] a;
|};

function stampJSONToRecordWithArray() returns Foo|error {
    json j1 = {a: ["a", "b"]};
    return j1.cloneWithType(Foo);
}

function stampJSONToRecordNegative() returns Student|error {
    json employee = {name: "John", age: 23, status: "single", batch: "LK2014", school: "Hindu College"};
    return employee.cloneWithType(Student);
}

function stampJSONToMapNegative() returns map<string>|error {
    json employee = {name: "John", age: 23, status: "single", batch: "LK2014", school: "Hindu College"};
    return employee.cloneWithType(StringMap);
}

type StringArray record {|
    string[]? a;
|};

function stampNullJSONToArrayNegative() returns StringArray|error {
    json j = ();
    return j.cloneWithType(StringArray);
}

public function main() {
    anydata scalar = checkpanic stampJSONToAnydata();
    io:println(scalar); // @output 3
    io:println((typeof scalar).toString()); // @output typedesc 3

    anydata[] values = <anydata[]>checkpanic stampJSONToAnydataV2();
    io:println(values.length()); // @output 5

    Employee employee = checkpanic stampJSONToRecord();
    io:println((typeof employee).toString()); // @output typedesc Employee

    Employee employeeV2 = checkpanic stampJSONToRecordV2();
    io:println((typeof employeeV2).toString()); // @output typedesc Employee
    io:println(employeeV2.length()); // @output 4
    io:println(employeeV2["school"]); // @output Hindu College
    io:println((typeof employeeV2["school"]).toString()); // @output typedesc Hindu College

    json jsonEmployee = checkpanic stampJSONToJSON();
    io:println((typeof jsonEmployee).toString()); // @output typedesc map<json>
    map<json> jsonEmployeeMap = <map<json>>jsonEmployee;
    io:println(jsonEmployeeMap.length()); // @output 4

    stampJSONToMap();
    stampJSONToMapV2();

    Student[] students = checkpanic stampJSONArrayToConstraintArray();
    io:println(students.length()); // @output 2
    io:println((typeof students[0]).toString()); // @output typedesc Student
    io:println(students[0].length()); // @output 4
    io:println(students[0].batch); // @output LK2014
    io:println((typeof students[0].batch).toString()); // @output typedesc LK2014
    io:println((typeof students[1]).toString()); // @output typedesc Student
    io:println(students[1].length()); // @output 4
    io:println(students[1].batch); // @output LK2014
    io:println((typeof students[0].batch).toString()); // @output typedesc LK2014

    anydata[] anydataValues = checkpanic stampJSONArrayToAnyTypeArray();
    io:println(anydataValues.length()); // @output 4
    io:println(anydataValues[0]); // @output 1
    io:println((typeof anydataValues[0]).toString()); // @output typedesc 1
    io:println(anydataValues[1]); // @output false
    io:println((typeof anydataValues[1]).toString()); // @output typedesc false
    io:println(anydataValues[2]); // @output foo
    io:println((typeof anydataValues[2]).toString()); // @output typedesc foo
    map<anydata> nestedMap = <map<anydata>>anydataValues[3];
    io:println(nestedMap.length()); // @output 2
    io:println((typeof nestedMap).toString()); // @output typedesc map<anydata>

    anydata[]|map<anydata> unionValue = checkpanic stampJSONToUnion();
    io:println((typeof unionValue).toString()); // @output typedesc map<anydata>

    anydata anydataMap = checkpanic stampJSONToAnydataV3();
    io:println((typeof anydataMap).toString()); // @output typedesc map<anydata>

    anydata[] valuesWithNull = checkpanic stampJSONArrayWithNullToAnydataArray();
    io:println(valuesWithNull.length()); // @output 5
    io:println(valuesWithNull[0]); // @output 1
    io:println((typeof valuesWithNull[0]).toString()); // @output typedesc 1
    io:println(valuesWithNull[1]); // @output false
    io:println((typeof valuesWithNull[1]).toString()); // @output typedesc false
    io:println(valuesWithNull[2]); // @output foo
    io:println((typeof valuesWithNull[2]).toString()); // @output typedesc foo
    io:println(valuesWithNull[3]); // @output
    map<anydata> nullableNestedMap = <map<anydata>>valuesWithNull[4];
    io:println(nullableNestedMap.length()); // @output 2
    io:println((typeof nullableNestedMap).toString()); // @output typedesc map<anydata>

    Foo foo = checkpanic stampJSONToRecordWithArray();
    io:println((typeof foo).toString()); // @output typedesc Foo
    io:println((typeof foo.a).toString()); // @output typedesc string[]

    Student|error recordResult = stampJSONToRecordNegative();
    if recordResult is error {
        var message = recordResult.detail()["message"];
        if message is string {
            if message != "'map<json>' value cannot be converted to 'Student': \n\t\tfield 'age' cannot be added to the closed record 'Student'" {
                panic error("unexpected conversion message");
            }
            io:println("'map<json>' value cannot be converted to 'Student': "); // @output 'map<json>' value cannot be converted to 'Student': 
            io:println("\t\tfield 'age' cannot be added to the closed record 'Student'"); // @output 		field 'age' cannot be added to the closed record 'Student'
        } else {
            panic error("conversion message was not a string");
        }
    } else {
        panic error("conversion unexpectedly succeeded");
    }
    map<string>|error mapResult = stampJSONToMapNegative();
    if mapResult is error {
        var message = mapResult.detail()["message"];
        if message is string {
            if message != "'map<json>' value cannot be converted to 'StringMap': \n\t\tmap field 'age' should be of type 'string', found '23'" {
                panic error("unexpected conversion message");
            }
            io:println("'map<json>' value cannot be converted to 'StringMap': "); // @output 'map<json>' value cannot be converted to 'StringMap': 
            io:println("\t\tmap field 'age' should be of type 'string', found '23'"); // @output 		map field 'age' should be of type 'string', found '23'
        } else {
            panic error("conversion message was not a string");
        }
    } else {
        panic error("conversion unexpectedly succeeded");
    }
    StringArray|error nullResult = stampNullJSONToArrayNegative();
    if nullResult is error {
        var message = nullResult.detail()["message"];
        if message is string {
            io:println(message); // @output cannot convert '()' to type 'StringArray'
        } else {
            panic error("conversion message was not a string");
        }
    } else {
        panic error("conversion unexpectedly succeeded");
    }
}
