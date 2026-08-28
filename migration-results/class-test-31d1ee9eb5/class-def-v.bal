public const COMMA = ",";

public type Separator COMMA|string;

public class Foo {
    Separator s;

    function init(Separator fs = ",") {
        self.s = fs;
    }
}

function testUnionTypeInInitParameter() {
    Foo f = new;
    assertEquality(f.s, COMMA);
}

int a = 3;

public class Bar {
    int a = 4;
    int b = a;

    function init() {
    }
}

function testModuleLevelVariableAsFieldDefault() {
    Bar b = new();
    a = 6;
    assertEquality(b.b, 3);
    Bar b2 = new;
    assertEquality(b2.b, 6);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(anydata actual, anydata expected) {
    if (actual == expected) {
        return;
    }

    panic error(ASSERTION_ERROR_REASON,
                 message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    testUnionTypeInInitParameter();
    testModuleLevelVariableAsFieldDefault();
}
