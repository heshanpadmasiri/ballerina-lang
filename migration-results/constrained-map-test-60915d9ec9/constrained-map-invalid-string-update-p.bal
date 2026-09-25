function testStringMapUpdateWithInvalidTypeNegativeCase() returns string {
    map<string> testMap = {};
    map<any> m = updateGenericMapDifferentType(testMap);
    map<string> castMap = <map<string>>m;
    return <string>castMap["item"];
}

function updateGenericMapDifferentType(map<any> m) returns map<any> {
    m["item"] = 1; // @panic
    return m;
}

public function main() {
    _ = testStringMapUpdateWithInvalidTypeNegativeCase();
}
