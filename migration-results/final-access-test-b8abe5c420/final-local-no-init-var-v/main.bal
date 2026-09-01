function testSubsequentInitializationOfFinalVar() {
    final int i;
    i = 12;

    assertEquality(12, i);
}

function testSubsequentInitializationOfFinalVarInBranches() {
    assertEquality("ONE", initializeFinalVarInBranches1(1));
    assertEquality("TWO", initializeFinalVarInBranches1(2));
    assertEquality("OTHER", initializeFinalVarInBranches1(3));
    assertEquality("ONE", initializeFinalVarInBranches2(1));
    assertEquality("TWO", initializeFinalVarInBranches2(2));
    assertEquality("OTHER", initializeFinalVarInBranches2(3));
}

function initializeFinalVarInBranches1(int i) returns string {
    final string s;
    if i == 1 {
        s = "ONE";
    } else if i == 2 {
        s = "TWO";
    } else {
        s = "OTHER";
    }
    return s;
}

function initializeFinalVarInBranches2(int i) returns string {
    final string s;

    match i {
        1 => {
            s = "ONE";
        }
        2 => {
            s = "TWO";
        }
        _ => {
            s = "OTHER";
        }
    }
    return s;
}

function assertEquality(any|error expected, any|error actual) {
    if (expected is anydata && actual is anydata && expected == actual) {
        return;
    }

    if (expected === actual) {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    testSubsequentInitializationOfFinalVar();
    testSubsequentInitializationOfFinalVarInBranches();
}
