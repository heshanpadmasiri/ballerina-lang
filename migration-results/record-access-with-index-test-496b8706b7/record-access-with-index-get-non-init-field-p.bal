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

function testGetNonInitAttribute() returns string? {
    Person emp1 = {};
    Person emp2 = {};
    Department dpt = {dptName: "HR", employees: [emp1, emp2]};
    return dpt["employees"][0]["family"]["children"][0]; // @panic
}

public function main() {
    _ = testGetNonInitAttribute();
}
