function testNullJsonToString() returns string {
    json j = null;
    return <string>j; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: '()' cannot be cast to 'string'"}
}

public function main() {
    string ignored = testNullJsonToString();
}
