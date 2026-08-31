type ErrorTypeA distinct error;

const TYPE_A_ERROR_REASON = "TypeA_Error";

type ErrorTypeB distinct error;

const TYPE_B_ERROR_REASON = "TypeB_Error";

function testIncompatibleErrorTypeOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    }
    on fail ErrorTypeB e { // @error
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function testOnFailWithUnion() returns string {
    string str = "";
    var getTypeAError = function () returns int|ErrorTypeA {
        return error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    };
    var getTypeBError = function () returns int|ErrorTypeB {
        return error ErrorTypeB(TYPE_B_ERROR_REASON, message = "Error Type B");
    };
    do {
        str += "Before failure throw";
        int _ = check getTypeAError();
        int _ = check getTypeBError();
    }
    on fail ErrorTypeA e { // @error
        str += "-> Error caught : ";
        str = str.concat(e.message());
    }
    str += "-> Execution continues...";
    return str;
}
