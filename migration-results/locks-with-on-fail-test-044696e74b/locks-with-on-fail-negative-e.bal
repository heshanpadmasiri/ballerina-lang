type SampleErrorData record {|
    int code;
    string reason;
|};

type SampleError error<SampleErrorData>;

type SampleComplexErrorData record {|
    int code;
    int[2] pos;
    record {string moreInfo;} infoDetails;
|};

type SampleComplexError error<SampleComplexErrorData>;

function testOnFailWithMultipleErrors() {
    boolean isPositiveState = false;
    lock {
        if isPositiveState {
            fail error SampleComplexError("Transaction Failure", code = 20, pos = [30, 45], infoDetails = {moreInfo: "deadlock condition"});
        }
        fail error SampleError("Transaction Failure", code = 50, reason = "deadlock condition");
    } on fail var error(msg) { // @error invalid error variable; expecting an error type but found '(SampleComplexError|SampleError)' in type definition
    }
}
