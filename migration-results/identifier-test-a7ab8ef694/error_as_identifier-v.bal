import ballerina/io;

class ErrorField {
    public error 'error;
    public int 'int;

    function init(error er, int value = 20) {
        self.'error = er;
        self.'int = value;
    }
}

type ErrorDataWithErrorField record {
    error 'error;
};

function getError() returns error {
    return error("Generated Error");
}

function functionWithErrorNamedDefaultArgument(error 'error = getError()) {
    assertEquality('error.message(), "Generated Error");
}

function functionWithErrorNamedIncludedParam(*ErrorDataWithErrorField errorData) {
    assertEquality(errorData.'error.message(), "Generated Error");
}

function functionWithErrorNamedRequiredParam(ErrorDataWithErrorField 'error) {
    assertEquality('error.'error.message(), "Generated Error");
}

function functionWithErrorNamedRestParam(ErrorDataWithErrorField... 'error) {
    assertEquality('error[0].'error.message(), "Generated Error");
}

function testErrorAsObjectField() {
    error newError = error("bam", message = "new error");
    ErrorField p = new ErrorField(newError);
    assertEquality(p.'error.toString(), "error(\"bam\",message=\"new error\")");
    assertEquality(p.'error.message(), "bam");
    assertEquality(p.'error.detail()["message"], "new error");
    assertEquality(p.'int, 20);
}

function testErrorDataWithErrorField() {
    error newError = error("bam", message = "new error");
    ErrorDataWithErrorField ef = {'error: newError};
    assertEquality(ef.'error.message(), "bam");
    assertEquality(ef.'error.detail()["message"], "new error");
}

function testErrorConstructorWithErrorField() {
    error e = error("test message", 'error = error("error as a detail"), message = "new message");
    ErrorDataWithErrorField ef = {'error: e};
    assertEquality(ef.'error.message(), "test message");
    error errorInCtor = <error>ef.'error.detail()["error"];
    assertEquality(errorInCtor.message(), "error as a detail");
}

function testErrorNamedDefaultArgument() {
    functionWithErrorNamedDefaultArgument();
}

function testErrorNamedIncludedParam() {
    error newError = getError();
    ErrorDataWithErrorField er = {'error: newError};
    functionWithErrorNamedIncludedParam(er);
}

function testErrorNamedRequiredParam() {
    error newError = getError();
    ErrorDataWithErrorField er = {'error: newError};
    functionWithErrorNamedRequiredParam(er);
}

function testErrorNamedRestParam() {
    error newError = getError();
    ErrorDataWithErrorField er = {'error: newError};
    functionWithErrorNamedRestParam(er);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error actual, any|error expected) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON, message =
        "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() {
    if shouldPrint() {
        io:println("");
    }
    testErrorNamedDefaultArgument();
    testErrorAsObjectField();
    testErrorDataWithErrorField();
    testErrorConstructorWithErrorField();
    testErrorNamedIncludedParam();
    testErrorNamedRequiredParam();
    testErrorNamedRestParam();
    testErrorNamedDefaultArgument();
    testErrorAsObjectField();
    testErrorDataWithErrorField();
    testErrorConstructorWithErrorField();
    testErrorNamedIncludedParam();
    testErrorNamedRequiredParam();
    testErrorNamedRestParam();
}

function shouldPrint() returns boolean {
    return false;
}
