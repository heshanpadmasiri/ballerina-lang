function testStringIndexAccessException() {
    string hello = "hello👋";
    string val = hello[6]; // @panic
}

public function main() {
    testStringIndexAccessException();
}
