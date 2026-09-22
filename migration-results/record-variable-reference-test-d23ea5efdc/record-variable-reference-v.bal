// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

type Age record {
    int age;
    string format;
};

type Person record {|
    string name;
    boolean married;
    Age age;
    [string, int] extra;
|};

function testVariableAssignment() returns [string, boolean, int, string] {
    string fName;
    boolean married;
    int theAge;
    string format;
    map<any|error> theMap;

    {name: fName, married, age: {age: theAge, format}, ...theMap} = getPerson();
    return [fName, married, theAge, format];
}

function getPerson() returns Person {
    return {name: "Peter", married: true, age: {age: 12, format: "Y"}, extra: ["ds", 4]};
}

type Foo record {
    map<int> var1;
    Bar var2;
};

type Bar record {
    int|float var1;
    Some var2;
};

type Some record {
    string var1;
    string? var2;
};

function testRecVarRefInsideRecVarRefInsideRecVarRef() returns [map<int>, int|float, string, string?] {
    map<int> fooVar1;
    int|float barVar1;
    string someVar1;
    string? someVar2;

    {var1: fooVar1, var2: {var1: barVar1, var2: {var1: someVar1, var2: someVar2}}} = getFoo();
    return [fooVar1, barVar1, someVar1, someVar2];
}

function getFoo() returns Foo {
    return {var1: {"mKey1": 1, "mKey2": 2}, var2: {var1: 12, var2: {var1: "SomeVar1", var2: ()}}};
}

type OpenRecord record {
    string var1;
    boolean var2;
};

function testRestParam() returns map<anydata|error> {
    OpenRecord openRecord = {var1: "var1", var2: false, "var3": 12, "var4": "text"};
    string var1;
    boolean var2;
    map<anydata|error> rest = {};
    {var1, var2, ...rest} = openRecord;
    return rest;
}

function testRecordTypeInRecordVarRef() returns [map<any>, int|float, Some] {
    map<int> fooVar1;
    int|float barVar1;
    Some var2;

    {var1: fooVar1, var2: {var1: barVar1, var2}} = getFoo();
    return [fooVar1, barVar1, var2];
}

type Student record {
    string name;
    [int, int, int] dob;
    byte gender;
};

function testTupleVarRefInRecordVarRef() returns [string, [int, int, int], byte, string, int, int, int] {
    Student st1 = {name: "Mark", dob: [1, 1, 1990], gender: 1};
    string name;
    [int, int, int] dob;
    byte gender;
    string sName;
    int a;
    int b;
    int c;

    {name, dob, gender} = st1;
    {name: sName, dob: [a, b, c]} = st1;
    return [name, dob, gender, sName, a, b, c];
}

type Parent record {
    string[] namesOfChildren;
    Child[] children;
    Child child;
};

type Child record {
    string name;
    [int, Age] yearAndAge;
};

function testRecordInsideTupleInsideRecord() returns [string[], string, map<anydata|error>] {
    [int, Age] yearAndAge1 = [1992, {age: 26, format: "Y"}];
    [int, Age] yearAndAge2 = [1994, {age: 24, format: "x"}];
    [int, Age] yearAndAge3 = [1996, {age: 22, format: "Z"}];
    Child ch1 = {name: "A", yearAndAge: yearAndAge1};
    Child ch2 = {name: "B", yearAndAge: yearAndAge2};
    Child ch3 = {name: "C", yearAndAge: yearAndAge3};

    string[] namesOfChildren;
    Child[] children;
    map<anydata|error> child = {};

    Parent parent = {namesOfChildren: ["A", "B"], children: [ch1, ch2], child: ch3};
    {namesOfChildren, children, ...child} = parent;
    return [namesOfChildren, children[0].name, child];
}

function testRecordInsideTupleInsideRecord2() returns [string, int, int, string] {
    [int, Age] yearAndAge1 = [1992, {age: 26, format: "Y"}];
    [int, Age] yearAndAge2 = [1994, {age: 24, format: "x"}];
    [int, Age] yearAndAge3 = [1996, {age: 22, format: "Z"}];
    Child ch1 = {name: "A", yearAndAge: yearAndAge1};
    Child ch2 = {name: "B", yearAndAge: yearAndAge2};
    Child ch3 = {name: "C", yearAndAge: yearAndAge3};

    string[] namesOfChildren;
    Child[] children;
    string name;
    int yearInt;
    int age;
    string format;

    Parent parent = {namesOfChildren: ["A", "B"], children: [ch1, ch2], child: ch3};
    {namesOfChildren, children, child: {name, yearAndAge: [yearInt, {age, format}]}} = parent;
    return [name, yearInt, age, format];
}

class Object {
    private int 'field;

    public function init() {
        self.'field = 12;
    }

    public function getField() returns int {
        return self.'field;
    }
}

type IntRestRecord record {|
    string name;
    boolean married;
    int...;
|};

type ObjectRestRecord record {|
    string name;
    boolean married;
    Object...;
|};

function testRestParameterType() returns boolean {
    string name;
    map<anydata|error> other1 = {};
    map<any> other2 = {};

    IntRestRecord rec1 = {name: "A", married: true, "age": 19, "token": 200};
    {name, ...other1} = rec1;

    any a1 = other1;

    return a1 is map<anydata|error>;
}

function testVarAssignmentOfRecordLiteral1() {
    string fName;
    boolean married;
    int theAge;
    string format;

    {
        name: fName,
        age: {
            age: theAge,
            format
        },
        married
    } = {
        name: "Peter",
        married: true,
        age: {age: 12, format: "Y"}
    };

    assertEquality("Peter", fName);
    assertEquality(true, married);
    assertEquality(12, theAge);
    assertEquality("Y", format);
}

function testVarAssignmentOfRecordLiteral2() {
    string fName;
    boolean married;
    Age age;
    map<anydata> theMap;

    {
        name: fName,
        age,
        married,
        ...theMap
    } = {
        name: "Peter",
        married: true,
        age: {age: 12, format: "Y"}
    };
    assertEquality("Peter", fName);
    assertEquality(true, married);
    assertEquality(12, age.age);
    assertEquality("Y", age.format);
    assertEquality({}, theMap);
}

function testVarAssignmentOfRecordLiteral3() {
    string fName;
    boolean married;
    map<string|int> age;
    map<anydata> theMap;

    {
        name: fName,
        age,
        married,
        ...theMap
    } = {
        name: "Peter",
        married: true,
        age: {age: 12, format: "Y"}
    };
    assertEquality("Peter", fName);
    assertEquality(true, married);
    assertEquality({age: 12, format: "Y"}, age);
    assertEquality({}, theMap);
}

function testVarAssignmentOfRecordLiteral4() {
    string fName;
    boolean married;
    json age;
    map<any|error> theMap;

    {
        name: fName,
        age,
        ...theMap
    } = {
        name: "Peter",
        married: true,
        age: {age: 12, format: "Y"}
    };
    assertEquality("Peter", fName);
    assertEquality({age: 12, format: "Y"}, age);
    assertEquality({married: true}, theMap);
}

function testVarAssignmentOfRecordLiteral5() {
    string fName;
    map<anydata> theMap;

    {
        name: fName,
        ...theMap
    } = {
        name: "Peter",
        married: true,
        age: {age: 12, format: "Y"},
        city: "New York",
        state: "New"
    };
    assertEquality("Peter", fName);
    assertEquality({
                       married: true,
                       age: {age: 12, format: "Y"},
                       city: "New York",
                       state: "New"
                   }, theMap);
}

function testVarAssignmentOfRecordLiteral6() {
    int departmentId;
    string departmentName;
    int floorId;

    {
        department: {
            id: departmentId,
            name: departmentName,
            location: {floorId}
        }
    } = {
        name: "John Doe",
        department: {
            id: 123,
            name: "Marketing",
            location: {floorId: 2, area: "B"}
        }
    };
    assertEquality(123, departmentId);
    assertEquality("Marketing", departmentName);
    assertEquality(2, floorId);
}

function testVarAssignmentOfRecordLiteral7() {
    int empId;
    map<anydata> otherEmpDetails;
    map<anydata> otherDepDetails;

    {id: empId, department: {...otherDepDetails}, ...otherEmpDetails} = {
        id: 1,
        name: "John Doe",
        age: 30,
        department: {
            id: 123,
            name: "Marketing",
            location: {floor: 2, area: "B"}
        }
    };
    assertEquality(1, empId);
    assertEquality({
                       id: 123,
                       name: "Marketing",
                       location: {floor: 2, area: "B"}
                   }, otherDepDetails);
    assertEquality({
                       name: "John Doe",
                       age: 30
                   }, otherEmpDetails);
}

function testVarAssignmentOfRecordLiteral8() {
    int id;
    string name;
    map<anydata> otherDetails;

    {id, name, ...otherDetails} = {
        id: 1,
        name: "John Doe",
        age: 30,
        ...{
            department: {
                id: 123,
                name: "Marketing",
                location: {floor: 2, area: "B"}
            }
        }
    };
    assertEquality(1, id);
    assertEquality("John Doe", name);
    assertEquality({
                       age: 30,
                       department: {
                           id: 123,
                           name: "Marketing",
                           location: {floor: 2, area: "B"}
                       }
                   }, otherDetails);
}

type EmployeeDetails record {|
    string emp\:name;
    int id;
|};

type ProductDetails record {|
    string x\:code = "default";
    int quantity;
|};

function testRecordFieldBindingPatternsWithIdentifierEscapes() {
    EmployeeDetails empDetails = {
        emp\:name: "Joy",
        id: 12
    };
    string emp\:name;
    int id;
    {emp\:name, id} = empDetails;
    assertEquality("Joy", emp\:name);
    assertEquality(12, id);

    ProductDetails prodDetails = {quantity: 1234};
    ProductDetails {x\:code, quantity} = prodDetails;
    prodDetails = {x\:code: "featured", quantity: 12345};
    {x\:code, quantity} = prodDetails;
    assertEquality("featured", x\:code);
    assertEquality(12345, quantity);

    [EmployeeDetails, ProductDetails] details = [{id: 234, emp\:name: "Amy"}, {x\:code: "basic", quantity: 324}];
    string a;
    int b;
    int c;
    string d;
    [{emp\:name: a, id: b}, {quantity: c, x\:code: d}] = details;
    assertEquality("Amy", a);
    assertEquality(234, b);
    assertEquality(324, c);
    assertEquality("basic", d);
}

type ReadOnlyRecord readonly & record {|
    int[] x;
    string y;
|};

function testReadOnlyRecordWithMappingBindingPatternInDestructuringAssignment() {
    ReadOnlyRecord f1 = {x: [1, 2], y: "s1"};
    int[] & readonly x;
    string y;

    {x, y} = f1;
    assertEquality(<int[]>[1, 2], x);
    assertEquality("s1", y);

    readonly & record {
        int[] a;
        ReadOnlyRecord b;
    } r = {a: [12, 34, 56], b: f1};
    int[] & readonly a;
    int[] & readonly x2;
    string y2;
    {a, b: {x: x2, y: y2}} = r;
    assertEquality(<int[]>[12, 34, 56], a);
    assertEquality(<int[]>[1, 2], x2);
    assertEquality("s1", y2);

    int[] c;
    int[] d;
    {a: c, b: {x: d, y: y2}} = r;
    assertEquality(<int[]>[12, 34, 56], c);
    assertEquality(<int[]>[1, 2], d);
    assertEquality("s1", y2);
}

type ClosedRec record {|
    string a;
    string b;
|};

type OpenRec record {
    string a;
    string b;
};

function testMappingBindingWithSingleNameFieldBinding() {
    record {|
        string a;
        string b;
    |} x = {a: "foo", b: "bar"};

    string a;
    string b;

    {a} = x;
    assertEquality("foo", a);

    {b} = x;
    assertEquality("bar", b);

    ClosedRec y = {a: "foo2", b: "bar2"};

    {a} = y;
    assertEquality("foo2", a);

    {b} = y;
    assertEquality("bar2", b);

    record {
        string a;
        string b;
    } v = {a: "foo3", b: "bar3"};

    {a} = v;
    assertEquality("foo3", a);

    {b} = v;
    assertEquality("bar3", b);

    OpenRec w = {a: "foo4", b: "bar4"};

    {a} = w;
    assertEquality("foo4", a);

    {b} = w;
    assertEquality("bar4", b);
}

function testMappingBindingPatternAgainstOpenRecordInTupleDestructuring() {
    [Some, Some] r1 = [{var1: "A", var2: "B"}, {var1: "C", var2: "D"}];
    string xVar1;
    string xVar11;
    [{var1: xVar1}, {var1: xVar11}] = r1;
    assertEquality("A", xVar1);
    assertEquality("C", xVar11);

    [record {int a; int b;}] r2 = [{a: 1, b: 2, "c": "three", "d": 0.003}];
    int a;
    int b;
    [{a, b}] = r2;
    assertEquality(1, a);
    assertEquality(2, b);

    [record {|int a; int b;|}] r3 = [{a: 3, b: 4}];
    [{a, b}] = [...r3];
    assertEquality(3, a);
    assertEquality(4, b);

    record {|int b; string c;|} rec1 = {b: 2, c: "C"};
    string c;
    [{a, b, c}] = [{a: 1, ...rec1}];
    assertEquality(1, a);
    assertEquality(2, b);
    assertEquality("C", c);

    [record {int a; int b; stream<int> c;}] r4 = [{a: 5, b: 6, c: new}];
    [{a, b}] = r4;
    assertEquality(5, a);
    assertEquality(6, b);

    string fname;
    string lname;
    string id;
    int age;
    string nextId;
    [record {string id; string fname; string lname;}, record {|string id; int age;|}] r5
                                    = [{id: "u1001", fname: "John", lname: "doe"}, {id: "u1002", age: 10}];
    [{id, fname, lname}, {id: nextId, age}] = r5;
    assertEquality("u1001", id);
    assertEquality("John", fname);
    assertEquality("doe", lname);
    assertEquality("u1002", nextId);
    assertEquality(10, age);

    int p1;
    int p2;
    int p3;
    int p4;
    int p5;
    [[record {int p1; int p2;}], [[record {int p3; int p4;}], record {int p5;}]] r6
                                    = [[{p1: 10, p2: 12}], [[{p3: 13, p4: 14}], {p5: 15}]];
    [[{p1, p2}], [[{p3, p4}], {p5}]] = r6;
    assertEquality(10, p1);
    assertEquality(12, p2);
    assertEquality(13, p3);
    assertEquality(14, p4);
    assertEquality(15, p5);

    [record {|int a; int b; anydata...;|}] r7 = [{a: 1, b: 2}];
    [{a, b}] = r7;
    assertEquality(1, a);
    assertEquality(2, b);

    [record {|int a; int b; anydata...;|}] r8 = [{a: 10, b: 12}];
    [{a, b}] = [...r8];
    assertEquality(10, a);
    assertEquality(12, b);

    int x1;
    int x2;
    var getMap = function() returns record {record {int x1; int x2;} x3;} => {x3: {x1: 2, x2: 3}};
    {x3: {x1, x2}} = getMap();
    assertEquality(2, x1);
    assertEquality(3, x2);
    assertEquality({x1: 2, x2: 3}, {x1, x2});

    // TODO: Uncomment after fixing #40312
    // int d;
    // error<record { record { int d; } x; }> err = error("Transaction Failure", x = {d: 0});

    // error(x = {d}) = err;
}

function assertEquality(anydata expected, any actual) {
    if expected == actual {
        return;
    }

    panic error("expected '" + expected.toBalString() + "', found '" + actual.toBalString() + "'");
}

public function main() {
    var variableAssignment = testVariableAssignment();
    io:println(variableAssignment.length()); // @output 4
    io:println(variableAssignment[0]); // @output Peter
    io:println(variableAssignment[1]); // @output true
    io:println(variableAssignment[2]); // @output 12
    io:println(variableAssignment[3]); // @output Y

    var nestedRecord = testRecVarRefInsideRecVarRefInsideRecVarRef();
    io:println(nestedRecord.length()); // @output 4
    io:println(nestedRecord[0]["mKey1"]); // @output 1
    io:println(nestedRecord[0]["mKey2"]); // @output 2
    io:println(nestedRecord[1]); // @output 12
    io:println(nestedRecord[2]); // @output SomeVar1
    io:println(nestedRecord[3].toBalString()); // @output ()

    var rest = testRestParam();
    io:println(rest["var3"]); // @output 12
    io:println(rest["var4"]); // @output text

    var recordType = testRecordTypeInRecordVarRef();
    io:println(recordType.length()); // @output 3
    io:println(recordType[0]["mKey1"]); // @output 1
    io:println(recordType[0]["mKey2"]); // @output 2
    io:println(recordType[1]); // @output 12
    io:println(recordType[2].var1); // @output SomeVar1
    io:println(recordType[2].var2.toBalString()); // @output ()

    var tupleInRecord = testTupleVarRefInRecordVarRef();
    io:println(tupleInRecord.length()); // @output 7
    io:println(tupleInRecord[0]); // @output Mark
    io:println(tupleInRecord[1][0]); // @output 1
    io:println(tupleInRecord[1][1]); // @output 1
    io:println(tupleInRecord[1][2]); // @output 1990
    io:println(tupleInRecord[2]); // @output 1
    io:println(tupleInRecord[3]); // @output Mark
    io:println(tupleInRecord[4]); // @output 1
    io:println(tupleInRecord[5]); // @output 1
    io:println(tupleInRecord[6]); // @output 1990

    var recordInTuple = testRecordInsideTupleInsideRecord();
    io:println(recordInTuple.length()); // @output 3
    io:println(recordInTuple[0][0]); // @output A
    io:println(recordInTuple[0][1]); // @output B
    io:println(recordInTuple[1]); // @output A
    anydata childValue = checkpanic recordInTuple[2]["child"];
    map<anydata|error> child = <map<anydata|error>> childValue;
    io:println(child["name"]); // @output C
    anydata yearAndAgeValue = checkpanic child["yearAndAge"];
    [int, map<anydata|error>] yearAndAge = <[int, map<anydata|error>]> yearAndAgeValue;
    io:println(yearAndAge[0]); // @output 1996
    io:println(yearAndAge[1]["format"]); // @output Z

    var recordInTuple2 = testRecordInsideTupleInsideRecord2();
    io:println(recordInTuple2.length()); // @output 4
    io:println(recordInTuple2[0]); // @output C
    io:println(recordInTuple2[1]); // @output 1996
    io:println(recordInTuple2[2]); // @output 22
    io:println(recordInTuple2[3]); // @output Z

    io:println(testRestParameterType()); // @output true

    testVarAssignmentOfRecordLiteral1();
    testVarAssignmentOfRecordLiteral2();
    testVarAssignmentOfRecordLiteral3();
    testVarAssignmentOfRecordLiteral4();
    testVarAssignmentOfRecordLiteral5();
    testVarAssignmentOfRecordLiteral6();
    testVarAssignmentOfRecordLiteral7();
    testVarAssignmentOfRecordLiteral8();
    testRecordFieldBindingPatternsWithIdentifierEscapes();
    testReadOnlyRecordWithMappingBindingPatternInDestructuringAssignment();
    testMappingBindingWithSingleNameFieldBinding();
    testMappingBindingPatternAgainstOpenRecordInTupleDestructuring();
}
