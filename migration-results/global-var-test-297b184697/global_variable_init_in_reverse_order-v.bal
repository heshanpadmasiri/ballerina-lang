import ballerina/io;

public function testReverseOrderInitialization() {
    if (s == "hello" && a == 5) {
        return;
    }

    panic error(ASSERTION_ERROR_REASON, message = "expected 'true', found 'false'");
}

function init() {
    s = "hello";
    int x = 2;
    a = x + 3;
}

string s;
int a;
const ASSERTION_ERROR_REASON = "AssertionError";

public function main() {
    testReverseOrderInitialization();
}

function retainIoImport() {
    io:println();
}
