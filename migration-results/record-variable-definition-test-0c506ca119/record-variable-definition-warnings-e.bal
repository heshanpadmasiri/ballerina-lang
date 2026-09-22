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

function getPersonWithAge() returns PersonWithAge {
    return {name: "Peter", age: {age: 29, format: "Y"}, married: true, "work": "SE"};
}

function getPersonRecord() returns Person {
    return {name: "Jack", married: true};
}

function getAgeRecord() returns Age {
    return {age: 99, format: "MM"};
}

function defineThreeRecordVariablesWarnings() returns [string, int] {
    PersonWithAge p1 = {name: "John", age: {age: 30, format: "YY"}, married: true, "work": "SE"};
    PersonWithAge p2 = {name: "Doe", age: {age: 15, format: "MM"}, married: true, "work": "SE"};
    PersonWithAge p3 = {name: "Peter", age: {age: 5, format: "DD"}, married: true, "work": "SE"};
    PersonWithAge {name: fName1, age: {age: theAge1, format: format1}, married: married1} = p1; // @error
    PersonWithAge {name: fName2, age: {age: theAge2, format: format2}, married: married2} = p2; // @error
    PersonWithAge {name: fName3, age: {age: theAge3, format: format3}, married: married3} = p3; // @error
    return [fName1 + fName2 + fName3 + format1 + format2 + format3, theAge1 + theAge2 + theAge3];
}

function recordVariableWithRHSInvocationWarning() returns string {
    Person {name: fName, married} = getPersonRecord(); // @error
    return fName + " Jill";
}

function nestedRecordVariableWithRHSInvocationWarnings() returns string {
    PersonWithAge person = {name: "Peter", age: getAgeRecord(), married: true, "work": "SE"};
    PersonWithAge {name: fName, age: {age: theAge, format}, married} = person; // @error // @error // @error
    return fName + " Parker";
}

function testRestParameterWarnings() returns map<anydata|error> {
    PersonWithAge p = {name: "John", age: {age: 30, format: "YY"}, married: true, "work": "SE", "other": getAgeRecord()};
    PersonWithAge {name, age: {age, format}, married, ...rest} = p; // @error // @error // @error // @error
    return rest;
}

function testNestedRestParameterWarnings() returns [map<anydata|error>, map<anydata|error>] {
    PersonWithAge p = {name: "John", age: {age: 30, format: "YY", "year": 1990}, married: true, "work": "SE"};
    PersonWithAge {name, age: {age, format, ...rest1}, married, ...rest2} = p; // @error // @error // @error // @error
    return [rest1, rest2];
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

function testRecordInsideTupleInsideRecord2Warnings() returns [string, int, int, string] {
    [int, Age] yearAndAge1 = [1992, {age: 26, format: "Y"}];
    [int, Age] yearAndAge2 = [1994, {age: 24, format: "X"}];
    [int, Age] yearAndAge3 = [1996, {age: 22, format: "Z"}];
    Child ch1 = {name: "A", yearAndAge: yearAndAge1};
    Child ch2 = {name: "B", yearAndAge: yearAndAge2};
    Child ch3 = {name: "C", yearAndAge: yearAndAge3};
    Parent parent = {namesOfChildren: ["A", "B"], children: [ch1, ch2], child: ch3};
    Parent {namesOfChildren, children, child: {name, yearAndAge: [yearInt, {age, format}]}} = parent; // @error // @error
    return [name, yearInt, age, format];
}

function testRecordInsideTupleInsideRecord2WithVarWarnings() returns [string, int, int, string] {
    [int, Age] yearAndAge1 = [1992, {age: 26, format: "Y"}];
    [int, Age] yearAndAge2 = [1994, {age: 24, format: "X"}];
    [int, Age] yearAndAge3 = [1998, {age: 20, format: "A"}];
    Child ch1 = {name: "A", yearAndAge: yearAndAge1};
    Child ch2 = {name: "B", yearAndAge: yearAndAge2};
    Child ch3 = {name: "D", yearAndAge: yearAndAge3};
    Parent parent = {namesOfChildren: ["A", "B"], children: [ch1, ch2], child: ch3};
    var {namesOfChildren, children, child: {name, yearAndAge: [yearInt, {age, format}]}} = parent; // @error // @error
    return [name, yearInt, age, format];
}

type UnionOne record {
    boolean var1;
    int var2;
    float var3 = 0;
};

type UnionTwo record {
    int var1;
    float var2;
};

type UnionThree record {
    int var1;
    float var2;
    UnionOne|UnionTwo var3;
};

function testRecordVarWithUnionTypeWarning() returns [int, float, UnionOne|UnionTwo] {
    UnionOne u1 = {var1: false, var2: 12, "restP1": "stringP1", "restP2": true};
    UnionThree u3 = {var1: 50, var2: 51.1, var3: u1};
    UnionThree {var1, var2, var3, ...rest} = u3; // @error
    return [var1, var2, var3];
}

function testIgnoreVariableWarnings() returns [string, int] {
    PersonWithAge p = {name: "John", age: {age: 30, format: "YY", "year": 1990}, married: true, "work": "SE"};
    PersonWithAge {name, age: {age, format: _, ...rest1}, married: _, ...rest2} = p; // @error // @error
    return [name, age];
}

class Object {
    private int 'field;

    public function init() {
        self.'field = 12;
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

type IntStringMap map<int|string>;
type ObjectMap map<Object>;

function testRestParameterTypeWarnings() returns [boolean, boolean, boolean, boolean, boolean] {
    IntRestRecord rec1 = {name: "A", married: true, "age": 19, "token": 200};
    IntRestRecord {name: name1, ...other1} = rec1; // @error
    var {name: name2, ...other2} = rec1; // @error
    IntRestRecord|ObjectRestRecord rec3 = rec1;
    IntRestRecord|ObjectRestRecord {name: name5, ...other5} = rec3; // @error
    IntStringMap map1 = {name: "A", "age": 19, "token": 200};
    IntStringMap|ObjectMap map2 = map1;
    IntStringMap|ObjectMap {name: name8, ...other9} = map2; // @error
    any a1 = other1;
    any a2 = other2;
    any a5 = other5;
    any a9 = other9;
    return [a1 is record{|never name?; boolean married; int...;|}, a2 is record{|int...;|},
        a5 is record{|never name?; boolean married; int|Object...;|}, a5 is map<anydata>,
        a9 is record {|never name?; (int|string|Object)...;|}];
}

function recordReturningFunc(int num) returns record { string s; int? i; } {
    return {s: "hello", i: 10, "f": num};
}

function testRecordDestructuring1Warnings() {
    var {s: s, i: i, ...rest} = recordReturningFunc(10); // @error // @error
    int num1 = <int>rest.get("f");
    if num1 == 10 {
    }
    {s: s, i: i, ...rest} = recordReturningFunc(20);
    int num2 = <int>rest["f"];
    if num2 == 20 {
    }
}

type Emp record {|
    string name;
    int age;
    string...;
|};

function testRecordDestructuring2Warnings() {
    string stdName; // @error
    int age; // @error
    map<string> details;
    {name: stdName, age, ...details} = <Emp>{name: "Jane Doe", age: 10, "foo": "bar"};
    if details.hasKey("foo") {
    }
}

function testRecordDestructuring3Warning() {
    record {
        int? Id;
        string studentName;
    } {Id, ...studentDetail} = getStudentRecord(1); // @error
    if studentDetail.hasKey("studentName") {
    }
}

function getStudentRecord(int? id) returns record { int? Id; string studentName; } {
    return {Id: id, studentName: "John", "Age": 24, "surName": "Paker"};
}

type SchemaA record {|
    string name;
    int age;
    string...;
|};

type SchemaB record {|
    string name;
    boolean age;
    boolean married;
    int...;
|};

function testRestFieldResolvingWithUnionWarning() {
    SchemaA recA = {name: "David", age: 10, "foo": "bar"};
    SchemaA|SchemaB {name, ...rest} = recA; // @error
    var age = rest.age;
    var fooVal = rest["foo"];
    if age is int && fooVal is string {
    }
}

function testClosedRecordDefinedRestFieldWarnings() {
    string fullName; // @error
    boolean isMarried; // @error
    map<string> rest1; // @error
    map<never> rest2; // @error
    record {|never name?; boolean married; never...;|} rest3;
    Person p = {name: "Jane Doe", married: false};
    {name: fullName, married: isMarried, ...rest1} = p;
    record {|never name?; never married?;|} rec = {};
    rest2 = rec;
    {name: fullName, married: isMarried, ...rest2} = p;
    {name: fullName, ...rest3} = p;
    if rest3.married {
    }
}

type Topt2 record {
    int a;
    record {int b?;}[1] c;
};

type Topt3 record {
    int a;
    record {int b?;}[1] c?;
};

function testOptionalFieldRecordAssignment9Warning() {
    Topt3 topt = {a: 4};
    var {a, c} = topt; // @error
    if c is () {
    }
}

function testRecordDefinitionWithOptionalFields4Warning() {
    int? a = 4; // @error
    int? b = ();
    Topt2 topt = {a: 4, c: [{b}]};
    if topt.c[0].b is () {
    }
}

function testRecordDefinitionWithOptionalFields5Warning() {
    int? a = 4; // @error
    record {int b?;}[1]? c = ();
    Topt3 topt = {a: 4, c};
    if topt.c is () {
    }
}

function testRecordDefinitionWithOptionalFields6Warnings() {
    int? a = 4; // @error
    int? b = 41;
    record {int b?;}[1]? c = (); // @error
    Topt3 topt = {a: 4, c: [{b}]};
    record {int b?;}[] listResult = <record {int b?;}[1]> topt.c;
    if listResult[0].b == 41 {
    }
}
