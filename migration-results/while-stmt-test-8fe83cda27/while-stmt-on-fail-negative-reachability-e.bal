type ErrorTypeA distinct error;
const TYPE_A_ERROR_REASON = "TypeA_Error";

function testUnreachableAfterFail(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        error err = error("custom error", message = "error value");
        str += "Before failure throw";
        fail err;
        str += "After failure throw"; // @error
    } on fail error e { // @error
        str += "-> Error caught ! ";
    }
    return str;
}

function testIncompatibleErrorTypeOnFail(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        str += "-> Error caught ! ";
    }
    return str;
}

function testIgnoreReturnInOnFail(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        return str;
    }
    return str;
}

function testUnreachableInOnFail(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        return str;
        str += "-> After returning string"; // @error
    }
    return str;
}

function testReturnWithinWhile(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        return str;
    }
} // @error

function testErrorDuplication() returns error? {
    int i = 3;
    while i > 2 {
        i -= 1;
        fail error("Custom Error");
        i += 1; // @error
    }
    i += 1; // @error
}
