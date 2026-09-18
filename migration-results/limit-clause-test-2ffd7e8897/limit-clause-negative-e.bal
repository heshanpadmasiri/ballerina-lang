type Person record {|
    string firstName;
    string lastName;
    int age;
|};

type FullName record {|
    string firstName;
    string lastName;
|};

function checkAge(int age) returns boolean {
    return age == 35;
}

function invalidQueryExpression() returns Person[] {
    Person[] persons = [{firstName: "Alex", lastName: "George", age: 23}];
    Person[] result = from var person in persons
        limit checkAge(33) // @error
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    return result;
}

function queryExpressionNegativeLimit() returns Person[] {
    Person[] persons = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    Person[] result = from var person in persons
        limit -1
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    return result;
}

function invalidQueryAction() {
    Person[] persons = [{firstName: "Alex", lastName: "George", age: 23}];
    FullName[] names = [];
    var ignored = from var person in persons
        limit checkAge(33) // @error
        do {
            names.push({firstName: person.firstName, lastName: person.lastName});
        };
}

function queryActionNegativeLimit() returns FullName[] {
    Person[] persons = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    FullName[] names = [];
    var ignored = from var person in persons
        limit -1
        do {
            names.push({firstName: person.firstName, lastName: person.lastName});
        };
    return names;
}

function clauseAfterSelect() {
    Person[] persons = [{firstName: "Alex", lastName: "George", age: 23}];
    Person[] ignored = from var person in persons
        select {firstName: person.firstName, lastName: person.lastName, age: person.age}
        limit 2; // @error
}
