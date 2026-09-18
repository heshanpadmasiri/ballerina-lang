import ballerina/io;

Person {name: Fname, married: Married} = {name: "Jhone", married: true};

public function testBasic() {
    io:println(Fname); // @output Jhone
    io:println(Married); // @output true
}

PersonWithAge {name: fName1, age: {age: theAge1, format: format1}, married} = getPersonWithAge();

function recordVarInRecordVar() {
    io:println(fName1); // @output Peter
    io:println(theAge1); // @output 29
    io:println(format1); // @output Y
    io:println(married); // @output true
}

function getPersonWithAge() returns PersonWithAge {
    return {name: "Peter", age: {age: 29, format: "Y"}, married: true, "work": "SE"};
}

PersonWithAge2 {name: fName2, age: [age2, format2], married: married2} = getPersonWithAge2();

function tupleVarInRecordVar() {
    io:println(fName2); // @output Mac
    io:println(age2); // @output 21
    io:println(format2); // @output Y
    io:println(married2); // @output false
}

function getPersonWithAge2() returns PersonWithAge2 {
    return {name: "Mac", age: [21, "Y"], married: false};
}

const annotation annot on source var;

@annot
Age {age, format} = {age: 24, format: "myFormat"};

public function testRecordVarWithAnnotations() {
    io:println(age); // @output 24
    io:println(format); // @output myFormat
}

Person {name: name3, married: married3} = {name: name4, married: married4};
Person {name: name4, married: married4} = {name: "Nicolette", married: false};

public function testVariableForwardReferencing() {
    io:println(name3); // @output Nicolette
    io:println(married3); // @output false
}

var {name: name5, married: married5} = {name: "Allen", married: false};

public function testVariableDeclaredWithVar() {
    io:println(name5); // @output Allen
    io:println(married5); // @output false
}

var {fieldA: [fieldAVar], fieldB: {a: fieldBMapVar}, fieldC: error(message), ...restInt} = foo();

type ComplexRecord record {|
    [int] fieldA;
    record {string a;} fieldB;
    error fieldC;
    int...;
|};

function foo() returns ComplexRecord =>
    {fieldA: [8], fieldB: {a: "Ballerina"}, fieldC: error("NullPointer"), "int1": 1, "int2": 2};

function testVariableDeclaredWithVar2() {
    io:println(fieldAVar); // @output 8
    io:println(fieldBMapVar); // @output Ballerina
    io:println(message); // @output NullPointer
    io:println(restInt["int1"]); // @output 1
    io:println(restInt["int2"]); // @output 2
}

Student {name: studentName, age: studentAge, grade: studentGrade, ...marks} = getStudentDetails();
var {name: studentName2, age: studentAge2, grade: studentGrade2, ...marks2} = getStudentDetails2();
Employee {name: eName1, id: eId1} = getEmployee1();
var {name: eName2, id: eId2} = getEmployee2();

function getStudentDetails() returns Student {
    return {name: "Flash", age: 15, format: "Y", grade: 10, "mark1": 50, "mark2": 85, "mark3": 90};
}

function getStudentDetails2() returns Student {
    return {name: "Arrow", age: 25, format: "Y", grade: 20, "mark1": 60, "mark2": 95, "mark3": 95};
}

function getEmployee1() returns Employee {
    return {name: "Jo", id: 1234};
}

function getEmployee2() returns Employee {
    return {name: "Ray", id: 4321};
}

public function testRecordVariableWithRestBP() {
    io:println(studentName); // @output Flash
    io:println(studentAge); // @output 15
    io:println(studentGrade); // @output 10
    io:println(marks["mark1"]); // @output 50
    io:println(marks["mark2"]); // @output 85
    io:println(marks["mark3"]); // @output 90
    io:println(studentName2); // @output Arrow
    io:println(studentAge2); // @output 25
    io:println(studentGrade2); // @output 20
    io:println(marks2["mark1"]); // @output 60
    io:println(marks2["mark2"]); // @output 95
    io:println(marks2["mark3"]); // @output 95
    io:println(eName1); // @output Jo
    io:println(eName2); // @output Ray
    io:println(eId1); // @output 1234
    io:println(eId2); // @output 4321
}

annotation record {int i;} x on function;

record {int i;}? annotationValue = ();
int annotationInvocationCount = 0;

@x {i: studentAge}
public function testVariableDeclaredInRecordAsAnnotationValue() {
    typedesc<function ()> td = typeof testVariableDeclaredInRecordAsAnnotationValue;
    record {int i;}? xVal = td.@x;
    annotationValue = xVal;
    annotationInvocationCount += 1;
    if annotationInvocationCount == 1 {
        io:println(annotationValue); // @output {"i":15}
    } else {
        io:println(annotationValue); // @output {"i":15}
    }
}

type Age record {
    int age;
    string format;
};

type Person record {|
    string name;
    boolean married;
|};

type PersonWithAge record {
    string name;
    Age age;
    boolean married;
};

type PersonWithAge2 record {
    string name;
    [int, string] age;
    boolean married;
};

type Student record {|
    string name;
    int grade;
    *Age;
    int...;
|};

type Employee record {
    string name;
    int id;
    Employee lead?;
};

type Topt record {
    int x?;
    int y?;
};

Topt topt1 = {x: 2, y: 4};
var {x, y} = topt1;
Topt topt2 = {x: 2};
var {x: x1, y: y1} = topt2;
int? x2 = ();
int? y2 = 5;
Topt topt3 = {x: x2, y: y2};

function testOptionalFieldAssignment() {
    io:println(x); // @output 2
    io:println(y); // @output 4
    io:println(x1); // @output 2
    io:println(y1 is ()); // @output true
    io:println(topt3.x is ()); // @output true
    io:println(topt3.y); // @output 5
}

public function main() {
    testBasic();
    recordVarInRecordVar();
    tupleVarInRecordVar();
    testRecordVarWithAnnotations();
    testVariableForwardReferencing();
    testVariableDeclaredWithVar();
    testVariableDeclaredWithVar2();
    testRecordVariableWithRestBP();
    testVariableDeclaredInRecordAsAnnotationValue();
    testVariableDeclaredInRecordAsAnnotationValue();
    testOptionalFieldAssignment();
}
