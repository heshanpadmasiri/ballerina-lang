function testMapRemoveNegative() {
    map<any> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    _ = namesMap.remove("fname2"); // @panic
}

public function main() {
    testMapRemoveNegative();
}
