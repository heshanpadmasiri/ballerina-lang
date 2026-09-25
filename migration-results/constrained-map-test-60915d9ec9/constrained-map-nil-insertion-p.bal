function testInherentTypeViolationWithNilType() {
    map<string> m = {one: "one"};
    insertNilToMap(m);
}

function insertNilToMap(map<any> m) {
    m["two"] = (); // @panic
}

public function main() {
    testInherentTypeViolationWithNilType();
}
