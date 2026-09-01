import ballerina/io;

type Error error<record {| |}>;

public function testFailStmt() returns error {
    Error err = error("Custom error thrown explicitly.");
    fail err;
}

public function main() {
    error result = testFailStmt();
    io:println(result.message()); // @output Custom error thrown explicitly.
}
