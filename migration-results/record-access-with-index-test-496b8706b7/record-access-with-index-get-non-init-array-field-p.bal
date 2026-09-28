type Department record {
    string dptName = "";
    Person[] employees = [];
};

type Person record {
    Family family = {};
};

type Family record {
    string[] children = [];
};

function testGetNonInitArrayAttribute() returns string? {
    Department dpt = {dptName: "HR"};
    return dpt["employees"][0]["family"]["children"][0]; // @panic
}

public function main() {
    _ = testGetNonInitArrayAttribute();
}
