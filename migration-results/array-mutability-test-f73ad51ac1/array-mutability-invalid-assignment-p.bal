type PersonAM record { string name = ""; };
type EmployeeAM record { string name = ""; boolean intern = false; };
type StudentAM record {| string name = ""; int studentId = 0; |};

public function main() {
    EmployeeAM[] employees = [];
    PersonAM[] persons = employees;
    StudentAM student = {name: "John", studentId: 1};
    persons[1] = student; // @panic
}
