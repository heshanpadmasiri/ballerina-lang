function testNullJsonToBoolean() returns boolean {
    json j = null;
    return <boolean>j; // @panic error: {ballerina}TypeCastError {"message":"incompatible types: '()' cannot be cast to 'boolean'"}
}

public function main() {
    boolean ignored = testNullJsonToBoolean();
}
