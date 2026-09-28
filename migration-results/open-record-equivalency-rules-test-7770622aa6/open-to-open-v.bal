import ballerina/io;

type Person1 record {
    string name;
    int age;
};

type AnotherPerson1 record {
    string name;
    int age;
};

function testOpenToOpenAssignment1() returns AnotherPerson1 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson1 ap = p;
    return ap;
}

type AnotherPerson2 record {
    string name;
    int|float age;
};

function testOpenToOpenAssignment2() returns AnotherPerson2 {
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

type Person2 record {
    string name;
    int age?;
};

function testOptFieldToOptField1() returns AnotherPerson4 {
    Person2 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p;
    return ap;
}

type Foo record {|
    string s;
    string|int...;
|};

type Bar record {|
    string s;
    string|int|float...;
|};

function testRestFieldToRestField1() returns Bar {
    Foo f = {s: "qwerty", "rest1": "asdf", "rest2": 123};
    Bar b = f;
    return b;
}

type Person3 record {
    string name;
    int age;
    string address;
    float weight?;
};

function testAdditionalFieldsToRest() returns AnotherPerson1 {
    Person3 p = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka", weight: 70.0};
    AnotherPerson1 ap = p;
    return ap;
}

public type OpenPublicPerson record {
    string name;
    int age;
    string address;
};

function testHeterogeneousTypedescEq3() returns AnotherPerson1 {
    OpenPublicPerson p = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka"};
    AnotherPerson1 ap = p;
    return ap;
}

function testHeterogeneousTypedescEq4() returns AnotherPerson1 {
    OpenPublicPerson op = {name: "John Doe", age: 25, address: "Colombo, Sri Lanka"};
    AnotherPerson1 p = op;
    return p;
}

public function main() {
    io:println(testOpenToOpenAssignment1()); // @output {"name":"John Doe","age":25}
    io:println(testOpenToOpenAssignment2()); // @output {"name":"John Doe","age":25}
    io:println(testReqFieldToOptField()); // @output {"name":"John Doe","age":25}
    io:println(testOptFieldToOptField1()); // @output {"name":"John Doe","age":25}
    io:println(testAdditionalFieldsToRest()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka","weight":70.0}
    io:println(testRestFieldToRestField1()); // @output {"s":"qwerty","rest1":"asdf","rest2":123}
    io:println(testHeterogeneousTypedescEq3()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka"}
    io:println(testHeterogeneousTypedescEq4()); // @output {"name":"John Doe","age":25,"address":"Colombo, Sri Lanka"}
}
