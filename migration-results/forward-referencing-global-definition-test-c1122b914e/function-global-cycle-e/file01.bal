public type Person record {
    string name = "";
    int age = 0;
};

Person fromFuncA = fromFunc; // @error
Person fromFunc = getPersonOuter();

function getPersonInner() returns Person {
    return getfromFuncA();
}

function getPersonOuter() returns Person {
    return getPersonInner();
}

function getfromFuncA() returns Person {
    return fromFuncA;
}

Person person = {
    name: "Sumedha",
    age: 30
};

function mutRecA() returns int {
    return mutRecB();
}

function mutRecB() returns int {
    return mutRecA();
}
