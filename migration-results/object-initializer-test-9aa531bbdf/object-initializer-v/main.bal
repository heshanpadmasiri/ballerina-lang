import ballerina/io;
import test/object_initializer.initializers as inp;

public class person {
    public int age = 0;
    public string name = "";
    public string address = "";
    function init(int a = 10, string n = "Charles") { self.name = n; self.age = a; }
    public function getAge() { self.age = 12; }
}

function testObjectInitializerInSamePackage1() returns [int, string] {
    person p = new(n = "Peter");
    return [p.age, p.name];
}

function testObjectInitializerInAnotherPackage() returns [int, string] {
    inp:employee e = new("Peter");
    return [e.age, e.name];
}

class employee {
    public int age = 0;
    public string name = "A";
    function init(string name, int a = 30) { self.name = self.name + name; self.age = a; }
}

function testObjectInitializerOrder() returns [int, string] {
    employee p = new("B", a = 40);
    return [p.age, p.name];
}

class Person {
    string name;
    int age;
    function init() returns error? { self.name = check getError(); self.age = 25; }
}

function getError() returns string|error {
    return error("failed to create Person object", f = "foo");
}

function validateError(any|error value, string message) {
    if value is error && value.message() == message { return; }
    panic error("Expected error");
}

function testErrorReturningInitializer() {
    Person|error p = new();
    validateError(p, "failed to create Person object");
}

function testReturnedValWithTypeGuard() returns string {
    Person|error p = new Person();
    if p is error { return "error"; }
    return "Person";
}

function testAssigningToVar() {
    var v = new Person();
    validateError(v, "failed to create Person object");
}

class Person2 {
    string name;
    int age = 27;
    string profession;
    anydata[] misc;
    function init(string name, string profession = "", anydata... misc) {
        self.name = name;
        self.profession = profession;
        self.misc = misc;
    }
}

function testInitializerWithRestArgs() returns Person2 {
    json adr = {city: "Colombo", country: "Sri Lanka"};
    return new("Pubudu", "Software Engineer", adr);
}

type ErrorDetails record {| int id; string message?; error cause?; |};
type Err error<ErrorDetails>;

class Person3 {
    string name;
    int age;
    function init(string name, int age) returns Err? { self.name = check getError2(100); self.age = 25; }
}

function getError2(int errId) returns string|Err {
    return error Err("Failed to create object", id = errId);
}

function testCustomErrorReturn() returns [Person3|Err, Person3|error] {
    Person3|Err p1 = new("Pubudu", 27);
    Person3|error p2 = new("Pubudu", 27);
    return [p1, p2];
}

type FooErrData record {| string f; string message?; error cause?; |};
type FooErr error<FooErrData>;
type BarErrData record {| string b; string message?; error cause?; |};
type BarErr error<BarErrData>;

class Person4 {
    string name;
    int age;
    function init(boolean isFoo) returns FooErr|BarErr|() { self.name = check getMultipleErrors(isFoo); self.age = 25; }
}

function getMultipleErrors(boolean isFoo) returns string|FooErr|BarErr {
    if isFoo { return error FooErr("Foo Error", f = "foo"); }
    return error BarErr("Bar Error", b = "bar");
}

function testMultipleErrorReturn() returns [Person4|FooErr|BarErr, Person4|FooErr|BarErr] {
    Person4|FooErr|BarErr p1 = new(true);
    Person4|FooErr|BarErr p2 = new(false);
    return [p1, p2];
}

class Too {
    public string name;
    public function init(string name) { self.name = name; }
    function updateName(string name) { self.init(name); }
}

function testInitActionInsideObjectDescriptor() returns string {
    Too t = new("Java");
    t.updateName("Ballerina");
    return t.name;
}

function panicTheStr() returns error|string { return error("Panicked"); }

class PanicReceiver {
    public int age = 0;
    public string name = "A";
    function init(string name, int a = 30) { self.name = self.name + name; self.age = a; panic error("init panicked"); }
}

function panicWrapper() { PanicReceiver _ = new(checkpanic panicTheStr()); }

function testCheckPanicObjectInit(boolean b) returns error|Person4 {
    Person4 r = check new(b);
    return r;
}

function testCheckPanicInObjectInitArg() {
    error|() p = trap panicWrapper();
    validateError(p, "Panicked");
}

function testObjectInitPanic() {
    var e = trap new PanicReceiver("Mr. Panic");
    validateError(e, "init panicked");
}

class Student1 {
    public int marks = 75;
    public function init() {}
    public function getMarks() returns int { self.init(); return self.marks; }
}

function testInitInvocationInsideObject() returns boolean {
    Student1 student = new;
    int marksBeforeChange = student.getMarks();
    student.marks = 80;
    int marksAfterChange = student.getMarks();
    return marksBeforeChange == 75 && marksAfterChange == 80;
}

class Student2 {
    public string grade;
    public function init(string grade) { self.grade = grade; }
    public function resetGrade(string grade) returns string { self.init(grade); return self.grade; }
}

function testInitInvocationInsideObjectWithArgs() returns boolean {
    Student2 student = new("B");
    string before = student.grade;
    string after = student.resetGrade("B+");
    return before == "B" && after == "B+";
}

function getName(int id) returns string|error {
    if id == -1 { return error("failed to return a name"); }
    return "Smith";
}

class Student3 {
    public string name;
    public int marks = 90;
    public function init(int id) returns error? { self.name = check getName(id); }
    public function getMarks() returns int { error? ignored = self.init(0); if ignored is error {} return self.marks; }
}

function testObjInitWithCheck(int id) returns [Student3|error, int, int] {
    Student3|error student = new(id);
    if student is error { return [student, 0, 0]; }
    int before = student.getMarks();
    student.marks = 95;
    return [student, before, student.getMarks()];
}

function testObjInitWithCheck1() returns boolean {
    var [s, before, after] = testObjInitWithCheck(-1);
    return s is error && before == 0 && after == 0;
}

function testObjInitWithCheck2() returns boolean {
    var [s, before, after] = testObjInitWithCheck(10);
    return !(s is error) && before == 90 && after == 95;
}

class Student4 {
    string[] modules;
    public function init(string... modules) { self.modules = modules; }
    public function changeModules(string... modules) { self.init(...modules); }
}

function testInitInvocationWithRestArgs() returns boolean {
    string[] modules = ["Science", "History"];
    Student4 student = new(...modules);
    string[] before = student.modules;
    string[] newModules = ["Maths", "Physics"];
    student.changeModules(...newModules);
    string[] after = student.modules;
    return before[0] == "Science" && before[1] == "History" && after[0] == "Maths" && after[1] == "Physics";
}

class Student5 {
    public string name;
    string[] modules;
    public int marks = 90;
    public function init(int id, string... modules) returns error? { self.name = check getName(id); self.modules = modules; }
    public function getMarks() returns int { error? ignored = self.init(0); if ignored is error {} return self.marks; }
}

function testInitInvocationWithCheckAndRestParams(int id, string... modules) returns [Student5|error, int, int] {
    Student5|error student = new(id, ...modules);
    if student is error { return [student, 0, 0]; }
    int before = student.getMarks();
    student.marks = 95;
    return [student, before, student.getMarks()];
}

function testInitInvocationWithCheckAndRestParams1() returns boolean {
    string[] modules = ["Math", "Physics"];
    var [s, before, after] = testInitInvocationWithCheckAndRestParams(-1, ...modules);
    return s is error && before == 0 && after == 0;
}

function testInitInvocationWithCheckAndRestParams2() returns boolean {
    string[] modules = ["Math", "Physics"];
    var [s, before, after] = testInitInvocationWithCheckAndRestParams(10, ...modules);
    return !(s is error) && before == 90 && after == 95;
}

class Student6 {
    int id;
    public function init(int id = 1) { self.id = id; }
    public function getId() returns int { return self.id; }
}
function testInitInvocationWithDefaultParams1() returns boolean { Student6 student = new; return student.getId() == 1; }

class Student7 {
    int? id;
    public function init(int? id = 1) { self.id = id; }
    public function getId() returns int { if self.id is int { return <int> self.id; } panic error("ID should be an integer"); }
}
function testInitInvocationWithDefaultParams2() returns boolean { Student7 student = new(4); return student.getId() == 4; }

public type ID int|string;
class Student8 {
    int id;
    public function init(ID i = 1) { self.id = <int> i; }
    public function getId() returns int { return self.id; }
}
function testInitInvocationWithFiniteType() returns boolean { Student8 student = new(4); return student.getId() == 4; }

class AddError {
    error er;
    function init(error simpleError = error("SimpleErrorType", message = "Simple error occurred")) { self.er = simpleError; }
    public function getError() returns error|() { return self.er; }
}
function testInitInvocationWithDefaultError() returns boolean {
    AddError newError = new;
    return newError.getError() is error;
}

class Student9 {
    int fullMarks;
    public function init(int firstMark = 80, int secondMark = firstMark) { self.fullMarks = firstMark + secondMark; }
    public function getMarks() returns int { return self.fullMarks; }
}
function testInitInvocationWithReferenceToDefaultValue1() returns boolean { Student9 student = new; return student.getMarks() == 160; }

class Calculate1 {
    int sum;
    public function init(int a, int b, int c, int d = a + b + c * c) { self.sum = d; }
    public function getSum() returns int { return self.sum; }
}
function testInitInvocationWithReferenceToDefaultValue2() returns boolean { Calculate1 cal = new(2, 3, 4); return cal.getSum() == 21; }

class Calculate2 {
    int sum;
    string op;
    public function init(string operation, int a, int b, int c, int d = a + b + c * c) returns error? { self.op = check checkOperation(operation); self.sum = d; }
}
function checkOperation(string operation) returns string|error {
    if operation == "SUB" { return error("unsupported operation", op = operation); }
    return operation;
}
function testErrorReturnWithInitialization() returns boolean { Calculate2|error cal = new("SUB", 2, 3, 4); return cal is error; }

public const NAME = "John";
public const AGE = 11;
public type TYPE NAME|AGE;
class Student10 {
    string name = "";
    int age = 11;
    TYPE t1;
    TYPE t2;
    function init(string name = NAME, int age = AGE, TYPE t1 = NAME, TYPE t2 = AGE) { self.name = name; self.age = age; self.t1 = t1; self.t2 = t2; }
    function getDetails() returns [string, int, TYPE, TYPE] { return [self.name, self.age, self.t1, self.t2]; }
}
function testConstRefsAsDefaultValue() returns boolean {
    Student10 s = new("Andrew");
    [string, int, TYPE, TYPE] details = s.getDetails();
    return details[0] == "Andrew" && details[1] == 11 && details[2] == "John" && details[3] == 11;
}

function getData(string n) returns string { return n; }
class Student11 {
    string name;
    function init(string n, function(string) returns string fn = (x) => "John") { self.name = fn(n); }
    function getName() returns string { return self.name; }
}
function testFunctionPointerAsDefaultableParam1() {
    Student11 s1 = new("Anne", getData);
    if s1.getName() != "Anne" { panic error("Returned string should equal 'Anne'"); }
    Student11 s2 = new("Anne");
    if s2.getName() != "John" { panic error("Returned string should equal 'John'"); }
}

function getTotalMarks(int a, int b) returns int { return a + b + 10; }
class Student12 {
    int marks;
    function init(int x, int y, function(int, int) returns int fn = function(int a, int b) returns int { return 100; }) { self.marks = fn(x, y); }
    function getMarks() returns int { return self.marks; }
}
function testFunctionPointerAsDefaultableParam2() {
    Student12 s1 = new(10, 20, getTotalMarks);
    if s1.getMarks() != 40 { panic error("Returned string should equal '40'"); }
    Student12 s2 = new(10, 20);
    if s2.getMarks() != 100 { panic error("Returned string should equal '100'"); }
}

public function main() {
    var same = testObjectInitializerInSamePackage1();
    io:println(same[0]); // @output 10
    io:println(same[1]); // @output Peter
    var another = testObjectInitializerInAnotherPackage();
    io:println(another[0]); // @output 10
    io:println(another[1]); // @output Peter
    var ordered = testObjectInitializerOrder();
    io:println(ordered[0]); // @output 40
    io:println(ordered[1]); // @output AB
    testErrorReturningInitializer();
    Person2 rest = testInitializerWithRestArgs();
    io:println(rest.name); // @output Pubudu
    io:println(rest.age); // @output 27
    io:println(rest.profession); // @output Software Engineer
    io:println(rest.misc); // @output [{"city":"Colombo","country":"Sri Lanka"}]
    var custom = testCustomErrorReturn();
    Person3|Err custom1 = custom[0];
    Person3|error custom2 = custom[1];
    if custom1 is Err { io:println(typeof custom1); // @output typedesc object_initializer:Err
        io:println(custom1.message()); // @output Failed to create object
        io:println(custom1.detail()); // @output {"id":100}
    }
    if custom2 is Err { io:println(typeof custom2); // @output typedesc object_initializer:Err
        io:println(custom2.message()); // @output Failed to create object
        io:println(custom2.detail()); // @output {"id":100}
    }
    io:println(testReturnedValWithTypeGuard()); // @output error
    var multiple = testMultipleErrorReturn();
    Person4|FooErr|BarErr multiple1 = multiple[0];
    Person4|FooErr|BarErr multiple2 = multiple[1];
    if multiple1 is error { io:println(multiple1.message()); // @output Foo Error
        io:println(multiple1.detail()); // @output {"f":"foo"}
    }
    if multiple2 is error { io:println(multiple2.message()); // @output Bar Error
        io:println(multiple2.detail()); // @output {"b":"bar"}
    }
    testAssigningToVar();
    testCheckPanicInObjectInitArg();
    io:println(testCheckPanicObjectInit(true)); // @output error FooErr ("Foo Error",f="foo")
    io:println(testCheckPanicObjectInit(false)); // @output error BarErr ("Bar Error",b="bar")
    testObjectInitPanic();
    io:println(testInitActionInsideObjectDescriptor()); // @output Ballerina
    io:println(testInitInvocationInsideObject()); // @output true
    io:println(testInitInvocationInsideObjectWithArgs()); // @output true
    io:println(testObjInitWithCheck1()); // @output true
    io:println(testObjInitWithCheck2()); // @output true
    io:println(testInitInvocationWithRestArgs()); // @output true
    io:println(testInitInvocationWithCheckAndRestParams1()); // @output true
    io:println(testInitInvocationWithCheckAndRestParams2()); // @output true
    io:println(testInitInvocationWithDefaultParams1()); // @output true
    io:println(testInitInvocationWithDefaultParams2()); // @output true
    io:println(testInitInvocationWithFiniteType()); // @output true
    io:println(testInitInvocationWithDefaultError()); // @output true
    io:println(testInitInvocationWithReferenceToDefaultValue1()); // @output true
    io:println(testInitInvocationWithReferenceToDefaultValue2()); // @output true
    io:println(testErrorReturnWithInitialization()); // @output true
    io:println(testConstRefsAsDefaultValue()); // @output true
    testFunctionPointerAsDefaultableParam1();
    testFunctionPointerAsDefaultableParam2();
}
