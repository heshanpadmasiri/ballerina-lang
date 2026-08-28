type Person1 record {
    string name;
    int age;
};

type AnotherPerson1 record {|
    string name;
    int age;
|};

function testClosedToClosedAssignment1() returns AnotherPerson1 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson1 ap = p; // @error
    return ap;
}

type AnotherPerson2 record {|
    string name;
    int|float age;
|};

function testClosedToClosedAssignment2() returns AnotherPerson2 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson2 ap = p; // @error
    return ap;
}

type AnotherPerson3 record {|
    string name;
    int age;
    float weight?;
|};

function testClosedToClosedAssignment3() returns AnotherPerson3 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson3 ap = p; // @error
    return ap;
}

type AnotherPerson4 record {|
    string name;
    int age?;
|};

function testReqFieldToOptField() returns AnotherPerson4 {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p; // @error
    return ap;
}

type Person2 record {
    string name;
    int age?;
};

function testOptFieldToOptField() returns AnotherPerson4 {
    Person2 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p; // @error
    return ap;
}
