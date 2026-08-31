import ballerina/io;

const TYPE_A_ERROR_REASON = "TypeA_Error";
const TYPE_B_ERROR_REASON = "TypeB_Error";

type ErrorTypeA distinct error;
type ErrorTypeB distinct error;

public function main() {
    testOnFailStatement();
}

function testOnFailStatement() {
    io:println(testOnFail()); // @output Before failure throw-> Error caught ! -> Execution continues...
    io:println(testReturnWithinOnFail()); // @output Before failure throw-> Error caught !
    io:println(testOnFailWithoutVariable()); // @output Before failure-> Error caught !
    io:println(testOnFailWithoutVariableWithoutOnFailExecution()); // @output Before failure

    string|error onFailWithCheckExprResult = testOnFailWithCheckExpr();
    if onFailWithCheckExprResult is string {
        io:println(onFailWithCheckExprResult); // @output Before failure throw-> Error caught ! -> Execution continues...
    } else {
        panic error("Expected error to be caught. Hence, test failed.");
    }

    io:println(testNestedDoWithOnFail()); // @output -> Before error 1 is thrown -> Before error 2 is thrown -> error 2 caught ! -> error 1 caught !-> Execution continues...
    io:println(testNestedDoWithLessOnFails()); // @output -> Before error 1 is thrown -> Before error 2 is thrown -> Error caught !-> Execution continues...

    error? errorReturnWithinOnFailResult = testReturnErrorWithinOnFail();
    if errorReturnWithinOnFailResult is error {
        io:println(errorReturnWithinOnFailResult.message()); // @output custom error
    } else {
        panic error("Expected error to be caught. Hence, test failed.");
    }

    io:println(testAppendOnFailError()); // @output Before failure throw -> Error caught: custom error -> Execution continues...
    io:println(testLambdaFunctionWithOnFail()); // @output 44
    io:println(testArrowFunctionInsideOnFail()); // @output 44
    io:println(testOnFailWithUnion()); // @output Before failure throw-> Error caught : TypeA_Error-> Execution continues...
    io:println(testFailWithinOnFail1()); // @output -> Within do statement-> Error caught in inner on fail-> Error caught in outer on fail-> Execution completed.

    string|error failWithinOnFail2Result = testFailWithinOnFail2();
    if failWithinOnFail2Result is error {
        io:println(failWithinOnFail2Result.message()); // @output custom error
    } else {
        panic error("Expected error to be returned. Hence, test failed.");
    }

    io:println(testFailWithinOnFail3()); // @output -> Within 1st do statement-> Error caught in 1st on-fail-> Within 2nd do statement-> Error caught in 2nd on-fail-> Error caught in outer on-fail-> Execution completed.
    io:println(testFailWithinOnFail4()); // @output -> Within do statement-> Error caught in inner on fail-> Error caught in outer on fail-> Execution completed.
    io:println(testFailWithinOnFail5()); // @output -> Within do statement-> Error caught in inner on fail-> Error caught in L2 on fail-> Error caught in L1 on fail-> Execution completed.
}

function testOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error("custom error", message = "error value");
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function testReturnWithinOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error("custom error", message = "error value");
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught !";
        return str;
    }
    return str;
}

function testOnFailWithoutVariable() returns string {
    string str = "";
    do {
        str += "Before failure";
        fail error("custom error", message = "error value");
    } on fail {
        str += "-> Error caught !";
    }
    return str;
}

function testOnFailWithoutVariableWithoutOnFailExecution() returns string {
    string str = "";
    do {
        str += "Before failure";
    } on fail {
        str += "-> Error caught !";
    }
    return str;
}

function testOnFailWithCheckExpr() returns string|error {
    string str = "";
    do {
        str += "Before failure throw";
        int _ = check getError();
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function getError() returns int|error {
    return error("Custom Error");
}

function testNestedDoWithOnFail() returns string {
    string str = "";
    do {
        str += "-> Before error 1 is thrown";
        do {
            str += " -> Before error 2 is thrown";
            fail error("custom error 2", message = "error value");
        } on fail var e {
            error caughtError = e;
            string _ = caughtError.message();
            str += " -> error 2 caught !";
        }
        fail error("custom error 1", message = "error value");
    } on fail error e {
        string _ = e.message();
        str += " -> error 1 caught !";
    }
    str += "-> Execution continues...";
    return str;
}

function testNestedDoWithLessOnFails() returns string {
    string str = "";
    do {
        str += "-> Before error 1 is thrown";
        do {
            str += " -> Before error 2 is thrown";
            fail error("custom error 2", message = "error value");
        }
    } on fail error e {
        string _ = e.message();
        str += " -> Error caught !";
    }
    str += "-> Execution continues...";
    return str;
}

function testReturnErrorWithinOnFail() returns error? {
    do {
        fail error("custom error", message = "error value");
    } on fail error e {
        return e;
    }
}

function testAppendOnFailError() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail error("custom error", message = "error value");
    } on fail error e {
        str += " -> Error caught: ";
        str = str.concat(e.message());
    }
    str += " -> Execution continues...";
    return str;
}

function testArrowFunctionInsideOnFail() returns int {
    int a = 10;
    int b = 11;
    int c = 0;
    do {
        c = a + b;
        fail error("custom error", message = "error value");
    } on fail error e {
        string _ = e.message();
        function (int, int) returns int arrow = (x, y) => x + y + a + b + c;
        a = arrow(1, 1);
    }
    return a;
}

function testLambdaFunctionWithOnFail() returns int {
    var lambdaFunc = function () returns int {
        int a = 10;
        int b = 11;
        int c = 0;
        do {
            c = a + b;
            fail error("custom error", message = "error value");
        } on fail error e1 {
            string _ = e1.message();
            function (int, int) returns int arrow = (x, y) => x + y + a + b + c;
            a = arrow(1, 1);
        }
        return a;
    };
    return lambdaFunc();
}

function testOnFailWithUnion() returns string {
    string str = "";
    var getTypeAError = function () returns int|ErrorTypeA {
        return error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    };
    var getTypeBError = function () returns int|ErrorTypeB {
        ErrorTypeB errorB = error ErrorTypeB(TYPE_B_ERROR_REASON, message = "Error Type B");
        return errorB;
    };
    do {
        str += "Before failure throw";
        int _ = check getTypeAError();
        int _ = check getTypeBError();
    } on fail ErrorTypeA|ErrorTypeB e {
        str += "-> Error caught : ";
        str = str.concat(e.message());
    }
    str += "-> Execution continues...";
    return str;
}

function testFailWithinOnFail1() returns string {
    int i = 0;
    string str = "";
    while i < 2 {
        do {
            str += "-> Within do statement";
            i += 1;
            fail error("custom error", message = "error value");
        } on fail error e {
            str += "-> Error caught in inner on fail";
            fail e;
        }
        str += "-> After do statement";
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught in outer on fail";
    }
    str += "-> Execution completed.";
    return str;
}

function testFailWithinOnFail2() returns string|error {
    int i = 0;
    string str = "";
    while i < 2 {
        do {
            str += "-> Within do statement";
            i += 1;
            fail error("custom error", message = "error value");
        } on fail error e {
            str += "-> Error caught in inner on fail";
            fail e;
        }
        str += "-> After do statement";
    }
    str += "-> Execution completed.";
    return str;
}

function testFailWithinOnFail3() returns string {
    int i = 0;
    string str = "";
    while i < 2 {
        do {
            str += "-> Within 1st do statement";
            i += 1;
            fail error("custom error", message = "error value");
        } on fail error e1 {
            string _ = e1.message();
            str += "-> Error caught in 1st on-fail";
            do {
                str += "-> Within 2nd do statement";
                i += 1;
                fail error("custom error", message = "error value");
            } on fail error e2 {
                str += "-> Error caught in 2nd on-fail";
                fail e2;
            }
        }
        str += "-> After do statement";
    } on fail error e3 {
        string _ = e3.message();
        str += "-> Error caught in outer on-fail";
    }
    str += "-> Execution completed.";
    return str;
}

function testFailWithinOnFail4() returns string {
    int i = 0;
    string str = "";
    while i < 2 {
        do {
            str += "-> Within do statement";
            i += 1;
            int _ = check getError();
        } on fail error e {
            string _ = e.message();
            str += "-> Error caught in inner on fail";
            int _ = check getError();
        }
        str += "-> After do statement";
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught in outer on fail";
    }
    str += "-> Execution completed.";
    return str;
}

function testFailWithinOnFail5() returns string {
    string str = "";
    do {
        do {
            do {
                str += "-> Within do statement";
                fail error("L3");
            } on fail error e {
                string _ = e.message();
                str += "-> Error caught in inner on fail";
                fail error("L3 On-Fail");
            }
            str += "-> After do statement";
        } on fail error e {
            string _ = e.message();
            str += "-> Error caught in L2 on fail";
            fail error("L2 On-Fail");
        }
    } on fail error e {
        string _ = e.message();
        str += "-> Error caught in L1 on fail";
    }
    str += "-> Execution completed.";
    return str;
}

function testOnFailWithCheckAndReturnType(function s = function() {
            do {
                function _ = function() returns error? {
                    string _ = check getVal("");
                };
            } on fail {
            }
        }) returns string|error {
    return "";
}

function getVal(string s) returns string|error {
    return "";
}
