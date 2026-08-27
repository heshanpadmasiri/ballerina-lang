import ballerina/io;

type PersonAM record { string name = ""; };
type EmployeeAM record { string name = ""; boolean intern = false; };
type InternAM record {| string name = ""; boolean intern = false; int salary = 0; |};

PersonAM[] personArray = [];
EmployeeAM[] employeeArray = [];
EmployeeAM employee1 = {name: "John", intern: true};
InternAM intern1 = {name: "John", intern: true, salary: 100};

function testValidArrayAssignment() returns [boolean, int] {
    personArray = employeeArray;
    personArray[0] = employee1;
    personArray[1] = intern1;
    EmployeeAM employee = <EmployeeAM>personArray[0];
    InternAM intern = <InternAM>personArray[1];
    return [employee.intern, intern.salary];
}

function testUnionOfArrays() returns string {
    boolean[] boolArray = [true, true];
    int[]|boolean[] arrays = boolArray;
    if arrays is int[] {
        return "INT";
    }
    return "BOOL";
}

public function main() {
    [boolean, int] assignment = testValidArrayAssignment();
    io:println(assignment[0]); // @output true
    io:println(assignment[1]); // @output 100
    io:println(testUnionOfArrays()); // @output BOOL
}
