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

public function main() {
    [Employee, Employee] employeeTuple = [employee1, employee1];
    [Person, Person] personTuple = employeeTuple;
    personTuple[0] = employee1;
    Intern e = <Intern> personTuple[0]; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: 'Employee' cannot be cast to 'Intern'"}
}
