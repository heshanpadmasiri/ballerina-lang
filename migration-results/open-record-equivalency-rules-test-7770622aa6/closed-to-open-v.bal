import ballerina/io;

type Person1 record {|
    string name;
    int age;
|};

type AnotherPerson1 record {
    string name;
    int age;
};

function testClosedToOpenAssignment1() returns AnotherPerson1 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson1 ap = p;
    return ap;
}

type AnotherPerson2 record {
    string name;
    int|float age;
};

function testClosedToOpenAssignment2() returns AnotherPerson2 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson2 ap = p;
    return ap;
}

type AnotherPerson4 record {
    string name;
    int age?;
};

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

type Person3 record {|
    string name;
    int age;
    string address;
    float weight?;
|};

function testAdditionalFieldsToRest() returns AnotherPerson1 {
    Person3 p = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka", weight: 70.0};
    AnotherPerson1 ap = p;
    return ap;
}

public type PublicPerson record {|
    string name;
    int age;
    string address;
|};

function testHeterogeneousTypedescEq() returns AnotherPerson1 {
    PublicPerson p = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka"};
    AnotherPerson1 ap = p;
    return ap;
}

public type OpenPublicPerson record {
    string name;
    int age;
    string address;
};

function testHeterogeneousTypedescEq2() returns OpenPublicPerson {
    Person3 p = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka", weight: 70.0};
    OpenPublicPerson p1 = p;
    return p1;
}

public function main() {
    io:println(testClosedToOpenAssignment1()); // @output {"name":"John Doe","age":25}
    io:println(testClosedToOpenAssignment2()); // @output {"name":"John Doe","age":25}
    io:println(testReqFieldToOptField()); // @output {"name":"John Doe","age":25}
    io:println(testOptFieldToOptField1()); // @output {"name":"John Doe","age":25}
    io:println(testAdditionalFieldsToRest()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka","weight":70.0}
    io:println(testHeterogeneousTypedescEq()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka"}
    io:println(testHeterogeneousTypedescEq2()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka","weight":70.0}
}
