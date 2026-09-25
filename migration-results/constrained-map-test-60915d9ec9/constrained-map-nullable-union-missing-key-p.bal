function testMapConstrainedToNullableUnionNonExistingKey() returns string? {
    map<string?> testMap = {};
    return testMap.get("nonexist"); // @panic
}

public function main() {
    _ = testMapConstrainedToNullableUnionNonExistingKey();
}
