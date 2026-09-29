import ballerina/io;

function testFieldAccessOfNullableJSON() returns json|error {
    return foo().name;
}

function foo() returns json {
    return null;
}

public function main() {
    error fieldAccessError = <error>testFieldAccessOfNullableJSON();
    io:println(fieldAccessError.detail()["message"]); // @output JSON value is not a mapping
}
