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

function testGetNonInitLastAttribute() returns PersonSt {
    DepartmentSt dpt = {};
    return dpt.employees[0]; // @panic
}

public function main() {
    PersonSt _ = testGetNonInitLastAttribute();
}
