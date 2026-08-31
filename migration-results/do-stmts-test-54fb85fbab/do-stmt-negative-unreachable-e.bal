type ErrorTypeA distinct error;

const TYPE_A_ERROR_REASON = "TypeA_Error";

function testUnreachableAfterFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error("custom error", message = "error value");
        str += "After failure throw"; // @error
    } on fail error e { // @error
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function testIncompatibleErrorTypeOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function testIgnoreReturnInOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        str += "-> Error caught ! ";
        return str;
    }
    str += "-> Execution continues...";
    return str;
}

function testUnreachableInOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeA e { // @error
        str += "-> Error caught ! ";
        return str;
        str += "-> After returning string"; // @error
    }
    str += "-> Execution continues...";
    return str;
}

function testReturnWitihinDo() returns string {
    string str = "";
    do {
        str = str + "do statement start";
        return str;
    }
    str = str + "do statemtnt finished"; // @error
}
