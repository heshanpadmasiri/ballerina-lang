type Person1 record {
    string name;
};

type AnotherPerson record {
    string name;
    int age;
};

function testMissingRequiredField1() {
    Person1 p = {name: "John"};
    AnotherPerson ap = p; // @error
}

type Person2 record {
    string name;
    int age?;
};

function testMissingRequiredField2() {
    Person2 p = {name: "John"};
    AnotherPerson ap = p; // @error
}

type Person3 record {
    string name;
    int age;
    map<any> address;
};

function testMismatchingRestField1() {
    map<any> adr = {};
    Person3 p = {name: "John", age: 25, address: adr};
    AnotherPerson ap = p; // @error
}

type Person4 record {|
    string name;
    int age;
    any...;
|};

function testMismatchingRestField2() {
    Person4 p = {name: "John", age: 25};
    AnotherPerson ap = p; // @error
}

type AnotherPerson2 record {
    string name;
    int age;
    float weight?;
};

function testMissingOptFieldInRHS() returns AnotherPerson2 {
    Person1 p = {name: "John Doe"};
    AnotherPerson2 ap = p; // @error
    return ap;
}
