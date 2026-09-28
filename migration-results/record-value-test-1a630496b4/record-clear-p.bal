type Person record {
    string name = "John";
    int age = 30;
    string spouse?;
};

function getDefaultPerson() returns Person {
    return {};
}

public function main() {
    Person person = getDefaultPerson();
    person.removeAll(); // @panic
}
