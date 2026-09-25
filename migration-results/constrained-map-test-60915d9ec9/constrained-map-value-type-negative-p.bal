function testConstrainedMapValueTypeNegative() returns string {
    map<string> testMap = {name: "kevin"};
    string val = testMap.get("names"); // @panic
    return val;
}

public function main() {
    _ = testConstrainedMapValueTypeNegative();
}
