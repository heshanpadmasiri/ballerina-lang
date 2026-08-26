import ballerina/io;

type Person record {
    string name;
};

type Employee record {
    string name;
    boolean intern;
};

type Intern record {|
    string name;
    boolean intern;
    int salary;
|};

Person person1 = {name: "John"};
Employee employee1 = {name: "John", intern: true};
Intern intern1 = {name: "John", intern: true, salary: 100};

public function main() {
    [Employee, Employee] employeeTuple = [employee1, employee1];
    [Person, Person] personTuple = employeeTuple;
    personTuple[0] = employee1;
    personTuple[1] = intern1;
    Employee e = <Employee> personTuple[0];
    Intern i = <Intern> personTuple[1];
    io:println(e.intern);
    io:println(i.salary);
}

// @output true
// @output 100
