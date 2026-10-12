function testGetArrayOutofBoundElement() returns string {
    json j = [1, 2, 3];
    json[] ja = <json[]>j;
    string value;
    value = <string>ja[5]; // @panic error: {ballerina/lang.array}IndexOutOfRange {"message":"array index out of range: index: 5, size: 3"}
    return value;
}

public function main() {
    string ignored = testGetArrayOutofBoundElement();
}
