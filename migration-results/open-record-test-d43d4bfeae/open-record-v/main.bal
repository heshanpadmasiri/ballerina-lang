import ballerina/io;

type Department record {
    string dptName = "";
    Person[] employees = [];
};

type Person record {|
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    Family family = {};
    Person? parent = ();
    anydata|error...;
|};

type Family record {
    string spouse = "";
    int noOfChildren = 0;
    string[] children = [];
};

function testStructOfStruct() returns string {
    map<any> address = {"country": "USA", "state": "CA"};
    Person emp1 = {name: "Jack", adrs: address, age: 25};
    Person emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    return <string>dpt.employees[0].adrs["country"];
}

function testReturnStructAttributes() returns string {
    map<any> address = {"country": "USA", "state": "CA"};
    Family fmly = {children: []};
    Person emp1 = {name: "Jack", adrs: address, age: 25, family: fmly};
    Person emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    dpt.employees[0].family.children[0] = "emily";
    return dpt.employees[0].family.children[0];
}

function testExpressionAsIndex() returns string {
    Family family = {spouse: "Kate", children: ["Emma", "Rose", "Jane"]};
    int a = 2;
    int b = 5;
    return family.children[a * b - 8];
}

function testStructExpressionAsIndex() returns string {
    Department dpt = {};
    Family fmly = {children: []};
    Person emp2 = {};
    map<any> address = {"country": "USA", "state": "CA"};
    Person emp1 = {name: "Jack", adrs: address, age: 25, family: fmly};
    emp1.adrs["street"] = "20";
    emp1.age = 0;
    dpt.employees = [emp1, emp2];
    dpt.employees[0].family.children[0] = "emily";
    dpt.employees[0].family.noOfChildren = 1;
    return dpt.employees[0].family.children[dpt.employees[0].family.noOfChildren - 1];
}

type Mat record { int x = fn(); };
type Bar2 record { int x = xFn(); int y = yFn(); };

isolated int gVal = 100;

isolated function fn() returns int {
    lock { gVal = 15; }
    return 10;
}

isolated function getValue() returns int {
    lock { return gVal; }
}

isolated function xFn() returns int => 101;
isolated function yFn() returns int => 102;

record {int a; int b = xFn();} gVal2 = {a: 10};
record {int a; int b = xFn();} gVal3 = {a: 10, b: 25};
type Bal record { string[] x = ["foo", "bar"]; };
Bal gVal4 = {readonly x: ["bal"]};

function testDefaultVal() {
    Person p = {};
    Mat m = {x: 90};
    Mat m2 = {x: 1};
    record { record { int c = 10; } b = {}; } a = {b: {}};
    assert("default first name", p.name);
    assert("", p.lname);
    assert(999, p.age);
    assert(90, m.x);
    assert(100, getValue());
    assert(1, m2.x);
    assert(10, a.b.c);
    Mat m3 = {};
    assert(10, m3.x);
    assert(15, getValue());
    record {|int a = 10;|} l;
    function() returns record {|int a = 10;|} f = function() returns record {|int a = 10;|} {
        l = {};
        assert(10, l.a);
        l = {a: 25};
        assert(25, l.a);
        return l;
    };
    l = f();
    assert(25, l.a);
    assert(10, gVal2.a);
    assert(101, gVal2.b);
    assert(10, gVal3.a);
    assert(25, gVal3.b);
    assert("bal", gVal4.x[0]);
    record {string[] x = ["foo", "bar"];} n = {readonly x: ["bal"]};
    assert("bal", n.x[0]);
    function() returns record {|int x = 2;|} localFn = function() returns record {|int x = 2;|} { return {}; };
    assert(2, localFn().x);
    var localFn1 = function() returns record {|int x = 2;|} { return {}; };
    assert(2, localFn1().x);
}

function testNestedFieldDefaultVal() returns [string, string, int] {
    Department dpt = {};
    dpt.employees = [];
    dpt.employees[0] = {lname: "Smith"};
    return [dpt.employees[0].name, dpt.employees[0].lname, dpt.employees[0].age];
}

function testNestedStructInit() returns Person => {name: "aaa", age: 25, parent: {name: "bbb", age: 50}};

type NegativeValTest record {
    int negativeInt = -9;
    int negativeSpaceInt = -8;
    float negativeFloat = -88.234;
    float negativeSpaceFloat = -24.99;
};

function getStructNegativeValues() returns [int, int, float, float] {
    NegativeValTest tmp = {};
    return [tmp.negativeInt, tmp.negativeSpaceInt, tmp.negativeFloat, tmp.negativeSpaceFloat];
}

function getStruct() returns Person => {name: "aaa", age: 25, parent: {name: "bbb", lname: "ccc", age: 50}};

function testAdditionOfARestField() returns Person {
    Person p = {name: "Foo", "mname": "Bar", age: 25, "height": 5.9};
    p["firstName"] = "John";
    return p;
}

function testAnydataOrErrorRestFieldRHSIndexAccess() returns anydata|error {
    Person p = {};
    return p["firstName"];
}

type Person2 record {| string name = ""; int age = 0; string...; |};
function testStringRestField() returns Person2 => {name: "Foo", age: 25, "lname": "Bar", "address": "Colombo"};
function testStringRestFieldRHSIndexAccess() returns [string?, string?] {
    Person2 p = {};
    return [p["name"], p["firstName"]];
}

type Person3 record {| string name = ""; int age = 0; int...; |};
function testIntRestField() returns Person3 => {name: "Foo", age: 25, "year": 3};
function testIntRestFieldRHSIndexAccess() returns [int?, int?] {
    Person3 p = {};
    return [p["age"], p["birthYear"]];
}

type Person4 record {| string name = ""; int age = 0; float...; |};
function testFloatRestField() returns Person4 => {name: "Foo", age: 25, "height": 5.9};
function testFloatRestFieldRHSIndexAccess() returns [float?, float?] {
    Person4 p = {"weight": 61.5};
    return [p["weight"], p["height"]];
}

type Person5 record {| string name = ""; int age = 0; boolean...; |};
function testBooleanRestField() returns Person5 => {name: "Foo", age: 25, "isEmployed": true};
function testBooleanRestFieldRHSIndexAccess() returns [boolean?, boolean?] {
    Person5 p = {"isStudent": true};
    return [p["isStudent"], p["isEmployed"]];
}

type Person6 record {| string name = ""; int age = 0; map<any>...; |};
function testMapRestField() returns Person6 => {name: "Foo", age: 25, "misc": {lname: "Bar", height: 5.9, isEmployed: true}};
function testMapRestFieldRHSIndexAccess() returns [map<any>?, map<any>?] {
    Person6 p = {"misc": {}};
    return [p["misc"], p["invMap"]];
}

type Person7 record {| string name = ""; int age = 0; (float|string|boolean)...; |};
function testUnionRestField() returns Person7 => {name: "Foo", age: 25, "lname": "Bar", "height": 5.9, "isEmployed": true};
function testUnionRestFieldRHSIndexAccess() returns [(float|string|boolean)?, (float|string|boolean)?] {
    Person7 p = {"miscField": "Foo"};
    return [p["miscField"], p["invField"]];
}

type Person8 record {| string name = ""; int age = 0; ()...; |};
function testNilRestField() returns Person8 => {name: "Foo", age: 25, "lname": ()};

type Person9 record {| string name = ""; int age = 0; Department...; |};
function testRecordRestField() returns Person9 => {name: "Foo", age: 25, "dpt": {dptName: "Engineering", employees: []}};
function testRecordRestFieldRHSIndexAccess() returns [Department?, Department?] {
    Person9 p = {"dept": {}};
    return [p["dept"], p["department"]];
}

class Animal {
    public string kind = "";
    public string name = "";
    function init(string name, string kind) { self.name = name; self.kind = kind; }
}

type Person10 record {| string name = ""; int age = 0; Animal...; |};
function testObjectRestField() returns Person10 => {name: "Foo", age: 25, "pet": new Animal("Miaw", "Cat")};
function testObjectRestFieldRHSIndexAccess() returns [Animal?, Animal?] {
    Animal anim = new ("Rocky", "Dog");
    Person10 p = {"pet": anim};
    return [p["pet"], p["invPet"]];
}

type Person11 record {| string name = ""; int age = 0; [float, string, Animal]...; |};
function testTupleRestField() returns Person11 => {name: "Foo", age: 25, "misc": [5.9, "Bar", new Animal("Miaw", "Cat")]};
function testTupleRestFieldRHSIndexAccess() returns [[float, string, Animal]?, [float, string, Animal]?] {
    Person11 p = {"tup": [4.5, "foo", new Animal("Miaw", "Cat")]};
    return [p["tup"], p["invTup"]];
}

type Person12 record {| string name = ""; int age = 0; any...; |};
function testAnyRestField() returns Person12 {
    Animal?[] pets = [new Animal("Miaw", "Cat"), new Animal("Woof", "Dog")];
    return {name: "Foo", age: 25, "pets": pets};
}
function testAnyRestFieldRHSIndexAccess() returns [any, any] {
    Animal?[] pets = [new Animal("Miaw", "Cat"), new Animal("Woof", "Dog")];
    Person12 p = {"pets": pets};
    return [p["pets"], p["anyField"]];
}

type PersonA record { string fname = ""; string lname = ""; function() returns string fullName?; };
function testFuncPtrAsRecordField() returns string {
    PersonA p = {fname: "John", lname: "Doe"};
    p.fullName = function() returns string => p.lname + ", " + p.fname;
    function() returns string fp = <function() returns string>p["fullName"];
    return fp();
}

type Address record { string city; string country; };
type PersonRec record { string name = "John Doe"; int age = 25; Address adr = {city: "Colombo", country: "Sri Lanka"}; };
type EmployeeRec record { *PersonRec; string company = "WSO2"; };
type ManagerRec record { string dept = ""; *EmployeeRec; };
function testDefaultValueInit() returns ManagerRec => {};

public type Foo record { int a = getAsInt("777"); };
isolated function getAsInt(string s) returns int => 777;
public type Bar record { *Foo; int b = 56; };
public function testRecordInitWithFuncCalls() returns Bar => {};

type Qux record { string bar; int baz; };
function testLiteralsAsMappingConstructorKeys() returns boolean {
    Qux f = {"bar": "hello", baz: 1};
    return f.bar == "hello" && f.baz == 1;
}
type Baz record { string s; int i?; float? f = (); };
string iValue = "i";
function testExpressionAsKeys() returns boolean {
    Baz b = {s: "hello", [iValue]: 1, [getChar("f")]: 2.0, [getChar("b")]: true};
    return b.s == "hello" && b?.i == 1 && b?.f == 2.0 && b["b"] == true;
}
string mapValue = "";
function testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames() returns boolean {
    Baz b = {f: 1.0, [getChar("f")]: 4.0, [getChar("s")]: addStringToMapValue(" world"),
        [getChar("s")]: addStringToMapValue(" from Ballerina"), s: addStringToMapValue("hello")};
    return b.s == "hello world from Ballerina" && b?.f == 4.0;
}
function getChar(string st) returns string => st;
function addStringToMapValue(string s) returns string { mapValue += s; return mapValue; }

public type CustomDetail record { string message; error cause?; };
const FOO_REASON = "FooError";
type FooError distinct error<CustomDetail>;
const BAR_REASON = "BarError";
type BarError error<CustomDetail>;
type Error FooError|BarError;
type MyRecord record { typedesc<Error>[] myErrorTypes = [FooError]; };
function testCustomErrorTypeDescFieldOnRecord() {
    MyRecord m = {};
    typedesc<Error> e = m.myErrorTypes[0];
    if !(e is typedesc<FooError>) { panic error("AssertionError", message = "expected typedesc<FooError> but found: " + e.toString()); }
}

type FooRecord record { string a; int b?; };
function removeOptional() {
    FooRecord fooRecord = {a: "a", b: 1};
    _ = fooRecord.remove("b");
    if !(fooRecord?.b is ()) { panic error("Wrong Result"); }
}
function removeRest() {
    FooRecord fooRecord = {a: "a", b: 1, "c": 10};
    _ = fooRecord.remove("c");
    if !(fooRecord["c"] is ()) { panic error("Wrong Result"); }
}
type Student record { int id; string name?; Details details = {name: "chirans"}; };
type Grades record { int maths; int physics; };
function removeIfHasKeyOptional() {
    Student s = {id: 1, name: "Andrew"};
    string? n = <string?>s.removeIfHasKey("name");
    if n is () || <string>n !== "Andrew" || !(s.removeIfHasKey("age") is ()) { panic error("Wrong Result"); }
}
function removeIfHasKeyRest() {
    Grades g1 = {maths: 80, physics: 75};
    Student s = {id: 1, name: "Andrew", "grade": g1};
    Grades? g2 = <Grades?>s.removeIfHasKey("grade");
    if g2 is () || (<Grades>g2).maths != g1.maths || (<Grades>g2).physics != g1.physics || !(s.removeIfHasKey("grade") is ()) { panic error("Wrong Result"); }
}

final int a = 10;
type Foo2 record { int a; int b = a; };
function testScopingRules() {
    Foo2 f = {a: 20};
    assert(<Foo2>{a: 20, b: 10}, f);
    record {int a; int b = a; record {int p = a;} c = {};} f2 = {a: 20};
    assert(<record {int a; int b; record {int p;} c;}>{a: 20, b: 10, c: {p: 10}}, f2);
}

type FieldsWithBuiltinNames record { error 'error; json 'json; anydata 'anydata; };
function testRecordsWithFieldsWithBuiltinNames() {
    error newError = error("bam", message = "new error");
    FieldsWithBuiltinNames f = {'error: newError, 'json: {s: "s"}, 'anydata: 3};
    assert("{\"error\":error(\"bam\",message=\"new error\"),\"json\":{\"s\":\"s\"},\"anydata\":3}", f.toString());
}

type Details record { string name; BirthDay birthDay = {}; };
type BirthDay record { int year = 2000; };
type Foo6 record {| int[] z = [1, 2]; |};
type Foo5 record {| *Foo6; int[] x = [1]; int[] y = []; |};
type Bar5 record {| *Foo5; int[] & readonly x = [2]; |};
function testIntersectionOfReadonlyAndRecordTypeWithDefaultValues() {
    Student & readonly student = {id: 0};
    assert("chirans", student.details.name);
    assert(2000, student.details.birthDay.year);
    Bar5 & readonly b1 = {};
    assert([2], b1.x); assert(true, b1.x is int[]);
    assert([], b1.y); assert(true, b1.y is int[]);
    assert([1, 2], b1.z); assert(true, b1.z is int[]);
}

type DefaultableFieldsWithQuotedIdentifiersForTypeKeywords record { error? 'error = (); json 'json = 10; anydata 'anydata = "hello"; };
function testDefaultableRecordFieldsWithQuotedIdentifiersForTypeKeywords() {
    DefaultableFieldsWithQuotedIdentifiersForTypeKeywords r = {};
    assert(true, r?.'error is ()); assert(10, r?.'json); assert("hello", r?.'anydata);
    error err = error("oops!", code = 404);
    DefaultableFieldsWithQuotedIdentifiersForTypeKeywords s = {'error: err, 'anydata: 1234, 'json: true};
    assert(true, s?.'error === err); assert(true, s?.'json); assert(1234, s?.'anydata);
}

function assert(anydata expected, anydata actual) {
    if expected != actual { panic error("AssertionError", message = "expected " + expected.toString() + ", found " + actual.toString()); }
}

function javaTypeName(any value) returns string {
    string typeName = (typeof value).toString();
    int separator = <int>typeName.indexOf(":");
    return typeName.substring(separator + 1);
}

function javaAnimalValueString(Animal animal) returns string => "object " + javaTypeName(animal);

function javaAnimalArrayString(Animal?[] animals) returns string {
    string[] values = [];
    foreach Animal? animal in animals {
        if animal is Animal {
            values.push(javaAnimalValueString(animal));
        } else {
            values.push("null");
        }
    }
    return "[" + string:'join(",", ...values) + "]";
}

type Teacher record { int toJson = 44; };
function testLangFuncOnRecord() returns json {
    Teacher p = {};
    return p.toJson();
}

type R0 record { int|string f = 1; };
type R1 record { *R0; string f; };
type R2 record { int|string h = 101; };
type Foo1 record {| int a = 1250; |};
type Bar1 record {| *Foo; byte a = 100; |};
type Bar3 record {| *Foo; *R2; byte a = 100; |};
function testTypeInclusionWithOpenRecord() {
    R1 r1 = {f: "hello"}; assert("hello", r1.f);
    Bar1 b = {}; assert(100, b.a);
    Bar3 b3 = {}; assert(100, b3.a); assert(101, b3.h);
}

type Foo3 record { int x = 10; int y = 20; };
type Bar4 record { int a = 30; int b = 40; };
type Baz2 record { *Foo3; *Bar4; };
function testWithMultipleTypeInclusions() {
    Baz2 baz = {};
    assert(10, baz.x); assert(20, baz.y); assert(30, baz.a); assert(40, baz.b);
}

type Foo4 record { int x = 10; int y = 10; };
type Mat2 record { int x = fn1(); int y; };
isolated int gVal5 = 145;
isolated function fn1() returns int { lock { gVal5 = 150; } return 10; }
isolated function getValue1() returns int { lock { return gVal5; } }
function testSpreadOperatorWithOpenRecord() {
    record {int x; int y?;} r = {x: 14}; Foo4 f = {...r}; assert(14, f.x); assert(10, f.y);
    record {int x; int y?;} r1 = {x: 14, y: 15}; Foo4 f1 = {...r1}; assert(14, f1.x); assert(15, f1.y);
    record {int x?; int y?;} r2 = {}; Foo4 f2 = {...r2}; assert(10, f2.x); assert(10, f2.y);
    record {|int x?;|} r3 = {x: 21}; Foo4 f3 = {...r3, y: 12}; assert(21, f3.x); assert(12, f3.y);
    record {|int x?;|} r4 = {}; Foo4 f4 = {...r4, y: 12}; assert(10, f4.x); assert(12, f4.y);
    record {|int y; int x?;|} r5 = {y: 12, x: 21}; Mat2 m1 = {...r5}; assert(21, m1.x); assert(12, m1.y); assert(145, getValue1());
    record {|int y; int x?;|} r6 = {y: 12}; Mat2 m2 = {...r6}; assert(10, m2.x); assert(12, m2.y); assert(150, getValue1());
}

public function main() {
    io:println(testExpressionAsIndex()); // @output Jane
    io:println(testStructOfStruct()); // @output USA
    io:println(testReturnStructAttributes()); // @output emily
    io:println(testStructExpressionAsIndex()); // @output emily
    testDefaultVal();
    testWithMultipleTypeInclusions();
    testSpreadOperatorWithOpenRecord();

    [string, string, int] nestedDefaults = testNestedFieldDefaultVal();
    io:println(nestedDefaults[0]); // @output default first name
    io:println(nestedDefaults[1]); // @output Smith
    io:println(nestedDefaults[2]); // @output 999
    Person nested = testNestedStructInit();
    io:println(nested.name); // @output aaa
    io:println(nested.age); // @output 25
    Person parent = <Person>nested.parent;
    io:println(parent.name); // @output bbb
    io:println(parent.age); // @output 50
    [int, int, float, float] negatives = getStructNegativeValues();
    io:println(negatives[0]); // @output -9
    io:println(negatives[1]); // @output -8
    io:println(negatives[2]); // @output -88.234
    io:println(negatives[3]); // @output -24.99
    io:println(getStruct()); // @output {"name":"aaa","lname":"","adrs":{},"age":25,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":{"name":"bbb","lname":"ccc","adrs":{},"age":50,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":null}}

    var added = testAdditionOfARestField();
    io:println(added["mname"]); // @output Bar
    io:println(added["height"]); // @output 5.9
    io:println(added["firstName"]); // @output John
    io:println(added); // @output {"name":"Foo","lname":"","adrs":{},"age":25,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":null,"mname":"Bar","height":5.9,"firstName":"John"}
    io:println(testAnydataOrErrorRestFieldRHSIndexAccess()); // @output

    var stringRest = testStringRestField();
    io:println(stringRest["lname"]); // @output Bar
    io:println(stringRest["address"]); // @output Colombo
    io:println(stringRest); // @output {"name":"Foo","age":25,"lname":"Bar","address":"Colombo"}
    [string?, string?] stringRhs = testStringRestFieldRHSIndexAccess();
    io:println(stringRhs[0]); // @output
    io:println(stringRhs[1]); // @output
    var intRest = testIntRestField();
    io:println(intRest["year"]); // @output 3
    io:println(intRest); // @output {"name":"Foo","age":25,"year":3}
    [int?, int?] intRhs = testIntRestFieldRHSIndexAccess();
    io:println(intRhs[0]); // @output 0
    io:println(intRhs[1]); // @output
    var floatRest = testFloatRestField();
    io:println(floatRest["height"]); // @output 5.9
    io:println(floatRest); // @output {"name":"Foo","age":25,"height":5.9}
    [float?, float?] floatRhs = testFloatRestFieldRHSIndexAccess();
    io:println(floatRhs[0]); // @output 61.5
    io:println(floatRhs[1]); // @output
    var booleanRest = testBooleanRestField();
    io:println(booleanRest["isEmployed"]); // @output true
    io:println(booleanRest); // @output {"name":"Foo","age":25,"isEmployed":true}
    [boolean?, boolean?] booleanRhs = testBooleanRestFieldRHSIndexAccess();
    io:println(booleanRhs[0]); // @output true
    io:println(booleanRhs[1]); // @output

    var mapRest = testMapRestField();
    io:println(mapRest["misc"]); // @output {"lname":"Bar","height":5.9,"isEmployed":true}
    io:println(mapRest); // @output {"name":"Foo","age":25,"misc":{"lname":"Bar","height":5.9,"isEmployed":true}}
    var mapRhs = testMapRestFieldRHSIndexAccess();
    map<any> mapRhs0 = <map<any>>mapRhs[0];
    io:println(mapRhs0.length()); // @output 0
    io:println(mapRhs[1]); // @output
    io:println(testUnionRestField()); // @output {"name":"Foo","age":25,"lname":"Bar","height":5.9,"isEmployed":true}
    [(float|string|boolean)?, (float|string|boolean)?] unionRhs = testUnionRestFieldRHSIndexAccess();
    io:println(unionRhs[0]); // @output Foo
    io:println(unionRhs[1]); // @output
    var nilRest = testNilRestField();
    io:println(nilRest["lname"]); // @output
    io:println(nilRest); // @output {"name":"Foo","age":25,"lname":null}
    var recordRest = testRecordRestField();
    io:println(recordRest["dpt"]); // @output {"dptName":"Engineering","employees":[]}
    io:println(recordRest); // @output {"name":"Foo","age":25,"dpt":{"dptName":"Engineering","employees":[]}}
    var recordRhs = testRecordRestFieldRHSIndexAccess();
    io:println(recordRhs[0]); // @output {"dptName":"","employees":[]}
    io:println(recordRhs[1]); // @output

    var objectRest = testObjectRestField();
    Animal restPet = <Animal>objectRest["pet"];
    io:println("{kind:" + restPet.kind + ", name:" + restPet.name + "}"); // @output {kind:Cat, name:Miaw}
    io:println("{\"name\":\"" + objectRest.name + "\",\"age\":" + objectRest.age.toString() +
        ",\"pet\":" + javaAnimalValueString(restPet) + "}"); // @output {"name":"Foo","age":25,"pet":object Animal}
    var objectRhs = testObjectRestFieldRHSIndexAccess();
    Animal objectPet = <Animal>objectRhs[0];
    io:println(javaTypeName(objectPet)); // @output Animal
    io:println(objectPet.kind); // @output Dog
    io:println(objectPet.name); // @output Rocky
    io:println(objectRhs[1]); // @output
    var tupleRest = testTupleRestField();
    [float, string, Animal] misc = <[float, string, Animal]>tupleRest["misc"];
    io:println("{\"name\":\"" + tupleRest.name + "\",\"age\":" + tupleRest.age.toString() +
        ",\"misc\":[" + misc[0].toString() + ",\"" + misc[1] + "\"," + javaAnimalValueString(misc[2]) + "]}"); // @output {"name":"Foo","age":25,"misc":[5.9,"Bar",object Animal]}
    var tupleRhs = testTupleRestFieldRHSIndexAccess();
    [float, string, Animal] tuple = <[float, string, Animal]>tupleRhs[0];
    io:println(tuple[0]); // @output 4.5
    io:println(tuple[1]); // @output foo
    io:println(javaTypeName(tuple[2])); // @output Animal
    io:println(tupleRhs[1]); // @output
    var anyRest = testAnyRestField();
    Animal?[] pets = <Animal?[]>anyRest["pets"];
    io:println(javaTypeName(pets)); // @output Animal?[]
    io:println("{\"name\":\"" + anyRest.name + "\",\"age\":" + anyRest.age.toString() +
        ",\"pets\":" + javaAnimalArrayString(pets) + "}"); // @output {"name":"Foo","age":25,"pets":[object Animal,object Animal]}
    var anyRhs = testAnyRestFieldRHSIndexAccess();
    Animal?[] rhsPets = <Animal?[]>anyRhs[0];
    io:println(javaTypeName(rhsPets)); // @output Animal?[]
    io:println(javaAnimalArrayString(rhsPets)); // @output [object Animal,object Animal]
    io:println(anyRhs[1]); // @output
    io:println(testFuncPtrAsRecordField()); // @output Doe, John

    var manager = testDefaultValueInit();
    io:println(manager["name"]); // @output John Doe
    io:println(manager["age"]); // @output 25
    io:println(manager["adr"]); // @output {"city":"Colombo","country":"Sri Lanka"}
    io:println(manager["company"]); // @output WSO2
    io:println(manager["dept"]); // @output
    io:println(testRecordInitWithFuncCalls()); // @output {"b":56,"a":777}
    io:println(testLiteralsAsMappingConstructorKeys()); // @output true
    io:println(testExpressionAsKeys()); // @output true
    io:println(testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames()); // @output true
    json langFuncResult = testLangFuncOnRecord();
    io:println((<map<json>>langFuncResult)["toJson"]); // @output 44
    testTypeInclusionWithOpenRecord();
    testCustomErrorTypeDescFieldOnRecord();
    removeOptional();
    removeRest();
    removeIfHasKeyOptional();
    removeIfHasKeyRest();
    testScopingRules();
    testIntersectionOfReadonlyAndRecordTypeWithDefaultValues();
    testRecordsWithFieldsWithBuiltinNames();
    testDefaultableRecordFieldsWithQuotedIdentifiersForTypeKeywords();
}
