function testMapConstrainedToUnionCaseThree() returns string|int? {
    map<string|int> testMap = {};
    return testMap.get("non-existing-key"); // @panic
}

public function main() {
    _ = testMapConstrainedToUnionCaseThree();
}
