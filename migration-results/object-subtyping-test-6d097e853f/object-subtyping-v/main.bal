import ballerina/io;
import testorg/object_subtyping.subtyping;

class Person1 {
    public string name = "sample name";
    public int age = 10;
    int year = 50;
    string month = "february";
    function init(string name, int age) { self.age = age; self.name = name; }
}

class Employee1 {
    public string name = "no name";
    public int age = 3;
    int year = 2;
    string month = "idk";
    function init(string name, int age) {
        self.age = age;
        self.name = name;
        self.year = 50;
        self.month = "february";
    }
    function getName() returns string { return self.name; }
    function getYear() returns int { return self.year; }
}

type AbstractPerson object {
    public string name;
    public int age;
    public function toString() returns string;
};

class Student1 {
    public string name = "";
    public int age = 0;
    public string school = "";
    public function init(string name, int age, string school) { self.name = name; self.age = age; self.school = school; }
    public function toString() returns string { return "Student1{" + self.name + ", " + self.age.toString() + ", " + self.school + "}"; }
}

public class UniStudent1 {
    public string name = "";
    public string school = "";
    public int age = 0;
    public string major;
    public function init(string name, string school, int age, string major) { self.name = name; self.age = age; self.school = school; self.major = major; }
    public function toString() returns string { return "Student{" + self.name + ", " + self.age.toString() + ", " + self.school + ", " + self.major + "}"; }
    public function getSchool() returns string { return self.school; }
}

type AbstractAnimal object { float weight; function move(int distance) returns string; };

class Dog {
    string name;
    float weight;
    function init(string name, float weight) { self.name = name; self.weight = weight; }
    function move(int distance) returns string { return self.name + " walked " + distance.toString() + " meters"; }
}

function testAdditionalMethodsInSourceType() returns Person1 {
    Employee1 e = new("John Doe", 25);
    Person1 p = e;
    return p;
}

function testSubtypingAPublicAbstractObject() returns string {
    AbstractPerson ap = new Student1("John Doe", 25, "Ballerina Academy");
    return ap.toString();
}

function testSubtypingAPublicAbsObjectInAnotherModule() returns string {
    AbstractPerson ap = new subtyping:Student("Jane Doe", "BA", 22);
    return ap.toString();
}

function testSubtypingAPublicObjectInAnotherModule() returns string {
    subtyping:Student s = new UniStudent1("Jane Doe", "BA", 22, "CS");
    return s.toString();
}

function testSubtypingAnAbsObjectInSameModule() returns string {
    AbstractAnimal a = new Dog("Rocky", 10);
    return a.move(50);
}

function testObjectAssignabilityBetweenNonClientAndClientObject() {
    subtyping:NonClientObject _ = new subtyping:NonClientObject("NonClientObject");
    subtyping:ClientObjectWithoutRemoteMethod o2 = new subtyping:ClientObjectWithoutRemoteMethod("ClientObjectWithoutRemoteMethod");
    subtyping:NonClientObject obj3 = o2;
    assertEquality("ClientObjectWithoutRemoteMethod", obj3.name);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if (expected is string && actual is string && expected == actual) { return; }
    panic error(ASSERTION_ERROR_REASON, message = "values differ");
}

public function main() {
    Person1 additionalMethodsResult = testAdditionalMethodsInSourceType();
    io:println("{name:" + additionalMethodsResult.name + ", age:" + additionalMethodsResult.age.toString() + "}"); // @output {name:John Doe, age:25}
    io:println(testSubtypingAPublicAbstractObject()); // @output Student1{John Doe, 25, Ballerina Academy}
    io:println(testSubtypingAPublicAbsObjectInAnotherModule()); // @output Student{Jane Doe, 22, BA}
    io:println(testSubtypingAPublicObjectInAnotherModule()); // @output Student{Jane Doe, 22, BA, CS}
    io:println(testSubtypingAnAbsObjectInSameModule()); // @output Rocky walked 50 meters
    testObjectAssignabilityBetweenNonClientAndClientObject();
}
