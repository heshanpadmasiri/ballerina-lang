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
    var res = from var person in personList // @error unused variable 'person'
              from var emp in (from var {
                  firstName,
                  lastName, // @error unused variable 'lastName'
                  dept // @error unused variable 'dept'
              } in employeeList select msg + " " + firstName)
              select emp;
    return res;
}

function foo2() returns string[] {
    string msg = "hello";
    var res = from var person in personList // @error unused variable 'person'
              from var emp in (from var {
                  firstName,
                  lastName, // @error unused variable 'lastName'
                  dept // @error unused variable 'dept'
              } in employeeList select msg + " " + firstName)
              select emp;
    return res;
}

function foo3(string msg) returns string[] {
    var res = from var person in personList // @error unused variable 'person'
              from var emp in (from var {
                  firstName,
                  lastName,
                  dept // @error unused variable 'dept'
              } in employeeList
              where lastName == msg select firstName + " " + lastName)
              select emp;
    return res;
}

function foo4(string msg) returns string [] {
    var res = from var person in personList // @error unused variable 'person'
              from var emp in (from var {
                  firstName, // @error unused variable 'firstName'
                  lastName,
                  dept // @error unused variable 'dept'
              } in employeeList
              where msg != lastName select msg + " " + lastName)
              select emp;
    return res;
}

function foo5(string msg) returns string[] {
     var res = from var y in (from var person in personList // @error unused variable 'person'
        from var x in (from var {
            firstName,
            lastName,
            dept // @error unused variable 'dept'
        } in employeeList
        where lastName == msg select firstName + " " + lastName)
        select x) select y;

     return res;
}
