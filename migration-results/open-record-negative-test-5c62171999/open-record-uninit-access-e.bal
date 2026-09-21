public type Person record {
    string name = "";
    int age = 0;
};

function uninitAccess() {
    Person p;
    string name = p.name; // @error @error
    name = "";

    p.age = 25; // @error
    p["age"] = 30; // @error

    Person _ = getUninitializedRecord11(p); // @error

    Person _ = getUninitializedRecord21();
}

function getUninitializedRecord11(Person p) returns Person {
    Person p2 = getUninitializedRecord12(p);
    return p2;
}

function getUninitializedRecord12(Person p) returns Person {
    Person p2 = p;
    return p2;
}

function getUninitializedRecord21() returns Person {
    Person p3 = getUninitializedRecord22();
    return p3;
}

function getUninitializedRecord22() returns Person {
    Person p4;
    return p4; // @error
}
