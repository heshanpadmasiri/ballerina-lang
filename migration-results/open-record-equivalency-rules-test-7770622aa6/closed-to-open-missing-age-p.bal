type AnotherPerson4 record {
    string name;
    int age?;
};

type Person2 record {|
    string name;
    int age?;
|};

function testOptFieldToOptField2() returns [AnotherPerson4, anydata] {
    Person2 p = {name: "John Doe", age: 25};
    AnotherPerson4 ap = p;

    p = {name: "Jane Doe"};
    AnotherPerson4 ap2 = p;

    return [ap, ap2.get("age")]; // @panic
}

public function main() {
    _ = testOptFieldToOptField2();
}
