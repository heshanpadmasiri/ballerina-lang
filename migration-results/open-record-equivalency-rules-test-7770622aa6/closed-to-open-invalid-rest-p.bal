type Person1 record {|
    string name;
    int age;
|};

type AnotherPerson2 record {
    string name;
    int|float age;
};

function testClosedToOpenAssignment3() {
    Person1 p = {name: "John Doe", age: 25};
    AnotherPerson2 ap = p;
    ap["rest"] = "foo"; // @panic
}

public function main() {
    testClosedToOpenAssignment3();
}
