function testMapJsonToJsonArray() {
    json[] j = [2];
    map<json>[] p = <map<json>[]>j; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: 'json[]' cannot be cast to 'map<json>[]'"}
}

public function main() {
    () ignored = testMapJsonToJsonArray();
}
