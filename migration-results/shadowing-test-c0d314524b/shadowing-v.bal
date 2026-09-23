import ballerina/io;

xmlns "http://sample.com/wso2/a1" as ns;

const ASSERTION_ERROR_REASON = "AssertionError";

final boolean serviceEPAvailable = false;
final string LOCK_STORE = "lockStore";

int name = 10;

type Person record {
    string name = "Person";
    int age = 20;
};

class Employee {
    string name = "Employee";

    function getName() returns string {
        string name = "Name in object";
        return name;
    }
}

function testLocalVarScope() returns string {
    string name = "John Doe";
    return name;
}

function testObjMethodScope() returns string {
    Employee e = new;
    return e.getName();
}

function testRecordScope() returns Person {
    Person p = {};
    return p;
}

function testBlockScope1() returns [string, string] {
    [string, string] result = ["", ""];
    if (true) {
        string name = "Inside first if block";
        result[0] = name;
    }
    if (true) {
        string name = "Inside second if block";
        result[1] = name;
    }
    return result;
}

function testBlockScope2() returns string {
    if (0 > 1) {
        string name = "Inside if block";
        return name;
    } else {
        string name = "Inside else block";
        return name;
    }
}

function testLambdaFunctions() returns string {
    var fn = function () returns string {
        string name = "Inside a lambda function";
        return name;
    };
    return fn();
}

function testFunctionParam(string name) returns string {
    return name;
}

function testNestedBlocks() returns string {
    if (true) {
        int|string a = 10;
        if (a is string) {
            string s = "nested if";
            if (s != "nested if") {
                panic error(ASSERTION_ERROR_REASON);
            }
        } else {
            string s = "nested else";
            if (s != "nested else") {
                panic error(ASSERTION_ERROR_REASON);
            }
        }
        string s = "var after nested if-else";
        return s;
    }
}

function testNamespaces1() returns xml {
    xmlns "http://sample.com/wso2/a2" as ns;
    return xml `<ns:greeting>Hello World!</ns:greeting>`;
}

function testNamespaces2(boolean x) returns xml {
    if (x) {
        xmlns "http://sample.com/wso2/a2" as ns;
        return xml `<ns:greeting>Hello World!</ns:greeting>`;
    } else {
        xmlns "http://sample.com/wso2/a3" as ns;
        return xml `<ns:greeting>Hello World!</ns:greeting>`;
    }
}

function testTypeNameAsVariable1() {
    any Employee = "Smith";
    if (Employee is string && Employee == "Smith") {
        return;
    }
    var t = typeof Employee;
    panic error(ASSERTION_ERROR_REASON, message = "expected 'string', found '" + t.toString() + "'");
}

function testTypeNameAsVariable2() {
    any Person = "Smith";
    if (Person is string && Person == "Smith") {
        return;
    }
    var t = typeof Person;
    panic error(ASSERTION_ERROR_REASON, message = "expected 'string', found '" + t.toString() + "'");
}

function testTypeNameAsVariable3() {
    any temp = "Temp var";
    if (temp is string) {
        any Person = "Jack";
        if (Person is string && Person == "Jack") {
            return;
        }
        var t = typeof Person;
        panic error(ASSERTION_ERROR_REASON, message = "expected 'string', found '" + t.toString() + "'");
    }
}

function testTypeNameAsVariable4() {
    foreach var i in 1...2 {
        any Person = "Jack";
        if (Person is string && Person == "Jack") {
            return;
        }
        var t = typeof Person;
        panic error(ASSERTION_ERROR_REASON, message = "expected 'string', found '" + t.toString() + "'");
    }
}

type Person1 record {
    int id = 0;
};

class Student {
    string Student = "Smith";

    public function getName() returns string {
        return self.Student;
    }
}

function testTypeNameAsVariable5() {
    Student s = new;
    any name = s.getName();
    if (name is string && name == "Smith") {
        return;
    }
    var t = typeof name;
    panic error(ASSERTION_ERROR_REASON, message = "expected 'string', found '" + t.toString() + "'");
}

function testGeneratedNames() {
    if (serviceEPAvailable || LOCK_STORE != "lockStore") {
        panic error(ASSERTION_ERROR_REASON);
    }
}

type Foo int;

function testTypeAliasShadowingByLocalVar() returns string {
    string Foo = "hello";
    return Foo;
}

function testBuiltInTypeShadowing() {
    string foo = testTypeAliasShadowingByLocalVar();
    if (foo != "hello") {
        panic error(ASSERTION_ERROR_REASON);
    }
}

public function main() {
    io:println(testLocalVarScope()); // @output John Doe
    io:println(testObjMethodScope()); // @output Name in object
    io:println(testRecordScope()); // @output {"name":"Person","age":20}
    [string, string] blockScope1 = testBlockScope1();
    io:println(blockScope1[0]); // @output Inside first if block
    io:println(blockScope1[1]); // @output Inside second if block
    io:println(testBlockScope2()); // @output Inside else block
    io:println(testLambdaFunctions()); // @output Inside a lambda function
    io:println(testFunctionParam("This is a function param")); // @output This is a function param
    io:println(testNestedBlocks()); // @output var after nested if-else
    io:println(testNamespaces1()); // @output <ns:greeting xmlns:ns="http://sample.com/wso2/a2">Hello World!</ns:greeting>
    io:println(testNamespaces2(true)); // @output <ns:greeting xmlns:ns="http://sample.com/wso2/a2">Hello World!</ns:greeting>
    io:println(testNamespaces2(false)); // @output <ns:greeting xmlns:ns="http://sample.com/wso2/a3">Hello World!</ns:greeting>
    testTypeNameAsVariable1();
    testTypeNameAsVariable2();
    testTypeNameAsVariable3();
    testTypeNameAsVariable4();
    testTypeNameAsVariable5();
    testGeneratedNames();
    testBuiltInTypeShadowing();
}
