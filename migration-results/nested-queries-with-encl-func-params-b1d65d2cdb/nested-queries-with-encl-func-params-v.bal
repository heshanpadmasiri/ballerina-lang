import ballerina/io;

function retainIoImport() {
    io:println();
}

type Person record {|
    string firstName;
    string lastName;
    int age;
|};

type Employee record {|
    string firstName;
    string lastName;
    string dept;
|};

Person p1 = {firstName: "Alex", lastName: "George", age: 23};
Person p2 = {firstName: "Ranjan", lastName: "Fonseka", age: 30};
Person p3 = {firstName: "John", lastName: "David", age: 33};

Person[] personList = [p1, p2, p3];

Employee e1 = {firstName: "Alex", lastName: "George", dept: "Engineering"};
Employee e2 = {firstName: "John", lastName: "David", dept: "HR"};
Employee e3 = {firstName: "Alex", lastName: "Fonseka", dept: "Operations"};

Employee[] employeeList = [e1, e2, e3];

function foo1(string msg) returns string[] {
    var res = from var _ in personList
              from var emp in (from var {firstName} in employeeList select msg + " " + firstName)
              select emp;
    return res;
}

public function testFuncParams1() {
    string[] expected = ["Hello Alex","Hello John","Hello Alex","Hello Alex","Hello John","Hello Alex","Hello Alex",
                        "Hello John","Hello Alex"];
    assertEquality(expected, foo1("Hello"));
}

function foo2() returns string[] {
    string msg = "hello";
    var res = from var _ in personList
              from var emp in (from var {firstName} in employeeList select msg + " " + firstName)
              select emp;
    return res;
}

public function testFuncParams2() {
    string[] expected = ["hello Alex","hello John","hello Alex","hello Alex","hello John","hello Alex","hello Alex",
        "hello John","hello Alex"];
    assertEquality(expected, foo2());
}

function foo3(string msg) returns string[] {
    var res = from var _ in personList
              from var emp in (from var {firstName, lastName} in employeeList
              where lastName == msg select firstName + " " + lastName)
              select emp;
    return res;
}

public function testFuncParams3() {
    string[] expected = ["Alex George","Alex George","Alex George"];
    assertEquality(expected, foo3("George"));
}

function foo4(string msg) returns string [] {
    var res = from var _ in personList
              from var emp in (from var {lastName} in employeeList
              where msg != lastName select msg + " " + lastName)
              select emp;
    return res;
}

public function testFuncParams4() {
    string[] expected = ["George David","George Fonseka","George David","George Fonseka","George David",
        "George Fonseka"];
    assertEquality(expected, foo4("George"));
}

function foo5(string msg) returns string[] {
     var res = from var y in (from var _ in personList
        from var x in (from var {firstName, lastName} in employeeList
        where lastName == msg select firstName + " " + lastName)
        select x) select y;

     return res;
}

public function testFuncParams5() {
    string[] expected = ["Alex George","Alex George","Alex George"];
    assertEquality(expected, foo5("George"));
}

type Person2 record {
    string name;
    string[] houses;
};

public function testFunc6() {
    Person2[] people = [{name: "John", houses: ["House 1", "House 2"]},
                              {name: "Jane", houses: ["House 3"]},
                              {name: "Doe", houses: []}];

    string[] result = from var person in people
        let string[] ownedHouses = from var house in person.houses
            select house
        where ownedHouses.length() > 0
        select person.name;

    assertEquality(2, result.length());
    assertEquality("John", result[0]);
    assertEquality("Jane", result[1]);
}

public function testFunc7() {
    Person2[] people = [];

    string[] result = from var person in people
        let string[] ownedHouses = from var house in person.houses
            select house
        where ownedHouses.length() > 0
        select person.name;
    assertEquality(0, result.length());
}

type House record {|
    string address;
    boolean owner;
|};

type Person3 record {
    string name;
    int age;
    House[] houses;
};

type HomeOwner record {|
    string name;
    string primaryAddress;
|};

isolated function selectHomeOwners(Person3[] people)
    returns HomeOwner[] => (
    from var person in people
        where person.age >= 18

        let string[] ownedHouses = from var house in person.houses
            where house.owner
            select house.address
        where ownedHouses.length() > 0

        select {
            name: person.name,
            primaryAddress: ownedHouses[0]
        }
);

public function testFunc8() {
    Person3[] people = [
        {name:"Mark", age:14, houses:[]},
        {name:"Watson", age:40, houses:[{address:"221B Baker Street", owner:false}]},
        {name:"Walter", age:23, houses:[{address:"308 Negra Arroyo Lane", owner: true}]}
    ];

    HomeOwner[] homeOwners = selectHomeOwners(people);

    assertEquality(1, homeOwners.length());
    assertEquality("Walter", homeOwners[0].name);
}

public function main() {
    testFuncParams1();
    testFuncParams2();
    testFuncParams3();
    testFuncParams4();
    testFuncParams5();
    testFunc6();
    testFunc7();
    testFunc8();
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
                      message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
