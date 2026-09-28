type person06 record {
    int age = 0;
    string name = "";
    int address = 0;
    string id = "";
};

type employee06 record {
    int age = 0;
    string name = "";
    string address = "";
    string id = "";
    string ssn = "";
};

function testEqOfStructsInSamePackage06() returns string {
    employee06 e = {age: 14, name: "rat"};
    person06 p = checkpanic e.cloneWithType(person06); // @panic
    return p.name;
}

public function main() {
    string _ = testEqOfStructsInSamePackage06();
}
