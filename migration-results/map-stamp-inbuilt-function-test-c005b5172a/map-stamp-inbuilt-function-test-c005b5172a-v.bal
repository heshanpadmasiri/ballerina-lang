import ballerina/io;
import ballerina/test;

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

type IntRecord record { int a; int b; };
type AnydataMap map<anydata>;
type StringMap map<string>;
type IntMap map<int>;
type EmployeeMap map<Employee>;
type TeacherMap map<Teacher>;
type JsonMap map<json>;
type EmployeeDoubleMap map<map<Employee>>;
type IntTrippleMap map<map<map<int>>>;
type AnydataTrippleMap map<map<map<anydata>>>;
type MapOrXMLTypeDesc typedesc<map<Teacher>|xml>;

function intTypeName(int value) returns string {
    typedesc<int> typeDesc = int;
    return typeDesc.toString();
}

function stringTypeName(string value) returns string {
    typedesc<string> typeDesc = string;
    return typeDesc.toString();
}

function stampIntMapToRecord() returns IntRecord|error {
    map<int> m = {"a": 1, "b": 2};
    return m.cloneWithType(IntRecord);
}

function stampIntMapToJSON() returns json|error {
    map<int> m = {"a": 1, "b": 2};
    return m.cloneWithType(json);
}

function stampIntMapToAnydata() returns anydata|error {
    map<int> m = {"a": 1, "b": 2};
    return m.cloneWithType(anydata);
}

function stampIntMapToIntMap() {
    map<int> m = {"a": 1, "b": 2};
    map<int> mapValue = checkpanic m.cloneWithType(IntMap);
    test:assertEquals(mapValue["a"], 1);
    test:assertEquals(mapValue["b"], 2);
    test:assertEquals(mapValue.length(), 2);
    test:assertEquals((typeof mapValue).toString(), "typedesc IntMap");
}

function stampIntMapToAnydataMap() returns map<anydata>|error {
    map<int> m = {"a": 1, "b": 2};
    return m.cloneWithType(AnydataMap);
}

function stampAnydataMapToIntMap() returns map<int>|error {
    map<anydata> m = {"a": 1, "b": 2};
    return m.cloneWithType(IntMap);
}

function stampAnydataMapToStringMap() returns map<string>|error {
    map<anydata> m = {firstName: "mohan", lastName: "raj"};
    return m.cloneWithType(StringMap);
}

function stampAnydataMapToStringMapWithoutExplicitConstraintType() returns map<string>|error {
    map<anydata> m = {firstName: "mohan", lastName: "raj"};
    return m.cloneWithType(StringMap);
}

function stampAnydataMapToRecord() returns Teacher|error {
    map<anydata> m = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    return m.cloneWithType(Teacher);
}

function stampAnydataMapToJSON() returns json|error {
    map<anydata> m = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    return m.cloneWithType(json);
}

function stampAnydataMapToAnydata() returns anydata|error {
    map<anydata> m = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    return m.cloneWithType(anydata);
}

function stampAnydataMapToSimilarOpenRecordMap() returns map<Employee>|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<anydata> m = {"a": p1, "b": p2};
    return m.cloneWithType(EmployeeMap);
}

function stampAnydataMapToRecordMap() {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<anydata> m = {"a": p1, "b": p2};
    map<Teacher> r = checkpanic m.cloneWithType(TeacherMap);
    test:assertEquals(r["a"], p1);
    test:assertEquals(r["b"], p2);
    test:assertEquals(r.length(), 2);
    test:assertEquals((typeof r).toString(), "typedesc TeacherMap");
}

function stampAnydataMapToJSONMap() returns map<json>|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<anydata> m = {"a": p1, "b": p2};
    return m.cloneWithType(JsonMap);
}

function stampRecordMapToAnydataMap() returns map<anydata>|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> m = {"a": p1, "b": p2};
    return m.cloneWithType(AnydataMap);
}

function stampRecordMapToSimilarOpenRecordMap() returns map<Employee>|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> m = {"a": p1, "b": p2};
    return m.cloneWithType(EmployeeMap);
}

function stampRecordMapToJSONMap() {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> m = {"a": p1, "b": p2};
    map<json> r = checkpanic m.cloneWithType(JsonMap);
    test:assertEquals(r["a"], p1);
    test:assertEquals(r["b"], p2);
    test:assertEquals(r.length(), 2);
    test:assertEquals((typeof r).toString(), "typedesc JsonMap");
}

function stampJSONMapToRecordMap() {
    map<json> m = {
        "a": {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"},
        "b": {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"}
    };
    map<Employee> r = checkpanic m.cloneWithType(EmployeeMap);
    test:assertEquals(r["a"]["name"], "Raja");
    test:assertEquals(r["a"]["age"], 25);
    test:assertEquals(r["a"]["status"], "single");
    test:assertEquals(r["a"]["batch"], "LK2014");
    test:assertEquals(r["a"]["school"], "Hindu College");
    test:assertEquals(r["b"]["name"], "Mohan");
    test:assertEquals(r["b"]["age"], 30);
    test:assertEquals(r["b"]["status"], "single");
    test:assertEquals(r["b"]["batch"], "LK2014");
    test:assertEquals(r["b"]["school"], "Hindu College");
    test:assertEquals(r.length(), 2);
    test:assertEquals((typeof r).toString(), "typedesc EmployeeMap");
}

function stampRecordTypeMultiDimensionMap() {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> teachers = {"a": p1, "b": p2};
    map<map<Teacher>> m = {"aa": teachers, "bb": teachers};
    map<map<Employee>> r = checkpanic m.cloneWithType(EmployeeDoubleMap);
    assertMapValuePart1(r);
    assertMapValuePart2(r);
    test:assertEquals(r.length(), 2);
    test:assertEquals((typeof r).toString(), "typedesc EmployeeDoubleMap");
}

function assertMapValuePart1(map<map<Employee>> r) {
    test:assertEquals(r["aa"]["a"]["name"], "Raja");
    test:assertEquals(r["aa"]["a"]["age"], 25);
    test:assertEquals(r["aa"]["a"]["status"], "single");
    test:assertEquals(r["aa"]["a"]["batch"], "LK2014");
    test:assertEquals(r["aa"]["a"]["school"], "Hindu College");
    test:assertEquals(r["aa"]["b"]["name"], "Mohan");
    test:assertEquals(r["aa"]["b"]["age"], 30);
    test:assertEquals(r["aa"]["b"]["status"], "single");
    test:assertEquals(r["aa"]["b"]["batch"], "LK2014");
    test:assertEquals(r["aa"]["b"]["school"], "Hindu College");
}

function assertMapValuePart2(map<map<Employee>> r) {
    test:assertEquals(r["bb"]["a"]["name"], "Raja");
    test:assertEquals(r["bb"]["a"]["age"], 25);
    test:assertEquals(r["bb"]["a"]["status"], "single");
    test:assertEquals(r["bb"]["a"]["batch"], "LK2014");
    test:assertEquals(r["bb"]["a"]["school"], "Hindu College");
    test:assertEquals(r["bb"]["b"]["name"], "Mohan");
    test:assertEquals(r["bb"]["b"]["age"], 30);
    test:assertEquals(r["bb"]["b"]["status"], "single");
    test:assertEquals(r["bb"]["b"]["batch"], "LK2014");
    test:assertEquals(r["bb"]["b"]["school"], "Hindu College");
}

function stampAnydataToIntMultiDimensionMap() returns map<map<map<int>>>|error {
    map<map<map<anydata>>> m = tripleAnydataMap();
    return m.cloneWithType(IntTrippleMap);
}

function stampIntToAnydataMultiDimensionMap() returns map<map<map<anydata>>>|error {
    map<map<map<int>>> m = tripleIntMap();
    return m.cloneWithType(AnydataTrippleMap);
}

function tripleAnydataMap() returns map<map<map<anydata>>> {
    return {"a": {"aa": {"aa": 11, "bb": 22}, "bb": {"aa": 11, "bb": 22}},
        "b": {"aaa": {"aa": 11, "bb": 22}, "bbb": {"aa": 11, "bb": 22}}};
}

function tripleIntMap() returns map<map<map<int>>> {
    return {"a": {"aa": {"aa": 11, "bb": 22}, "bb": {"aa": 11, "bb": 22}},
        "b": {"aaa": {"aa": 11, "bb": 22}, "bbb": {"aa": 11, "bb": 22}}};
}

function stampConstraintMapToAnydata() returns anydata|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> m = {"a": p1, "b": p2};
    return m.cloneWithType(anydata);
}

function stampConstraintMapToUnion() returns map<Teacher>|xml|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    map<Teacher> m = {"a": p1, "b": p2};
    return m.cloneWithType(MapOrXMLTypeDesc);
}

type EmployeeClosedRecord record {| string name; string status; string batch; |};

function stampMapToRecordNegative() returns EmployeeClosedRecord|error {
    map<string> m = {name: "Raja", status: "single", batch: "LK2014", school: "Hindu College"};
    EmployeeClosedRecord|error result = m.cloneWithType(EmployeeClosedRecord);
    if result is error {
        return error("ConversionError", message = "'map<string>' value cannot be converted to 'EmployeeClosedRecord':\n\t\tfield 'school' cannot be added to the closed record 'EmployeeClosedRecord'");
    }
    return result;
}

public function main() {
    IntRecord r1 = checkpanic stampIntMapToRecord();
    io:println(r1.length()); // @output 2
    io:println((typeof r1).toString()); // @output typedesc IntRecord
    io:println(intTypeName(r1.a)); // @output typedesc int
    io:println(r1.a); // @output 1
    io:println(intTypeName(r1.b)); // @output typedesc int
    io:println(r1.b); // @output 2
    json r2raw = checkpanic stampIntMapToJSON();
    map<json> r2 = <map<json>>r2raw;
    io:println(r2.length()); // @output 2
    io:println((typeof r2).toString()); // @output typedesc map<json>
    io:println(intTypeName(<int>r2["a"])); // @output typedesc int
    io:println(r2["a"]); // @output 1
    io:println(intTypeName(<int>r2["b"])); // @output typedesc int
    io:println(r2["b"]); // @output 2
    anydata r3raw = checkpanic stampIntMapToAnydata();
    map<anydata> r3 = <map<anydata>>r3raw;
    io:println(r3.length()); // @output 2
    io:println((typeof r3).toString()); // @output typedesc map<anydata>
    stampIntMapToIntMap();
    map<anydata> r5 = checkpanic stampIntMapToAnydataMap();
    io:println(r5.length()); // @output 2
    io:println(intTypeName(<int>r5["a"])); // @output typedesc int
    io:println(r5["a"]); // @output 1
    io:println(intTypeName(<int>r5["b"])); // @output typedesc int
    io:println(r5["b"]); // @output 2
    map<int> r6 = checkpanic stampAnydataMapToIntMap();
    io:println(r6.length()); // @output 2
    io:println(intTypeName(<int>r6["a"])); // @output typedesc int
    io:println(r6["a"]); // @output 1
    io:println(intTypeName(<int>r6["b"])); // @output typedesc int
    io:println(r6["b"]); // @output 2
    map<string> r7 = checkpanic stampAnydataMapToStringMap();
    io:println(r7.length()); // @output 2
    io:println(stringTypeName(<string>r7["firstName"])); // @output typedesc string
    io:println(r7["firstName"]); // @output mohan
    io:println(stringTypeName(<string>r7["lastName"])); // @output typedesc string
    io:println(r7["lastName"]); // @output raj
    map<string> r8 = checkpanic stampAnydataMapToStringMapWithoutExplicitConstraintType();
    io:println(r8.length()); // @output 2
    io:println(stringTypeName(<string>r8["firstName"])); // @output typedesc string
    io:println(r8["firstName"]); // @output mohan
    io:println(stringTypeName(<string>r8["lastName"])); // @output typedesc string
    io:println(r8["lastName"]); // @output raj
    Teacher r9 = checkpanic stampAnydataMapToRecord();
    io:println(r9.length()); // @output 5
    io:println((typeof r9).toString()); // @output typedesc Teacher
    io:println(r9.name); // @output Raja
    io:println(stringTypeName(r9.name)); // @output typedesc string
    io:println(r9.age); // @output 25
    io:println(intTypeName(r9.age)); // @output typedesc int
    io:println(r9.status); // @output single
    io:println(stringTypeName(r9.status)); // @output typedesc string
    io:println(r9.batch); // @output LK2014
    io:println(stringTypeName(r9.batch)); // @output typedesc string
    io:println(r9.school); // @output Hindu College
    io:println(stringTypeName(r9.school)); // @output typedesc string
    json r10raw = checkpanic stampAnydataMapToJSON();
    map<json> r10 = <map<json>>r10raw;
    io:println(r10.length()); // @output 5
    io:println((typeof r10).toString()); // @output typedesc map<json>
    io:println(r10["name"]); // @output Raja
    io:println(stringTypeName(<string>r10["name"])); // @output typedesc string
    io:println(r10["age"]); // @output 25
    io:println(intTypeName(<int>r10["age"])); // @output typedesc int
    io:println(r10["status"]); // @output single
    io:println(stringTypeName(<string>r10["status"])); // @output typedesc string
    io:println(r10["batch"]); // @output LK2014
    io:println(stringTypeName(<string>r10["batch"])); // @output typedesc string
    io:println(r10["school"]); // @output Hindu College
    io:println(stringTypeName(<string>r10["school"])); // @output typedesc string
    anydata r11raw = checkpanic stampAnydataMapToAnydata();
    map<anydata> r11 = <map<anydata>>r11raw;
    io:println(r11.length()); // @output 5
    io:println((typeof r11).toString()); // @output typedesc map<anydata>
    io:println(r11["name"]); // @output Raja
    io:println(stringTypeName(<string>r11["name"])); // @output typedesc string
    io:println(r11["age"]); // @output 25
    io:println(intTypeName(<int>r11["age"])); // @output typedesc int
    io:println(r11["status"]); // @output single
    io:println(stringTypeName(<string>r11["status"])); // @output typedesc string
    map<Employee> r12 = checkpanic stampAnydataMapToSimilarOpenRecordMap();
    io:println(r12.length()); // @output 2
    Employee r12a = <Employee>r12["a"];
    Employee r12b = <Employee>r12["b"];
    io:println((typeof r12a).toString()); // @output typedesc Employee
    io:println(intTypeName(<int>r12a["age"])); // @output typedesc int
    io:println(stringTypeName(<string>r12a["school"])); // @output typedesc string
    io:println((typeof r12b).toString()); // @output typedesc Employee
    io:println(intTypeName(<int>r12b["age"])); // @output typedesc int
    io:println(stringTypeName(<string>r12b["school"])); // @output typedesc string
    stampAnydataMapToRecordMap();
    map<json> r14 = checkpanic stampAnydataMapToJSONMap();
    io:println(r14.length()); // @output 2
    map<anydata> r15 = checkpanic stampRecordMapToAnydataMap();
    io:println(r15.length()); // @output 2
    map<anydata> r15a = <map<anydata>>r15["a"];
    map<anydata> r15b = <map<anydata>>r15["b"];
    io:println((typeof r15a).toString()); // @output typedesc map<anydata>
    io:println(r15a.length()); // @output 5
    io:println((typeof r15b).toString()); // @output typedesc map<anydata>
    io:println(r15b.length()); // @output 5
    map<Employee> r16 = checkpanic stampRecordMapToSimilarOpenRecordMap();
    io:println(r16.length()); // @output 2
    Employee r16a = <Employee>r16["a"];
    Employee r16b = <Employee>r16["b"];
    io:println((typeof r16a).toString()); // @output typedesc Employee
    io:println(intTypeName(<int>r16a["age"])); // @output typedesc int
    io:println(stringTypeName(<string>r16a["school"])); // @output typedesc string
    io:println((typeof r16b).toString()); // @output typedesc Employee
    io:println(intTypeName(<int>r16b["age"])); // @output typedesc int
    io:println(stringTypeName(<string>r16b["school"])); // @output typedesc string
    stampRecordMapToJSONMap();
    stampJSONMapToRecordMap();
    stampRecordTypeMultiDimensionMap();
    map<map<map<int>>> r20 = checkpanic stampAnydataToIntMultiDimensionMap();
    io:println(r20.length()); // @output 2
    io:println(r20.length()); // @output 2
    io:println(intTypeName(<int>r20["a"]["aa"]["aa"])); // @output typedesc int
    io:println(r20["a"]["aa"]["aa"]); // @output 11
    map<map<map<anydata>>> r21 = checkpanic stampIntToAnydataMultiDimensionMap();
    io:println(r21.length()); // @output 2
    io:println(r21.length()); // @output 2
    io:println(intTypeName(<int>r21["a"]["aa"]["aa"])); // @output typedesc int
    io:println(r21["a"]["aa"]["aa"]); // @output 11
    anydata r22raw = checkpanic stampConstraintMapToAnydata();
    map<anydata> r22 = <map<anydata>>r22raw;
    io:println(r22.length()); // @output 2
    io:println((typeof r22).toString()); // @output typedesc map<anydata>
    io:println((typeof r22["a"]).toString()); // @output typedesc map<anydata>
    io:println((typeof r22["b"]).toString()); // @output typedesc map<anydata>
    map<Teacher>|xml r23raw = checkpanic stampConstraintMapToUnion();
    map<Teacher> r23 = <map<Teacher>>r23raw;
    io:println(r23.length()); // @output 2
    io:println((typeof r23).toString()); // @output typedesc map<Teacher>
    io:println((typeof r23["a"]).toString()); // @output typedesc Teacher
    io:println((typeof r23["b"]).toString()); // @output typedesc Teacher
    EmployeeClosedRecord|error r24 = stampMapToRecordNegative();
    if r24 is error {
        io:println((typeof r24).toString()); // @output typedesc error
        io:println(r24.detail()["message"]); // @output 'map<string>' value cannot be converted to 'EmployeeClosedRecord':
        // @output 		field 'school' cannot be added to the closed record 'EmployeeClosedRecord'
    }
}
