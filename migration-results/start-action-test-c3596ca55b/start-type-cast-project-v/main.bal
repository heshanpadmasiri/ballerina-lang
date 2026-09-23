import startactiontest.callee;

public function main() {
    future<string> fs1 = start callee:getValueMessage([1,2]);
    string result1 = checkpanic wait fs1;
    assert("The value is [1,2]", result1);

    map<int> marks = {sam: 50, jon: 60};
    future<string> fs2 = start callee:getValueMessage(marks);
    string result2 = checkpanic wait fs2;
    assert("The value is {\"sam\":50,\"jon\":60}", result2);
}

function assert(anydata expected, anydata actual) {
    if (expected != actual) {
        typedesc<anydata> expT = typeof expected;
        typedesc<anydata> actT = typeof actual;
        string detail = "expected [" + expected.toString() + "] of type [" + expT.toString()
                            + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
        panic error("{AssertionError}", message = detail);
    }
}
