import ballerina/io;

type Employee record {
    string name;
    string status;
    string batch;
};

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

type StringTeacher [string, Teacher];
type StringEmployee [string, Employee];
type EmployeeArray Employee[];
type IntArray int[];
type AnydataAnydata [anydata, anydata];
type IntInt [int, int];

function runtimeTypeName(anydata value) returns string {
    string typeDescriptor = (typeof value).toString();
    return typeDescriptor.substring(9);
}

function stampTupleValueV1() returns [string, Teacher]|error {
    [string, Teacher] tupleValue = ["Mohan", {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"}];
    [string, Teacher]|error returnValue = tupleValue.cloneWithType(StringTeacher);
    return returnValue;
}

function stampTupleValueV2() returns [string, Employee]|error {
    [string, Teacher] tupleValue = ["Mohan", {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"}];
    [string, Employee]|error returnValue = tupleValue.cloneWithType(StringEmployee);
    return returnValue;
}

function stampTupleToAnydata() returns anydata|error {
    [string, Teacher] tupleValue = ["Mohan", {name: "Raja", age: 25, status: "single", batch: "LK2014", school: "Hindu College"}];
    anydata|error anydataValue = tupleValue.cloneWithType(anydata);
    return anydataValue;
}

function stampTupleValueToArray() returns Employee[]|error {
    [Employee, Person] tupleValue = [{name: "Mohan", status: "single", batch: "LK2015", "school": "Royal College"},
        {name: "Raja", status: "single", batch: "LK2014", school: "Hindu College"}];
    Employee[]|error returnValue = tupleValue.cloneWithType(EmployeeArray);
    return returnValue;
}

function stampTupleToBasicArray() returns int[]|error {
    [int, int] intArray = [1, 2];
    int[]|error returnValue = intArray.cloneWithType(IntArray);
    return returnValue;
}

function stampTupleToAnydataTuple() returns [anydata, anydata]|error {
    [int, int] intArray = [1, 2];
    [anydata, anydata]|error returnValue = intArray.cloneWithType(AnydataAnydata);
    return returnValue;
}

function stampAnydataTupleToBasicTypeTuple() returns [int, int]|error {
    [anydata, anydata] intArray = [1, 2];
    [int, int]|error returnValue = intArray.cloneWithType(IntInt);
    return returnValue;
}

public function main() returns error? {
    [string, Teacher] tupleValueV1 = check stampTupleValueV1();
    io:println(tupleValueV1.length()); // @output 2
    anydata tupleValueV1Element0 = tupleValueV1[0];
    string tupleValueV1String = <string>tupleValueV1Element0;
    io:println(tupleValueV1String); // @output Mohan
    io:println(tupleValueV1Element0 is string); // @output true
    anydata tupleValueV1Element1 = tupleValueV1[1];
    io:println(runtimeTypeName(tupleValueV1Element1)); // @output Teacher
    io:println(tupleValueV1Element1 is record {}); // @output true
    io:println(tupleValueV1Element1 is Teacher); // @output true
    io:println(tupleValueV1[1].length()); // @output 5
    anydata tupleValueV1NameValue = tupleValueV1[1].name;
    string tupleValueV1Name = <string>tupleValueV1NameValue;
    io:println(tupleValueV1Name); // @output Raja
    io:println(tupleValueV1NameValue is string); // @output true
    anydata tupleValueV1AgeValue = tupleValueV1[1].age;
    int tupleValueV1Age = <int>tupleValueV1AgeValue;
    io:println(tupleValueV1Age); // @output 25
    io:println(tupleValueV1AgeValue is int); // @output true
    anydata tupleValueV1StatusValue = tupleValueV1[1].status;
    string tupleValueV1Status = <string>tupleValueV1StatusValue;
    io:println(tupleValueV1Status); // @output single
    io:println(tupleValueV1StatusValue is string); // @output true
    anydata tupleValueV1BatchValue = tupleValueV1[1].batch;
    string tupleValueV1Batch = <string>tupleValueV1BatchValue;
    io:println(tupleValueV1Batch); // @output LK2014
    io:println(tupleValueV1BatchValue is string); // @output true
    anydata tupleValueV1SchoolValue = tupleValueV1[1].school;
    string tupleValueV1School = <string>tupleValueV1SchoolValue;
    io:println(tupleValueV1School); // @output Hindu College
    io:println(tupleValueV1SchoolValue is string); // @output true

    [string, Employee] tupleValueV2 = check stampTupleValueV2();
    io:println(tupleValueV2.length()); // @output 2
    anydata tupleValueV2Element0 = tupleValueV2[0];
    string tupleValueV2String = <string>tupleValueV2Element0;
    io:println(tupleValueV2String); // @output Mohan
    io:println(tupleValueV2Element0 is string); // @output true
    anydata tupleValueV2Element1 = tupleValueV2[1];
    io:println(runtimeTypeName(tupleValueV2Element1)); // @output Employee
    io:println(tupleValueV2Element1 is record {}); // @output true
    io:println(tupleValueV2Element1 is Employee); // @output true
    io:println(tupleValueV2[1].length()); // @output 5
    anydata tupleValueV2NameValue = tupleValueV2[1].name;
    string tupleValueV2Name = <string>tupleValueV2NameValue;
    io:println(tupleValueV2Name); // @output Raja
    io:println(tupleValueV2NameValue is string); // @output true
    anydata tupleValueV2AgeValue = tupleValueV2[1]["age"];
    int tupleValueV2Age = <int>tupleValueV2AgeValue;
    io:println(tupleValueV2Age); // @output 25
    io:println(tupleValueV2AgeValue is int); // @output true
    anydata tupleValueV2StatusValue = tupleValueV2[1].status;
    string tupleValueV2Status = <string>tupleValueV2StatusValue;
    io:println(tupleValueV2Status); // @output single
    io:println(tupleValueV2StatusValue is string); // @output true
    anydata tupleValueV2BatchValue = tupleValueV2[1].batch;
    string tupleValueV2Batch = <string>tupleValueV2BatchValue;
    io:println(tupleValueV2Batch); // @output LK2014
    io:println(tupleValueV2BatchValue is string); // @output true
    anydata tupleValueV2SchoolValue = tupleValueV2[1]["school"];
    string tupleValueV2School = <string>tupleValueV2SchoolValue;
    io:println(tupleValueV2School); // @output Hindu College
    io:println(tupleValueV2SchoolValue is string); // @output true

    anydata tupleValueAnydata = check stampTupleToAnydata();
    if tupleValueAnydata is anydata[] {
        io:println(tupleValueAnydata.length()); // @output 2
        anydata tupleValueAnydataElement0 = tupleValueAnydata[0];
        string tupleValueAnydataString = <string>tupleValueAnydataElement0;
        io:println(tupleValueAnydataString); // @output Mohan
        io:println(tupleValueAnydataElement0 is string); // @output true
        anydata tupleValueAnydataElement1 = tupleValueAnydata[1];
        io:println(runtimeTypeName(tupleValueAnydataElement1)); // @output map<anydata>
        io:println(tupleValueAnydataElement1 is map<any>); // @output true
        io:println(tupleValueAnydataElement1 is map<anydata>); // @output true
    }

    Employee[] employeeArray = check stampTupleValueToArray();
    io:println(employeeArray.length()); // @output 2
    anydata employeeArrayElement0 = employeeArray[0];
    io:println(runtimeTypeName(employeeArrayElement0)); // @output Employee
    io:println(employeeArrayElement0 is record {}); // @output true
    io:println(employeeArrayElement0 is Employee); // @output true
    anydata employeeArrayElement1 = employeeArray[1];
    io:println(runtimeTypeName(employeeArrayElement1)); // @output Employee
    io:println(employeeArrayElement1 is record {}); // @output true
    io:println(employeeArrayElement1 is Employee); // @output true
    io:println(employeeArray[1].length()); // @output 4
    anydata employeeArrayNameValue = employeeArray[1].name;
    string employeeArrayName = <string>employeeArrayNameValue;
    io:println(employeeArrayName); // @output Raja
    io:println(employeeArrayNameValue is string); // @output true
    anydata employeeArrayStatusValue = employeeArray[1].status;
    string employeeArrayStatus = <string>employeeArrayStatusValue;
    io:println(employeeArrayStatus); // @output single
    io:println(employeeArrayStatusValue is string); // @output true
    anydata employeeArrayBatchValue = employeeArray[1].batch;
    string employeeArrayBatch = <string>employeeArrayBatchValue;
    io:println(employeeArrayBatch); // @output LK2014
    io:println(employeeArrayBatchValue is string); // @output true
    anydata employeeArraySchoolValue = employeeArray[1]["school"];
    string employeeArraySchool = <string>employeeArraySchoolValue;
    io:println(employeeArraySchool); // @output Hindu College
    io:println(employeeArraySchoolValue is string); // @output true

    int[] basicArray = check stampTupleToBasicArray();
    io:println(basicArray[0]); // @output 1
    io:println(basicArray[1]); // @output 2

    [anydata, anydata] anydataTuple = check stampTupleToAnydataTuple();
    io:println(anydataTuple[0]); // @output 1
    io:println(anydataTuple[1]); // @output 2

    [int, int] intTuple = check stampAnydataTupleToBasicTypeTuple();
    io:println(intTuple[0]); // @output 1
    io:println(intTuple[1]); // @output 2
}
