import ballerina/io;
import privatefields.foo;

public class employee01 {
    public int age = 0;
    public string name = "";
    public string address = "";
    public string zipcode = "95134";

    string ssn = "";
    int id = 0;
    int employeeId = 123456;
}

public class person {
    public int age = 0;
    public string name = "";
    public string address = "";
    public string zipcode = "95134";
    public string ssn = "";
    public int id = 0;
}

public class employeeObj {
    public int age = 0;
    public string name = "";
    public string address = "";
    public string zipcode = "95134";
    public string ssn = "";
    public int id = 0;
    public int employeeId = 123456;
}

public function textPrivateFieldAccess1() returns [string, string, string, int, int] {
    employee01 e = new;
    e.age = 14;
    e.name = "sam";
    e.ssn = "234-56-7890";
    e.id = 45034;
    return [e.name, e.zipcode, e.ssn, e.id, e.employeeId];
}

public function textPrivateFieldAccess2() returns [int, string] {
    foo:person p = foo:newPerson();
    return [p.age, p.name];
}

public function testCompileTimeStructEqWithPrivateFields() returns [string, string, string, int] {
    employeeObj e = new;
    e.age = 24;
    e.name = "jay";
    e.ssn = "123-56-7890";
    e.employeeId = 123;
    e.id = 458;

    person p = e;
    return [p.name, p.zipcode, p.ssn, p.id];
}

public function testCompileTimeStructEqWithPrivateFieldsTwoPackages() returns [int, string, string] {
    employeeObj e = new;
    e.age = 28;
    e.name = "mal";
    e.ssn = "123-56-2345";
    e.employeeId = 123;
    e.id = 458;

    foo:userObject u = e;
    return [u.age, u.name, u.zipcode];
}

public function testRuntimeStructEqWithPrivateFields() returns [string, string, string, int, int]|error {
    employeeObj e = new;
    e.age = 24;
    e.name = "jay";
    e.ssn = "123-56-7890";
    e.employeeId = 123;
    e.id = 458;

    person p = e;
    var e1 = check trap <employeeObj>p;
    return [e1.name, e1.zipcode, e1.ssn, e1.id, e1.employeeId];
}

public function testRuntimeStructEqWithPrivateFieldsTwoPackages1() returns [string, string, string, int]|error {
    employeeObj e = new;
    e.age = 24;
    e.name = "jay";
    e.ssn = "123-56-7890";
    e.id = 458;

    foo:userObject u = e;
    if u is person {
        return [u.name, u.zipcode, u.ssn, u.id];
    }
    return error("'u' is not a person");
}

public function testRuntimeStructEqWithPrivateFieldsTwoPackages2() returns [string, int] {
    foo:userObject u = foo:newUserObject();
    var uA = u;
    var uB = uA;
    return [uB.name, uB.age];
}

public function main() {
    var privateSamePackage = textPrivateFieldAccess1();
    io:println(privateSamePackage[0]); // @output sam
    io:println(privateSamePackage[1]); // @output 95134
    io:println(privateSamePackage[2]); // @output 234-56-7890
    io:println(privateSamePackage[3]); // @output 45034
    io:println(privateSamePackage[4]); // @output 123456

    var privateDifferentPackage = textPrivateFieldAccess2();
    io:println(privateDifferentPackage[0]); // @output 12
    io:println(privateDifferentPackage[1]); // @output mad

    var compileTimeSamePackage = testCompileTimeStructEqWithPrivateFields();
    io:println(compileTimeSamePackage[0]); // @output jay
    io:println(compileTimeSamePackage[1]); // @output 95134
    io:println(compileTimeSamePackage[2]); // @output 123-56-7890
    io:println(compileTimeSamePackage[3]); // @output 458

    var compileTimeDifferentPackages = testCompileTimeStructEqWithPrivateFieldsTwoPackages();
    io:println(compileTimeDifferentPackages[0]); // @output 28
    io:println(compileTimeDifferentPackages[1]); // @output mal
    io:println(compileTimeDifferentPackages[2]); // @output 95134

    var runtimeSamePackage = checkpanic testRuntimeStructEqWithPrivateFields();
    io:println(runtimeSamePackage[0]); // @output jay
    io:println(runtimeSamePackage[1]); // @output 95134
    io:println(runtimeSamePackage[2]); // @output 123-56-7890
    io:println(runtimeSamePackage[3]); // @output 458
    io:println(runtimeSamePackage[4]); // @output 123

    var runtimeDifferentPackagesOne = checkpanic testRuntimeStructEqWithPrivateFieldsTwoPackages1();
    io:println(runtimeDifferentPackagesOne[0]); // @output jay
    io:println(runtimeDifferentPackagesOne[1]); // @output 95134
    io:println(runtimeDifferentPackagesOne[2]); // @output 123-56-7890
    io:println(runtimeDifferentPackagesOne[3]); // @output 458

    var runtimeDifferentPackagesTwo = testRuntimeStructEqWithPrivateFieldsTwoPackages2();
    io:println(runtimeDifferentPackagesTwo[0]); // @output mal
    io:println(runtimeDifferentPackagesTwo[1]); // @output 56
}
