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

function testGetNonInitLastAttribute() returns PersonSE? {
    Department dpt = {};
    return dpt["employees"][0]; // @panic
}

public function main() {
    _ = testGetNonInitLastAttribute();
}
