import ballerina/io;

public function main() {
    io:println(testClosedIntRange()); // @output
}

public type Label int;

function testClosedIntRange() {
    int startValue = 1;
    int endValue = 5;
    int[] returnArray = [];
    int returnArrayIndex = 0;
    foreach var val in startValue ... endValue {
        returnArray[returnArrayIndex] = val;
        returnArrayIndex += 1;
    }

    assertEquality(returnArray.length(), 5);
    assertEquality(returnArray[0], 1);
    assertEquality(returnArray[1], 2);
    assertEquality(returnArray[2], 3);
    assertEquality(returnArray[3], 4);
    assertEquality(returnArray[4], 5);
}

type AssertionError distinct error;

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error AssertionError(ASSERTION_ERROR_REASON,
            message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
