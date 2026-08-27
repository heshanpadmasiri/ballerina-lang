type PersonAM record { string name = ""; };
type EmployeeAM record { string name = ""; boolean intern = false; };
type InternAM record {| string name = ""; boolean intern = false; int salary = 0; |};

public function main() {
    EmployeeAM[] employees = [];
    PersonAM[] persons = employees;
    EmployeeAM employee = {name: "John", intern: true};
    persons[0] = employee;
    var result = trap <InternAM>persons[0]; // @panic
    if result is error {
        panic result;
    }
}
