type PersonAM record { string name = ""; };
type EmployeeAM record { string name = ""; boolean intern = false; };

public function main() {
    EmployeeAM[] employees = [];
    PersonAM[] persons = employees;
    PersonAM person = {name: "John"};
    persons[1] = person; // @panic
}
