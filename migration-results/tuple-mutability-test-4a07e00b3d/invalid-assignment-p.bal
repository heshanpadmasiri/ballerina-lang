type Person record {
    string name;
};

type Employee record {
    string name;
    boolean intern;
};

type Student record {|
    string name;
    int studentId;
|};

Person person1 = {name: "John"};
Employee employee1 = {name: "John", intern: true};
Student student1 = {name: "John", studentId: 1};

public function main() {
    [Employee, Employee] employeeTuple = [employee1, employee1];
    [Person, Person] personTuple = employeeTuple;
    personTuple[0] = student1; // @panic error: {ballerina/lang.array}InherentTypeViolation {"message":"incompatible types: expected 'Employee', found 'Student'"}
}
