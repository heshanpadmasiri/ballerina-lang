function testMapConstrainedStringNonExistingKeyRetrieve() returns string? {
    map<string> testMap = {};
    return testMap.get("nonexist-key"); // @panic
}

public function main() {
    _ = testMapConstrainedStringNonExistingKeyRetrieve();
}
