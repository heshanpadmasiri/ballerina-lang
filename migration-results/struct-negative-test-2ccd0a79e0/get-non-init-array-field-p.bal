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

function testGetNonInitArrayAttribute() returns string {
    DepartmentSt dpt = {dptName:"HR"};
    return dpt.employees[0].family.children[0]; // @panic
}

public function main() {
    string _ = testGetNonInitArrayAttribute();
}
