public type person03 record {
    int age = 0;
    string name = "";
    string address;
};

public type employee03 record {
    int age = 0;
    string name = "";
};

function testEqOfStructsInSamePackage03() returns string {
    employee03 e = {age: 14, name: "rat"};
    person03 p = checkpanic e.cloneWithType(person03); // @panic
    return p.name;
}

public function main() {
    string _ = testEqOfStructsInSamePackage03();
}
