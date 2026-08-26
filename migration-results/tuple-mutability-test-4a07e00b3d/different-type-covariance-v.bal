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

Employee employee1 = {name: "John", intern: true};
Intern intern1 = {name: "John", intern: true, salary: 100};

public function main() {
    [Employee, Employee] tuple = [employee1, employee1];
    [Employee, Person] tuple2 = tuple;
    [int, Intern, Intern] tuple3 = [12, intern1, intern1];
    [int|string, Person, Employee] tuple4 = tuple3;
    tuple4[0] = 12;
    tuple4[1] = intern1;
    tuple4[2] = intern1;
    int|string result = tuple4[0];
    io:println(result is int ? result : 0);
}

// @output 12
