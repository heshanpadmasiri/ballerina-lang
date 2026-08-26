type Person record {
    string name;
};

type Employee record {
    string name;
    boolean intern;
};

Person person1 = {name: "John"};
Employee employee1 = {name: "John", intern: true};

public function main() {
    [Employee, Employee] employeeTuple = [employee1, employee1];
    [Person, Person] personTuple = employeeTuple;
    personTuple[0] = person1; // @panic error: {ballerina/lang.array}InherentTypeViolation {"message":"incompatible types: expected 'Employee', found 'Person'"}
}
