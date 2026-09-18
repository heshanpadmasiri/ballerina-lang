import ballerina/io;

client class Foo1 {
    string name;

    function init(string name) {
        self.name = name;
    }

    remote function getName() returns string {
        return self.name;
    }
}

function testNestedClientObjectActions() {
    Foo1 f1 = new("foo");

    future<string> fs = start f1->getName();
    string result = checkpanic wait fs;
    assert("foo", result);
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

function retainIoImport(io:ReadableByteChannel? channel) {
    _ = channel;
}

public function main() {
    testNestedClientObjectActions();
}
