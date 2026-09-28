type Department record {
    Person[] employees = [];
};

type Person record {};

function testGetNonInitLastAttribute() returns Person? {
    Department dpt = {};
    return dpt["employees"][0]; // @panic
}

public function main() {
    _ = testGetNonInitLastAttribute();
}
