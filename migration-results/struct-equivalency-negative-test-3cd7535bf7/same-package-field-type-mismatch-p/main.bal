public type person02 record {
    int age = 0;
    string name = "";
    string address = "";
};

public type employee02 record {
    int age = 0;
    string name = "";
    int address = 0;
};

function testEqOfStructsInSamePackage02() returns string {
    employee02 e = {age: 14, name: "rat"};
    person02 p = checkpanic e.cloneWithType(person02); // @panic
    return p.name;
}

public function main() {
    string _ = testEqOfStructsInSamePackage02();
}
