type DepartmentSt record {
    string dptName = "";
    PersonSt[] employees = [];
};

type PersonSt record {
    FamilySt family = {};
};

type FamilySt record {
    string[] children = [];
};

function testGetNonInitAttribute() returns string {
    PersonSt emp1 = {};
    PersonSt emp2 = {};
    PersonSt[] emps = [emp1, emp2];
    DepartmentSt dpt = {dptName:"HR", employees:emps};
    return dpt.employees[0].family.children[0]; // @panic
}

public function main() {
    string _ = testGetNonInitAttribute();
}
