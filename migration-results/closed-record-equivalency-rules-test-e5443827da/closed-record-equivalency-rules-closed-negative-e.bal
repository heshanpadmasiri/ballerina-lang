type AnotherPerson record {|
    string name;
    int age;
|};

type Person1 record {|
    string name;
|};

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

type AnotherPerson3 record {|
    string name;
    float weight?;
|};

function testClosedToClosedAssignment1() returns AnotherPerson3 {
    Person1 p = {name: "John Doe"};
    AnotherPerson3 ap = p;
    return ap;
}

function testClosedToClosedAssignment2() {
    Person1 p = {name: "John Doe"};
    AnotherPerson3 ap = p;
    ap.weight = 60.5;
}
