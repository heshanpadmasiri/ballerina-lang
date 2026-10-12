function testNullJsonToInt() returns int {
    json j = null;
    return <int>j; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: '()' cannot be cast to 'int'"}
}

public function main() {
    int ignored = testNullJsonToInt();
}
