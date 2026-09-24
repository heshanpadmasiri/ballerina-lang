type ErrorTypeA distinct error;
const TYPE_A_ERROR_REASON = "TypeA_Error";
type ErrorTypeB distinct error;
const TYPE_B_ERROR_REASON = "TypeB_Error";

function testIncompatibleErrorTypeOnFail(int i) returns string {
    string str = "";
    int count = i;
    while count < 5 {
        count += 1;
        str += "Before failure throw";
        fail error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    } on fail ErrorTypeB e { // @error
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

function testOnFailWithUnion(int i) returns string {
    string str = "";
    var getTypeAError = function() returns int|ErrorTypeA {
        return error ErrorTypeA(TYPE_A_ERROR_REASON, message = "Error Type A");
    };
    var getTypeBError = function() returns int|ErrorTypeB {
        return error ErrorTypeB(TYPE_B_ERROR_REASON, message = "Error Type B");
    };
    int count = i;
    while count < 5 {
        count += 1;
        str += "Before failure throw";
        int _ = check getTypeAError();
        int _ = check getTypeBError();
    } on fail ErrorTypeA e { // @error
        str += "-> Error caught : ";
        str = str.concat(e.message());
    }
    str += "-> Execution continues...";
    return str;
}

type SampleErrorData record {| int code; string reason; |};
type SampleError error<SampleErrorData>;
type SampleComplexErrorData record {| int code; int[2] pos; record {string moreInfo;} infoDetails; |};
type SampleComplexError error<SampleComplexErrorData>;
int whileIndex = 0;
function testOnFailWithMultipleErrors() {
    while whileIndex >= 0 {
        whileIndex += 1;
        if whileIndex == 1 {
            fail error SampleComplexError("Transaction Failure", code = 20, pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
        fail error SampleError("Transaction Failure", code = 50, reason = "deadlock condition");
    } on fail var error(msg) { // @error
    }
}
