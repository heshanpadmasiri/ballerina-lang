type Person1 record {|
    string name;
|};

type AnotherPerson record {
    string name;
    int age;
};

function testMissingRequiredField1() {
    Person1 p = {name: "John"};
    AnotherPerson ap = p; // @error
}

type Person2 record {|
    string name;
    int age?;
|};

function testMissingRequiredField2() {
    Person2 p = {name: "John"};
    AnotherPerson ap = p; // @error
}

type Person3 record {|
    string name;
    int age;
    map<any> address;
|};

function testMismatchingRestField1() {
    map<any> adr = {};
    Person3 p = {name: "John", age: 25, address: adr};
    AnotherPerson ap = p; // @error
}

type AnotherPerson2 record {
    string name;
    int age;
    float weight?;
};

function testMissingOptionalFieldInRHS1() returns AnotherPerson2 {
    Person1 p = {name: "John Doe"};
    AnotherPerson2 ap = p; // @error
    return ap;
}

function testMissingOptionalFieldInRHS2() {
    Person1 p = {name: "John Doe"};
    AnotherPerson2 ap = p; // @error
    ap.weight = 60.5;
}
