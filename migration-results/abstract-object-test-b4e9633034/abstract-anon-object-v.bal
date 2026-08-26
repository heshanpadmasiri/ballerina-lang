import ballerina/io;

public class Person {
    public int age = 0;
    public string name = "";

    public function getName() returns string {
        return "Person Name";
    }
}

public class Employee {
    public int age = 0;
    public string name = "";

    public function getName() returns string {
        return "Employee Name";
    }
}

function testAbstractAnonObjectInTypeTest() returns [string, string] {
    any p = new Person();
    any e = new Employee();

    [string, string] names = ["", ""];
    if p is object {public function getName() returns string;} {
        names[0] = p.getName();
    }

    if e is object {public function getName() returns string;} {
        names[1] = e.getName();
    }

    return names;
}

function testAbstractAnonObjectInFunction() returns [string, string] {
    Person p = new();
    Employee e = new();
    return [getName(p), getName(e)];
}

function getName(object {public function getName() returns string;} obj) returns string {
    return obj.getName();
}

function testAbstractAnonObjectInVarDef() returns [string, string] {
    object {public function getName() returns string;} p = new Person();
    object {public function getName() returns string;} e = new Employee();
    return [getName(p), getName(e)];
}

public function main() {
    [string, string] typeTestResult = testAbstractAnonObjectInTypeTest();
    io:println(typeTestResult[0]); // @output Person Name
    io:println(typeTestResult[1]); // @output Employee Name

    [string, string] functionResult = testAbstractAnonObjectInFunction();
    io:println(functionResult[0]); // @output Person Name
    io:println(functionResult[1]); // @output Employee Name

    [string, string] varDefResult = testAbstractAnonObjectInVarDef();
    io:println(varDefResult[0]); // @output Person Name
    io:println(varDefResult[1]); // @output Employee Name
}
