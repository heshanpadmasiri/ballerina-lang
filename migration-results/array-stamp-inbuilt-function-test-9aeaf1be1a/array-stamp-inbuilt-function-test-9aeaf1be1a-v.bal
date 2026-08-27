import ballerina/io;

type Student record {| string name; string status; string batch; string school; |};
type Employee record { string name; string status; string batch; };
type Teacher record { string name; int age; string status; string batch; string school; };
type AnydataMapArray map<anydata>[];
type AnydataArray anydata[];
type TeacherArray Teacher[];
type EmployeeArray Employee[];
type EmployeeArrayOrIntTypedesc typedesc<Employee[]|int>;
type EmployeeStudent [Employee, Student];
type IntArray int[];
type JsonArray json[];
type IntInt [int, int];
type AnydataAnydata [anydata, anydata];

function stampRecordToAnydataArray() returns anydata[]|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(AnydataArray);
}

function stampAnydataToRecordArray() returns Teacher[]|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    anydata[] anydataArray = [p1, p2];
    return anydataArray.cloneWithType(TeacherArray);
}

function stampAnydataToSimilarOpenRecordArray() returns Employee[]|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    anydata[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(EmployeeArray);
}

function stampRecordToSimilarOpenRecordArray() returns Employee[]|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(EmployeeArray);
}

function stampConstraintArrayToJSONArray() returns json|error {
    Student[] studentArray = [
        {name: "John", status: "single", batch: "LK2014", school: "Hindu College"},
        {name: "Raja", status: "married", batch: "LK2014", school: "Hindu College"}
    ];
    return studentArray.cloneWithType(json);
}

function stampRecordToAnydata() returns anydata|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(anydata);
}

function stampRecordToAnydataArrayV2() returns anydata[]|error {
    Teacher p1 = {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher p2 = {name: "Mohan", age: 30, status: "single", batch: "LK2014", school: "Hindu College"};
    Teacher[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(AnydataArray);
}

function stampAnydataArrayToUnion() returns Employee[]|int|error {
    Employee p1 = {name: "Raja", "age": 25, status: "single", batch: "LK2014", "school": "Hindu College"};
    Employee p2 = {name: "Mohan", "age": 30, status: "single", batch: "LK2014", "school": "Hindu College"};
    Employee[] teacherArray = [p1, p2];
    return teacherArray.cloneWithType(EmployeeArrayOrIntTypedesc);
}

function stampArrayValueToTuple() returns [Employee, Student]|error {
    Employee[] arrayValue = [
        {name: "Mohan", status: "single", batch: "LK2015", "school": "Royal College"},
        {name: "Raja", status: "single", batch: "LK2014", "school": "Hindu College"}
    ];
    return arrayValue.cloneWithType(EmployeeStudent);
}

function stampJSONToBasicArray() returns int[]|error {
    json jsonValue = [1, 2, 3, 4];
    return jsonValue.cloneWithType(IntArray);
}

function stampAnydataToBasicArray() returns int[]|error {
    anydata[] anydataValue = [1, 2, 3, 4];
    return anydataValue.cloneWithType(IntArray);
}

function stampAnydataArrayToBasicArray() returns int[]|error {
    anydata[] anydataArray = [1, 2, 3, 4];
    return anydataArray.cloneWithType(IntArray);
}

function stampJSONArrayToBasicArray() returns int[]|error {
    json[] jsonValue = [1, 2, 3, 4];
    return jsonValue.cloneWithType(IntArray);
}

function stampBasicArrayToJSON() returns json|error {
    int[] intArrayValue = [1, 2, 3, 4];
    return intArrayValue.cloneWithType(json);
}

function stampBasicArrayToAnydata() returns anydata|error {
    int[] intArrayValue = [1, 2, 3, 4];
    return intArrayValue.cloneWithType(anydata);
}

function stampBasicArrayToAnydataArray() returns anydata[]|error {
    int[] intArrayValue = [1, 2, 3, 4];
    return intArrayValue.cloneWithType(AnydataArray);
}

function stampBasicArrayToJSONArray() returns json[]|error {
    int[] intArrayValue = [1, 2, 3, 4];
    return intArrayValue.cloneWithType(JsonArray);
}

function stampBasicArrayToTuple() returns [int, int]|error {
    int[] intArrayValue = [1, 2];
    return intArrayValue.cloneWithType(IntInt);
}

function stampAnydataBasicArrayToTuple() returns [int, int]|error {
    int[] intArrayValue = [1, 2];
    anydata anydataValue = intArrayValue;
    return anydataValue.cloneWithType(IntInt);
}

function stampBasicArrayToAnydataTuple() returns [anydata, anydata]|error {
    int[] intArrayValue = [1, 2];
    return intArrayValue.cloneWithType(AnydataAnydata);
}

function stampBasicArrayToBasicArray() returns int[]|error {
    int[] intArrayValue = [1, 2];
    return intArrayValue.cloneWithType(IntArray);
}

function stampBasicMapArrayToAnydataMapArray() returns map<anydata>[]|error {
    map<int> map1 = {a: 5, b: 10};
    map<int> map2 = {a: 15, b: 20};
    map<int>[] intMap = [map1, map2];
    return intMap.cloneWithType(AnydataMapArray);
}

function stampRecordArrayToJsonArray() returns json[]|error {
    Employee e1 = {name: "Waruna", status: "single", batch: "LK2018", "age": 10};
    Employee e2 = {name: "Heshitha", status: "single", batch: "LK2019", "age": 15};
    Employee[] employeeArray = [e1, e2];
    return check employeeArray.cloneWithType(JsonArray);
}

public function main() returns error? {
    anydata[] r1 = check stampRecordToAnydataArray();
    io:println(r1.length()); // @output 2
    io:println(typeof (r1[0])); // @output typedesc map<anydata>
    io:println(typeof (r1[1])); // @output typedesc map<anydata>

    Teacher[] r2 = check stampAnydataToRecordArray();
    io:println(r2.length()); // @output 2
    io:println(typeof (r2[0])); // @output typedesc Teacher
    io:println(typeof (r2[1])); // @output typedesc Teacher

    Employee[] r3 = check stampAnydataToSimilarOpenRecordArray();
    io:println(r3.length()); // @output 2
    io:println(typeof (r3[0])); // @output typedesc Employee
    io:println(typeof (r3[0]["age"])); // @output typedesc 25
    io:println(typeof (r3[0]["school"])); // @output typedesc Hindu College
    io:println(typeof (r3[1])); // @output typedesc Employee
    io:println(typeof (r3[1]["age"])); // @output typedesc 30
    io:println(typeof (r3[1]["school"])); // @output typedesc Hindu College

    Employee[] r4 = check stampRecordToSimilarOpenRecordArray();
    io:println(r4.length()); // @output 2
    io:println(typeof (r4[0])); // @output typedesc Employee
    io:println(typeof (r4[0]["age"])); // @output typedesc 25
    io:println(typeof (r4[0]["school"])); // @output typedesc Hindu College
    io:println(typeof (r4[1])); // @output typedesc Employee
    io:println(typeof (r4[1]["age"])); // @output typedesc 30
    io:println(typeof (r4[1]["school"])); // @output typedesc Hindu College

    json r5 = check stampConstraintArrayToJSONArray();
    if r5 is json[] {
        io:println(r5.length()); // @output 2
        json r5First = r5[0];
        json r5Second = r5[1];
        if r5First is map<json> && r5Second is map<json> {
            io:println(typeof r5First); // @output typedesc map<json>
            io:println(r5First.length()); // @output 4
            io:println(r5First.batch); // @output LK2014
            io:println(typeof r5First.batch); // @output typedesc LK2014
            io:println(typeof r5Second); // @output typedesc map<json>
            io:println(r5Second.length()); // @output 4
            io:println(r5Second.batch); // @output LK2014
            io:println(typeof r5Second.batch); // @output typedesc LK2014
        } else {
            return error("expected map<json> values");
        }
    } else {
        return error("expected json[] value");
    }

    anydata r6 = check stampRecordToAnydata();
    if r6 is anydata[] {
        io:println(r6.length()); // @output 2
        io:println(typeof (r6[0])); // @output typedesc map<anydata>
        io:println(typeof (r6[1])); // @output typedesc map<anydata>
    } else {
        return error("expected anydata[] value");
    }

    anydata[] r7 = check stampRecordToAnydataArrayV2();
    io:println(r7.length()); // @output 2
    io:println(typeof (r7[0])); // @output typedesc map<anydata>
    io:println(typeof (r7[1])); // @output typedesc map<anydata>

    Employee[]|int r8 = check stampAnydataArrayToUnion();
    if r8 is Employee[] {
        io:println(r8.length()); // @output 2
        io:println(typeof (r8[0])); // @output typedesc Employee
        io:println(typeof (r8[0]["age"])); // @output typedesc 25
        io:println(typeof (r8[0]["school"])); // @output typedesc Hindu College
        io:println(typeof (r8[1])); // @output typedesc Employee
        io:println(typeof (r8[1]["age"])); // @output typedesc 30
        io:println(typeof (r8[1]["school"])); // @output typedesc Hindu College
    } else {
        return error("expected Employee[] value");
    }

    [Employee, Student] r9 = check stampArrayValueToTuple();
    io:println(r9.length()); // @output 2
    io:println(typeof (r9[0])); // @output typedesc Employee
    io:println(typeof (r9[1])); // @output typedesc Student
    io:println(r9[1].length()); // @output 4
    io:println(r9[1].name); // @output Raja
    io:println(typeof r9[1].name); // @output typedesc Raja
    io:println(r9[1].status); // @output single
    io:println(typeof r9[1].status); // @output typedesc single
    io:println(r9[1].batch); // @output LK2014
    io:println(typeof r9[1].batch); // @output typedesc LK2014
    io:println(r9[1].school); // @output Hindu College
    io:println(typeof r9[1].school); // @output typedesc Hindu College
    io:println(r9[0]["school"]); // @output Royal College
    io:println(typeof (r9[0]["school"])); // @output typedesc Royal College

    int[] r10 = check stampJSONToBasicArray();
    io:println(r10.length()); // @output 4
    io:println(typeof r10); // @output typedesc IntArray
    io:println(r10[0]); // @output 1
    io:println(r10[1]); // @output 2
    io:println(r10[2]); // @output 3
    io:println(r10[3]); // @output 4
    int[] r11 = check stampAnydataToBasicArray();
    io:println(r11.length()); // @output 4
    io:println(typeof r11); // @output typedesc IntArray
    io:println(r11[0]); // @output 1
    io:println(r11[1]); // @output 2
    io:println(r11[2]); // @output 3
    io:println(r11[3]); // @output 4
    int[] r12 = check stampAnydataArrayToBasicArray();
    io:println(r12.length()); // @output 4
    io:println(typeof r12); // @output typedesc IntArray
    io:println(r12[0]); // @output 1
    io:println(r12[1]); // @output 2
    io:println(r12[2]); // @output 3
    io:println(r12[3]); // @output 4
    int[] r13 = check stampJSONArrayToBasicArray();
    io:println(r13.length()); // @output 4
    io:println(typeof r13); // @output typedesc IntArray
    io:println(r13[0]); // @output 1
    io:println(r13[1]); // @output 2
    io:println(r13[2]); // @output 3
    io:println(r13[3]); // @output 4

    json r14 = check stampBasicArrayToJSON();
    if r14 is json[] {
        io:println(r14[0]); // @output 1
        io:println(r14[1]); // @output 2
        io:println(r14[2]); // @output 3
        io:println(r14[3]); // @output 4
    } else {
        return error("expected json[] value");
    }
    anydata r15 = check stampBasicArrayToAnydata();
    if r15 is anydata[] {
        io:println(r15[0]); // @output 1
        io:println(r15[1]); // @output 2
        io:println(r15[2]); // @output 3
        io:println(r15[3]); // @output 4
    } else {
        return error("expected anydata[] value");
    }
    anydata[] r16 = check stampBasicArrayToAnydataArray();
    io:println(r16[0]); // @output 1
    io:println(r16[1]); // @output 2
    io:println(r16[2]); // @output 3
    io:println(r16[3]); // @output 4
    json[] r17 = check stampBasicArrayToJSONArray();
    io:println(r17[0]); // @output 1
    io:println(r17[1]); // @output 2
    io:println(r17[2]); // @output 3
    io:println(r17[3]); // @output 4

    [int, int] r18 = check stampBasicArrayToTuple();
    io:println(r18[0]); // @output 1
    io:println(r18[1]); // @output 2
    [int, int] r19 = check stampAnydataBasicArrayToTuple();
    io:println(r19[0]); // @output 1
    io:println(r19[1]); // @output 2
    [anydata, anydata] r20 = check stampBasicArrayToAnydataTuple();
    io:println(r20[0]); // @output 1
    io:println(r20[1]); // @output 2
    int[] r21 = check stampBasicArrayToBasicArray();
    io:println(r21[0]); // @output 1
    io:println(r21[1]); // @output 2

    map<anydata>[] r22 = check stampBasicMapArrayToAnydataMapArray();
    io:println(typeof (r22[0])); // @output typedesc map<anydata>
    io:println(typeof (r22[1])); // @output typedesc map<anydata>

    json[] r23 = check stampRecordArrayToJsonArray();
    json r23First = r23[0];
    json r23Second = r23[1];
    if r23First is map<json> && r23Second is map<json> {
        io:println(typeof r23First); // @output typedesc map<json>
        io:println(typeof r23Second); // @output typedesc map<json>
        io:println(r23First["name"]); // @output Waruna
        io:println(r23Second["name"]); // @output Heshitha
        io:println(r23First["age"]); // @output 10
        io:println(r23Second["age"]); // @output 15
    } else {
        return error("expected map<json> values");
    }
    return;
}
