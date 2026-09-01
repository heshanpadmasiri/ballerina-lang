
public function testFailStmt() returns error {

    error|int err = error("Custom error thrown explicitly.");
    fail err; // @error type '(error|int)' not allowed here; expected an 'error' or a subtype of 'error'
}
