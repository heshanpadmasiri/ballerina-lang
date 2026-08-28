import ballerina/io;
import closedrecordproject.eq;
import closedrecordproject.eq2;
import closedrecordproject.req;
import closedrecordproject.req2;

public type person1 record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    string ssn = "";
    int id = 0;
|};

public type employee1 record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    string ssn = "";
    int id = 0;
|};

function testEquivalenceOfPrivateStructsInSamePackage() returns string {
    employee1 e = {age: 14, name: "rat"};
    e.ssn = "234-56-7890:employee";
    person1 p = e;
    return p.ssn;
}

public type person2 record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    string ssn = "";
    int id = 0;
|};

public type employee2 record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    string ssn = "";
    int id = 0;
|};

function testEquivalenceOfPublicStructsInSamePackage() returns string {
    employee2 e = {age: 14, name: "rat"};
    e.ssn = "234-56-7890:employee";
    person2 p = e;
    return p.ssn;
}

function testEqOfPublicStructs() returns string {
    eq:closedEmployee e = {age: 14, name: "rat"};
    e.ssn = "234-56-7890:employee";
    eq:closedPerson p = checkpanic e.cloneWithType(eq:closedPerson);
    return p.ssn;
}

public type employee3 record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "95134";
    string ssn = "";
    int id = 0;
|};

function testEqOfPublicStructs1() returns string {
    employee3 e = {age: 14, name: "rat"};
    e.ssn = "234-56-1234:employee";
    eq:closedPerson p = e;
    return p.ssn;
}

function testEqOfPublicStructs2() returns string {
    eq2:closedEmployee e = {age: 14, name: "rat"};
    e.ssn = "234-56-3345:employee";
    eq:closedPerson p = e;
    return p.ssn;
}

type userA record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "";
|};

type userB record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "";
|};

type userFoo record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "23468";
|};

function testRuntimeEqPrivateStructsInSamePackage() returns string|error {
    userFoo uFoo = {age: 10, name: "ttt", address: "102 Skyhigh street #129, San Jose"};
    userA uA = uFoo;
    userB uB = uA;
    return uB.name;
}

public type userPA record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "";
|};

public type userPB record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "";
|};

public type userPFoo record {|
    int age = 0;
    string name = "";
    string address = "";
    string zipcode = "23468";
|};

function testRuntimeEqPublicStructsInSamePackage() returns string|error {
    userPFoo uFoo = {age: 10, name: "Skyhigh", address: "102 Skyhigh street #129, San Jose"};
    userPA uA = uFoo;
    var uB = checkpanic uA.cloneWithType(userPB);
    return uB.name;
}

function testRuntimeEqPublicStructs() returns string|error {
    req:closedUserPFoo uFoo = {age: 10, name: "Skytop", address: "102 Skyhigh street #129, San Jose"};
    userPA uA = uFoo;
    userPB uB = uA;
    return uB.name;
}

function testRuntimeEqPublicStructs1() returns string|error {
    req:closedUserPFoo uFoo = {age: 10, name: "Brandon", address: "102 Skyhigh street #129, San Jose"};
    userPA uA = uFoo;
    var uB = checkpanic uA.cloneWithType(req2:closedUserPB);
    return uB.name;
}

type Foo record {|
    string a = "";
    string b = "";
    string c = "";
    int d = 0;
    float e = 0.0;
    person1? p = ();
|};

type AnotherFoo record {|
    string c = "";
    string b = "";
    string a = "";
    int d = 0;
    float e = 0.0;
    person1? p = ();
|};

function testRecordEquivalence() returns Foo {
    AnotherFoo af = {a: "A", b: "B", c: "C", d: 10};
    Foo f = af;
    return f;
}

function testUnorderedFieldRecordsInAMatch() returns Foo? {
    AnotherFoo|string aFoo = {a: "A", b: "B", c: "C", d: 10};
    if aFoo is AnotherFoo {
        return aFoo;
    }
    return ();
}

public function main() {
    io:println(testEquivalenceOfPrivateStructsInSamePackage()); // @output 234-56-7890:employee
    io:println(testEquivalenceOfPublicStructsInSamePackage()); // @output 234-56-7890:employee
    io:println(testEqOfPublicStructs()); // @output 234-56-7890:employee
    io:println(testEqOfPublicStructs1()); // @output 234-56-1234:employee
    io:println(testEqOfPublicStructs2()); // @output 234-56-3345:employee
    io:println(testRuntimeEqPrivateStructsInSamePackage()); // @output ttt
    io:println(testRuntimeEqPublicStructsInSamePackage()); // @output Skyhigh
    io:println(testRuntimeEqPublicStructs()); // @output Skytop
    io:println(testRuntimeEqPublicStructs1()); // @output Brandon
    Foo recordEquivalence = testRecordEquivalence();
    io:println(recordEquivalence.keys().length()); // @output 6
    io:println(recordEquivalence.a); // @output A
    io:println(recordEquivalence.b); // @output B
    io:println(recordEquivalence.c); // @output C
    io:println(recordEquivalence.d); // @output 10
    io:println(recordEquivalence.e); // @output 0.0
    io:println(recordEquivalence.p); // @output
    Foo? unordered = testUnorderedFieldRecordsInAMatch();
    if unordered is Foo {
        io:println(unordered.keys().length()); // @output 6
        io:println(unordered.a); // @output A
        io:println(unordered.b); // @output B
        io:println(unordered.c); // @output C
        io:println(unordered.d); // @output 10
        io:println(unordered.e); // @output 0.0
        io:println(unordered.p); // @output
    }
}
