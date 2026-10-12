function testNullJsonToFloat() returns float {
    json j = null;
    return <float>j; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: '()' cannot be cast to 'float'"}
}

public function main() {
    float ignored = testNullJsonToFloat();
}
