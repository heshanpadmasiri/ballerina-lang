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

function testGetNonInitArrayAttribute() returns string? {
    Department dpt = {dptName: "HR"};
    return dpt["employees"][0]["family"]["children"][0]; // @panic
}

public function main() {
    _ = testGetNonInitArrayAttribute();
}
