import ballerina/io;
import ballerina/lang.value;

type Employee record {
    string name;
    string status;
    string batch;
};

type Teacher record {
    string name;
    int age;
    string status;
    string batch;
    string school;
};

type StringTeacher [string, Teacher];
type TeacherArray Teacher[];
type EmployeeMap map<Employee>;
type XmlType xml;
type AnydataMap map<anydata>;
type JsonOrXml json|xml;

function isInt(anydata value) returns boolean => value is int;
function isString(anydata value) returns boolean => value is string;
function isXml(anydata value) returns boolean => value is xml;
function isMap(anydata value) returns boolean => value is map<anydata>;
function isAnydataMap(anydata value) returns boolean => value is map<anydata>;
function isJsonMap(anydata value) returns boolean => value is map<json>;
function isEmployee(anydata value) returns boolean => value is Employee;
function isTeacher(anydata value) returns boolean => value is Teacher;

function stampAnydataToJSON() returns json|error {
    anydata anydataValue = 3;
    return anydataValue.cloneWithType(json);
}

function stampAnydataToRecord() returns Employee|error {
    Teacher teacher = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    anydata anydataValue = teacher;
    return anydataValue.cloneWithType(Employee);
}

function stampAnydataToJSONV2() returns json|error {
    json teacher = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    anydata anydataValue = teacher;
    return anydataValue.cloneWithType(json);
}

function stampAnydataToXML() returns xml|error {
    anydata anydataValue = xml `<book>The Lost World</book>`;
    return anydataValue.cloneWithType(XmlType);
}

function stampAnydataToMap() returns map<Employee>|error {
    Teacher first = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher second = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> teachers = {"a": first, "b": second};
    anydata anydataValue = teachers;
    return anydataValue.cloneWithType(EmployeeMap);
}

function stampAnydataToRecordArray() returns Teacher[]|error {
    Teacher first = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher second = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher[] teachers = [first, second];
    anydata anydataValue = teachers;
    return anydataValue.cloneWithType(TeacherArray);
}

function stampAnydataToTuple() returns [string, Teacher]|error {
    [string, Teacher] tupleValue = [
        "Mohan",
        {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"}
    ];
    anydata anydataValue = tupleValue;
    return anydataValue.cloneWithType(StringTeacher);
}

function stampAnydataMapToAnydataMap() returns map<anydata> {
    map<anydata> anydataMap = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    return checkpanic anydataMap.cloneWithType(AnydataMap);
}

function stampAnydataToAnydata() returns anydata|error {
    json jsonValue = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    anydata anydataValue = jsonValue;
    return anydataValue.cloneWithType(anydata);
}

function stampAnydataMapToUnion() returns json|xml|error {
    map<anydata> anydataMap = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    return anydataMap.cloneWithType(JsonOrXml);
}

public function main() returns error? {
    json jsonValue = check stampAnydataToJSON();
    io:println(jsonValue); // @output 3
    io:println(isInt(jsonValue)); // @output true

    Employee employee = check stampAnydataToRecord();
    io:println(isInt(employee["age"])); // @output true
    io:println(employee["age"]); // @output 25
    io:println(isString(employee.batch)); // @output true
    io:println(employee.batch); // @output LK2014
    io:println(isString(employee["school"])); // @output true
    io:println(employee["school"]); // @output Hindu College

    json stampedJson = check stampAnydataToJSONV2();
    map<json> jsonMap = <map<json>>stampedJson;
    io:println(isMap(jsonMap)); // @output true
    io:println(isJsonMap(jsonMap)); // @output true
    io:println(jsonMap.length()); // @output 5
    io:println(jsonMap["school"]); // @output Hindu College
    io:println(isString(jsonMap["school"])); // @output true

    xml xmlValue = check stampAnydataToXML();
    io:println(xmlValue); // @output <book>The Lost World</book>
    io:println(isXml(xmlValue)); // @output true

    map<Employee> employeeMap = check stampAnydataToMap();
    io:println(employeeMap.length()); // @output 2
    io:println(typeof employeeMap["a"]); // @output typedesc Employee
    Employee firstEmployee = <Employee>employeeMap["a"];
    map<json> firstEmployeeJson = <map<json>>value:toJson(firstEmployee);
    io:println(firstEmployeeJson.length()); // @output 5
    io:println(typeof employeeMap["b"]); // @output typedesc Employee
    Employee secondEmployee = <Employee>employeeMap["b"];
    map<json> secondEmployeeJson = <map<json>>value:toJson(secondEmployee);
    io:println(secondEmployeeJson.length()); // @output 5

    Teacher[] teachers = check stampAnydataToRecordArray();
    io:println(teachers.length()); // @output 2
    io:println(typeof teachers[0]); // @output typedesc Teacher
    io:println(typeof teachers[1]); // @output typedesc Teacher

    [string, Teacher] tupleValue = check stampAnydataToTuple();
    io:println(tupleValue.length()); // @output 2
    io:println(tupleValue[0]); // @output Mohan
    io:println(isString(tupleValue[0])); // @output true
    Teacher tupleTeacher = tupleValue[1];
    io:println(typeof tupleTeacher); // @output typedesc Teacher
    io:println(tupleTeacher.length()); // @output 5
    io:println(tupleTeacher.name); // @output Raja
    io:println(isString(tupleTeacher.name)); // @output true
    io:println(tupleTeacher.age); // @output 25
    io:println(isInt(tupleTeacher.age)); // @output true
    io:println(tupleTeacher.status); // @output single
    io:println(isString(tupleTeacher.status)); // @output true
    io:println(tupleTeacher.batch); // @output LK2014
    io:println(isString(tupleTeacher.batch)); // @output true
    io:println(tupleTeacher.school); // @output Hindu College
    io:println(isString(tupleTeacher.school)); // @output true

    map<anydata> anydataMap = stampAnydataMapToAnydataMap();
    io:println(typeof anydataMap); // @output typedesc AnydataMap
    io:println(anydataMap.length()); // @output 5
    io:println(anydataMap["name"]); // @output Raja
    io:println(anydataMap["age"]); // @output 25
    io:println(anydataMap["status"]); // @output single
    io:println(anydataMap["batch"]); // @output LK2014
    io:println(anydataMap["school"]); // @output Hindu College

    anydata clonedAnydata = check stampAnydataToAnydata();
    io:println(isMap(clonedAnydata)); // @output true
    io:println(typeof clonedAnydata); // @output typedesc map<anydata>

    json|xml unionValue = check stampAnydataMapToUnion();
    map<json> unionMap = <map<json>>unionValue;
    io:println(unionMap.length()); // @output 5
    io:println(isMap(unionMap)); // @output true
    io:println(isJsonMap(unionMap)); // @output true
    io:println(unionMap["name"]); // @output Raja
    io:println(isString(unionMap["name"])); // @output true
    io:println(unionMap["age"]); // @output 25
    io:println(isInt(unionMap["age"])); // @output true
    io:println(unionMap["status"]); // @output single
    io:println(isString(unionMap["status"])); // @output true
}
