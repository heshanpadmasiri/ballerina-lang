import ballerina/io;

type Person1 record {|
    string name;
    int age;
|};

type AnotherPerson1 record {|
    string name;
    int age;
|};

function testClosedToClosedAssignment1() returns AnotherPerson1 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson1 ap = p;
    return ap;
}

type AnotherPerson2 record {|
    string name;
    int|float age;
|};

function testClosedToClosedAssignment2() returns AnotherPerson2 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson2 ap = p;
    return ap;
}

type AnotherPerson4 record {|
    string name;
    int age?;
|};

function testReqFieldToOptField() returns AnotherPerson4 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p;
    return ap;
}

type Person2 record {|
    string name;
    int age?;
|};

function testOptFieldToOptField1() returns AnotherPerson4 {
    Person2 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p;
    return ap;
}

function testOptFieldToOptField2() returns [AnotherPerson4, int?] {
    Person2 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p;

    p = {name: "Jane Doe"};
    AnotherPerson4 ap2 = p;

    return [ap, ap2["age"]];
}

public type PublicPerson record {|
    string name;
    int age;
|};

function testHeterogeneousTypedescEq() returns Person1 {
    PublicPerson p = {name: "John Doe", age: 25};
    Person1 p1 = p;
    return p1;
}

function testHeterogeneousTypedescEq2() returns PublicPerson {
    Person1 p1 = {name: "John Doe", age: 25};
    PublicPerson p = p1;
    return p;
}

public function main() {
    io:println(testClosedToClosedAssignment1()); // @output {"name":"John Doe","age":25}
    io:println(testClosedToClosedAssignment2()); // @output {"name":"John Doe","age":25}
    io:println(testReqFieldToOptField()); // @output {"name":"John Doe","age":25}
    io:println(testOptFieldToOptField1()); // @output {"name":"John Doe","age":25}
    [AnotherPerson4, int?] optFieldResults = testOptFieldToOptField2();
    io:println(optFieldResults[0]); // @output {"name":"John Doe","age":25}
    io:println(optFieldResults[1]); // @output
    io:println(testHeterogeneousTypedescEq()); // @output {"name":"John Doe","age":25}
    io:println(testHeterogeneousTypedescEq2()); // @output {"name":"John Doe","age":25}
}
