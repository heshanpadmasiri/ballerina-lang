public type Person record {
    string name = "";
    int age = 0;
};

function uninitAccess() {
    Person p;
    string name = p.name;
    name = p["name"] ?: ""; // @error

    p.age = 25;
    p["age"] = 30;

    Person p1 = getUninitializedRecord11(p);

    Person p2 = getUninitializedRecord21();
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
    return p4;
}
