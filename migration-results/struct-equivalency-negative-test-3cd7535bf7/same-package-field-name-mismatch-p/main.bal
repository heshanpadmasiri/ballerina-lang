public type person01 record {
    int age = 0;
    string name = "";
    string address;
};

public type employee01 record {
    int age = 0;
    string name = "";
    string zipcode = "95134";
};

function testEqOfStructsInSamePackage01() returns string {
    employee01 e = {age: 14, name: "rat"};
    person01 p = checkpanic e.cloneWithType(person01); // @panic
    return p.name;
}

public function main() {
    string _ = testEqOfStructsInSamePackage01();
}
