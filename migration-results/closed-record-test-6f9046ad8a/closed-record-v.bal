import ballerina/io;

type Department record {|
    string dptName = "";
    Person[] employees = [];
|};

type Person record {|
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    Family family = {};
    Person? parent = ();
|};

type Family record {|
    string spouse = "";
    int noOfChildren = 0;
    string[] children = [];
|};

type Employee record {|
    string name = "default first name";
    string lname = "";
    map<any> address = {};
    int age = 999;
    Family family = {};
    Person? parent = ();
    string designation = "";
|};

function testStructOfStruct() returns string {
    map<any> address = {"country": "USA", "state": "CA"};
    Person emp1 = {name: "Jack", adrs: address, age: 25};
    Department dpt = {employees: [emp1, {}]};
    var result = dpt.employees[0].adrs["country"];
    return result is string ? result : "";
}

function testReturnStructAttributes() returns string {
    Person emp1 = {name: "Jack", family: {children: []}};
    Department dpt = {employees: [emp1, {}]};
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
    Person emp1 = {name: "Jack", adrs: {"country": "USA", "state": "CA"}, age: 25, family: {children: []}};
    dpt.employees = [emp1, {}];
    dpt.employees[0].family.children[0] = "emily";
    dpt.employees[0].family.noOfChildren = 1;
    return dpt.employees[0].family.children[dpt.employees[0].family.noOfChildren - 1];
}

function testDefaultVal() returns [string, string, int] {
    Person p = {};
    return [p.name, p.lname, p.age];
}

function testNestedFieldDefaultVal() returns [string, string, int] {
    Department dpt = {};
    dpt.employees = [];
    dpt.employees[0] = {lname: "Smith"};
    return [dpt.employees[0].name, dpt.employees[0].lname, dpt.employees[0].age];
}

function testNestedStructInit() returns Person {
    return {name: "aaa", age: 25, parent: {name: "bbb", age: 50}};
}

type NegativeValTest record {|
    int negativeInt = -9;
    int negativeSpaceInt = -8;
    float negativeFloat = -88.234;
    float negativeSpaceFloat = -24.99;
|};

function getStructNegativeValues() returns [int, int, float, float] {
    NegativeValTest tmp = {};
    return [tmp.negativeInt, tmp.negativeSpaceInt, tmp.negativeFloat, tmp.negativeSpaceFloat];
}

function getStruct() returns Person {
    return {name: "aaa", age: 25, parent: {name: "bbb", lname: "ccc", age: 50}};
}

function testStructWithRecordKeyword() returns Employee {
    return {name: "John", lname: "Doe", address: {"country": "USA", "state": "CA"}, age: 25,
        designation: "Software Engineer"};
}

type PersonA record {|
    string fname = "";
    string lname = "";
    function() returns string fullName?;
|};

function testFuncPtrAsRecordField() returns string {
    PersonA p = {fname: "John", lname: "Doe"};
    p.fullName = function() returns string { return p.lname + ", " + p.fname; };
    function() returns string fp = <function() returns string>p["fullName"];
    return fp();
}

public type InMemoryModeConfig record {|
    string name = "";
    string username = "";
    string password = "";
    map<any> dbOptions = {};
|};
public type ServerModeConfig record {|
    string host;
    int port;
    *InMemoryModeConfig;
|};
public type EmbeddedModeConfig record {|
    string path;
    *InMemoryModeConfig;
|};

function testAmbiguityResolution() returns [string, string, string] {
    return [_init_({}), _init_({host: "localhost", port: 9090}), _init_({path: "localhost:9090"})];
}
function _init_(InMemoryModeConfig|ServerModeConfig|EmbeddedModeConfig rec) returns string {
    if rec is ServerModeConfig { return "Server mode configuration"; }
    if rec is EmbeddedModeConfig { return "Embedded mode configuration"; }
    return "In-memory mode configuration";
}

public type A record {| string a; string b; string c; |};
public type B record {| string f; int g?; *A; |};
public type C record {| string i; *A; |};
function testAmbiguityResolution2() returns [string, string, string, string] {
    return [resolve({a: "", b: "", c: ""}), resolve({a: "", b: "", c: "", f: ""}),
        resolve({a: "", b: "", c: "", f: "", g: 0}), resolve({a: "", b: "", c: "", i: ""})];
}
function resolve(A|B|C rec) returns string {
    if rec is A { return "A"; }
    if rec is B { return "B"; }
    return "C";
}

public type EmptyRec1 record {||};
public type EmptyRec2 record {| |};
public type EmptyRec3 record {|
|};
public type EmptyRec4 record {|

|};
function testEmptyClosedRecords() returns record {}[] {
    EmptyRec1 r1 = {};
    EmptyRec2 r2 = {};
    EmptyRec3 r3 = {};
    EmptyRec4 r4 = {};
    return [r1, r2, r3, r4];
}

type Foo record {| string bar; int baz; |};
function testLiteralsAsMappingConstructorKeys() returns boolean {
    Foo f = {"bar": "hello", baz: 1};
    return f.bar == "hello" && f.baz == 1;
}
type Baz record {| string s; int i?; float? f = (); |};
string iValue = "i";
function testExpressionAsKeys() returns boolean {
    Baz b = {s: "hello", [iValue]: 1, [getChar("f")]: 2.0};
    return b.s == "hello" && b?.i == 1 && b?.f == 2.0;
}
string mapValue = "";
function testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames() returns boolean {
    Baz b = {f: 1.0, [getChar("f")]: 4.0, [getChar("s")]: addStringToMapValue(" world"),
        [getChar("s")]: addStringToMapValue(" from Ballerina"), s: addStringToMapValue("hello")};
    return b.s == "hello world from Ballerina" && b?.f == 4.0;
}
function getChar(string st) returns string => st;
function addStringToMapValue(string s) returns string { mapValue = mapValue + s; return mapValue; }

type FooRecord record {| string a; int b?; int...; |};
function removeOptional() {
    FooRecord fooRecord = {a: "a", b: 1};
    _ = fooRecord.remove("b");
    if fooRecord?.b is int { panic error("Wrong Result"); }
}
function removeRest() {
    FooRecord fooRecord = {a: "a", b: 1, "c": 10};
    _ = fooRecord.remove("c");
    if fooRecord["c"] is int { panic error("Wrong Result"); }
}
type Student record {| int id; string name?; Grades...; |};
type Grades record {| int maths; int physics; int...; |};
function removeIfHasKeyOptional() {
    Student s = {id: 1, name: "Andrew"};
    string? n = <string?>s.removeIfHasKey("name");
    if n is () || <string>n != "Andrew" || !(s.removeIfHasKey("age") is ()) { panic error("Wrong Result"); }
}
function removeIfHasKeyRest() {
    Grades g1 = {maths: 80, physics: 75};
    Student s = {id: 1, name: "Andrew", "grade": g1};
    Grades? g2 = <Grades?>s.removeIfHasKey("grade");
    if g2 is () || !(g2.maths == g1.maths && g2.physics == g1.physics) || !(s.removeIfHasKey("grade") is ()) {
        panic error("Wrong Result");
    }
}

public type Qux readonly & record {| string a; string b; |};
type Quux record {| anydata body; |};
public type Corge record {| *Quux; Qux body; |};
function testOverridingIncludedFieldInRecordWithReadOnlyIntersection() {
    Corge corge = {body: {a: "hello", b: "world"}};
    if corge.body.a != "hello" || corge.body.b != "world" { panic error("Wrong Result"); }
}

public function main() {
    io:println(testExpressionAsIndex()); // @output Jane
    io:println(testStructOfStruct()); // @output USA
    io:println(testReturnStructAttributes()); // @output emily
    io:println(testStructExpressionAsIndex()); // @output emily
    [string, string, int] defaults = testDefaultVal();
    io:println(defaults[0]); // @output default first name
    io:println(defaults[1]); // @output 
    io:println(defaults[2]); // @output 999
    [string, string, int] nestedDefaults = testNestedFieldDefaultVal();
    io:println(nestedDefaults[0]); // @output default first name
    io:println(nestedDefaults[1]); // @output Smith
    io:println(nestedDefaults[2]); // @output 999
    Person nested = testNestedStructInit();
    io:println(nested.name); // @output aaa
    io:println(nested.age); // @output 25
    io:println(nested.parent?.name); // @output bbb
    io:println(nested.parent?.age); // @output 50
    [int, int, float, float] negatives = getStructNegativeValues();
    io:println(negatives[0]); // @output -9
    io:println(negatives[1]); // @output -8
    io:println(negatives[2]); // @output -88.234
    io:println(negatives[3]); // @output -24.99
    io:println(getStruct()); // @output {"name":"aaa","lname":"","adrs":{},"age":25,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":{"name":"bbb","lname":"ccc","adrs":{},"age":50,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":null}}
    io:println(testStructWithRecordKeyword()); // @output {"name":"John","lname":"Doe","address":{"country":"USA","state":"CA"},"age":25,"family":{"spouse":"","noOfChildren":0,"children":[]},"parent":null,"designation":"Software Engineer"}
    io:println(testFuncPtrAsRecordField()); // @output Doe, John
    [string, string, string] ambiguity = testAmbiguityResolution();
    io:println(ambiguity[0]); // @output In-memory mode configuration
    io:println(ambiguity[1]); // @output Server mode configuration
    io:println(ambiguity[2]); // @output Embedded mode configuration
    [string, string, string, string] ambiguity2 = testAmbiguityResolution2();
    io:println(ambiguity2[0]); // @output A
    io:println(ambiguity2[1]); // @output B
    io:println(ambiguity2[2]); // @output B
    io:println(ambiguity2[3]); // @output C
    record {}[] emptyRecords = testEmptyClosedRecords();
    io:println(emptyRecords[0]); // @output {}
    io:println(emptyRecords[1]); // @output {}
    io:println(emptyRecords[2]); // @output {}
    io:println(emptyRecords[3]); // @output {}
    io:println(testLiteralsAsMappingConstructorKeys()); // @output true
    io:println(testExpressionAsKeys()); // @output true
    io:println(testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames()); // @output true
    removeOptional();
    removeRest();
    removeIfHasKeyOptional();
    removeIfHasKeyRest();
    testOverridingIncludedFieldInRecordWithReadOnlyIntersection();
}
