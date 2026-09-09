import stacktrace_project.stacktrace as stacktrace;
import ballerina/io;

public function testStackTraceElements() {
    error:StackFrame[] callStackElements = stacktrace:getStackTrace();

    assertEquality(callStackElements.length(), 3);
    assertEquality(callStackElements[0].toString(), "callableName: getStackTrace moduleName: " +
        "test_org.stacktrace_project.stacktrace.0 fileName: stacktrace.bal lineNumber: 2");
    assertEquality(callStackElements[1].toString(), "callableName: testStackTraceElements moduleName: " +
        "test_org.stacktrace_project.0 fileName: main.bal lineNumber: 5");

    error:StackFrame callStackElement = callStackElements[0];
    _ = callStackElement;
}

function assertEquality(any|error actual, any|error expected) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    io:println(actualValAsString);
    panic error(string `expected '${expectedValAsString}', found '${actualValAsString}'`);
}

public function main() {
    testStackTraceElements();
}
