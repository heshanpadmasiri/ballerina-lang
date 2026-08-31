@deprecated
type Foo record {
    int i;
    int j;
};

Foo foo = {i: 1, j: 2};

function testDeprecatedConstructUsageAtRuntimeWithWarning() {
    assertEquality(1, foo.i);
    assertEquality(2, foo.j);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    testDeprecatedConstructUsageAtRuntimeWithWarning();
}
