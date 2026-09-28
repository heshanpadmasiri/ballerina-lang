type Department record {
    string dptName = "";
    PersonSE[] employees = [];
};

type PersonSE record {
    FamilySE family = {};
};

type FamilySE record {
    string[] children = [];
};

function testGetNonInitAttribute() returns string? {
    PersonSE emp1 = {};
    PersonSE emp2 = {};
    Department dpt = {dptName: "HR", employees: [emp1, emp2]};
    return dpt["employees"][0]["family"]["children"][0]; // @panic
}

public function main() {
    _ = testGetNonInitAttribute();
}
