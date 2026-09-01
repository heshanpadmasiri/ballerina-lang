import testPackage.testModule;

public function main() {
    testFunctionDefaultParameterValues();
    testFunctionDefaultParameterValues(10);
}

function testFunctionDefaultParameterValues(int x = 20) {
    testModule:Client salesClient = new ();
    int y = salesClient->/(x);
    assertEquality(y, x + 1);
    y = salesClient->/(x, "val");
    assertEquality(y, x + 2);
}

function assertEquality(int actual, int expected) {
    if actual != expected {
        panic error("AssertionError");
    }
}
