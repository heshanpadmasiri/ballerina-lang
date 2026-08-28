public function testTransactionCall() {
    var successClient = client object {
        transactional resource function get path/[string]() returns int {
            return 1;
        }
        resource function get path2/[string]() {
            testFunction(); // @error
        }
    };
    int _ = successClient->/path/["a"]; // @error
}

public transactional function testFunction() {
}
