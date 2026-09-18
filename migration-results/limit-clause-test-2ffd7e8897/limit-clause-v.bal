import ballerina/io;

type Person record {|
    string firstName;
    string lastName;
    int age;
|};

type FullName record {|
    string firstName;
    string lastName;
|};

type Employee record {|
    string firstName;
    string lastName;
    string dept;
|};

type EmpProfile record {|
    string firstName;
    string lastName;
    int age;
    string dept;
    string status;
|};

type EmpProfileValue record {|
    EmpProfile value;
|};

function getEmpProfileValue((record {| EmpProfile value; |}|error?)|(record {| EmpProfile value; |}?) returnedVal)
        returns EmpProfileValue? {
    var result = returnedVal;
    if result is EmpProfileValue {
        return result;
    }
    return ();
}

function testLimitClauseWithQueryExpr() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 33},
        {firstName: "Ranjan", lastName: "Fonseka", age: 33},
        {firstName: "John", lastName: "David", age: 35},
        {firstName: "Max", lastName: "Gomaz", age: 33}
    ];
    return from var person in personList
        let int newAge = 34
        where person.age == 33
        limit 2
        select {firstName: person.firstName, lastName: person.lastName, age: newAge};
}

function testLimitClauseWithQueryExpr2() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 33},
        {firstName: "Ranjan", lastName: "Fonseka", age: 31},
        {firstName: "John", lastName: "David", age: 35}
    ];
    return from var person in personList
        limit 4
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
}

function testLimitClauseWithQueryExpr3() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 33},
        {firstName: "Ranjan", lastName: "Fonseka", age: 31},
        {firstName: "John", lastName: "David", age: 35}
    ];
    return from var person in personList
        limit 3
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
}

function testLimitClauseReturnStream() returns boolean {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 33},
        {firstName: "Ranjan", lastName: "Fonseka", age: 31}
    ];
    Employee[] employeeList = [
        {firstName: "Alex", lastName: "George", dept: "Engineering"},
        {firstName: "John", lastName: "David", dept: "HR"},
        {firstName: "Alex", lastName: "Fonseka", dept: "Operations"}
    ];
    stream<EmpProfile> profiles = stream from var person in personList.toStream()
        from var emp in employeeList
        let string status = "Permanent"
        where emp.firstName == "Alex"
        limit 1
        select {firstName: emp.firstName, lastName: emp.lastName, age: person.age, dept: emp.dept, status};
    record {| EmpProfile value; |}? first = getEmpProfileValue(profiles.next());
    return first?.value?.firstName == "Alex" && first?.value?.lastName == "George" &&
        first?.value?.age == 33 && first?.value?.dept == "Engineering" &&
        first?.value?.status == "Permanent" && getEmpProfileValue(profiles.next()) == ();
}

function testLimitClauseWithQueryAction() returns int {
    int count = 0;
    error? ignored = from var value in [1, 2, 3, 4, 5]
        limit 3
        do {
            count += value;
        };
    return count;
}

function testLimitClauseWithQueryAction2() returns FullName[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 22},
        {firstName: "John", lastName: "David", age: 33}
    ];
    FullName[] nameList = [];
    error? ignored = from var person in personList
        let int twiceAge = person.age * 2
        limit 1
        do {
            if twiceAge < 50 {
                nameList.push({firstName: person.firstName, lastName: person.lastName});
            }
        };
    return nameList;
}

function testLimitClauseWithQueryAction3() returns FullName[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 22}
    ];
    FullName[] nameList = [];
    error? ignored = from var person in personList
        limit 3
        do {
            nameList.push({firstName: person.firstName, lastName: person.lastName});
        };
    return nameList;
}

function testLimitClauseWithQueryAction4() returns FullName[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 22}
    ];
    FullName[] nameList = [];
    error? ignored = from var person in personList
        limit 2
        do {
            nameList.push({firstName: person.firstName, lastName: person.lastName});
        };
    return nameList;
}

public function main() {
    Person[] queryExpr = testLimitClauseWithQueryExpr();
    io:println(queryExpr.length()); // @output 2
    io:println(queryExpr[0].firstName); // @output Alex
    io:println(queryExpr[1].lastName); // @output Fonseka
    io:println(queryExpr[1].age); // @output 34

    Person[] queryExpr2 = testLimitClauseWithQueryExpr2();
    io:println(queryExpr2.length()); // @output 3
    io:println(queryExpr2[0].firstName); // @output Alex
    io:println(queryExpr2[1].lastName); // @output Fonseka
    io:println(queryExpr2[2].age); // @output 35

    Person[] queryExpr3 = testLimitClauseWithQueryExpr3();
    io:println(queryExpr3.length()); // @output 3
    io:println(queryExpr3[0].firstName); // @output Alex
    io:println(queryExpr3[1].lastName); // @output Fonseka
    io:println(queryExpr3[2].age); // @output 35

    io:println(testLimitClauseReturnStream()); // @output true
    io:println(testLimitClauseWithQueryAction()); // @output 6

    FullName[] queryAction2 = testLimitClauseWithQueryAction2();
    io:println(queryAction2.length()); // @output 1
    io:println(queryAction2[0].firstName); // @output Alex
    io:println(queryAction2[0].lastName); // @output George

    FullName[] queryAction3 = testLimitClauseWithQueryAction3();
    io:println(queryAction3.length()); // @output 2
    io:println(queryAction3[0].firstName); // @output Alex
    io:println(queryAction3[1].lastName); // @output Fonseka

    FullName[] queryAction4 = testLimitClauseWithQueryAction4();
    io:println(queryAction4.length()); // @output 2
    io:println(queryAction4[0].firstName); // @output Alex
    io:println(queryAction4[1].lastName); // @output Fonseka
}
