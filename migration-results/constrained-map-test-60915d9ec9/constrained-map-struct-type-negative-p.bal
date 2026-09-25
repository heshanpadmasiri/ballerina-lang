type PersonCM record {| string name; int age; string address = ""; |};

function testConstrainedMapStructTypeNegative() returns PersonCM {
    map<PersonCM> testMap = {};
    PersonCM jack = {name: "Jack", age: 25};
    testMap["item"] = jack;
    PersonCM val = testMap.get("item-not"); // @panic
    return val;
}

public function main() {
    _ = testConstrainedMapStructTypeNegative();
}
