import ballerina/io;

type SampleErrorData record {
    string message?;
    error cause?;
    string info;
    boolean fatal;
};

type SampleError error<SampleErrorData>;

public function main() {
    [string, string, boolean, string, map<anydata|error>, string?] results = testErrorDestructure();
    io:println(results[0]); // @output Sample Error
    io:println(results[1]); // @output Detail Info
    io:println(results[2]); // @output true
    io:println(results[3]); // @output Sample Error
    io:println(results[4]); // @output {"info":"Detail Info","fatal":true}
    io:println(results[5]); // @output Failed Message
}

public function testErrorDestructure() returns [string, string, boolean, string, map<anydata|error>, string?] {
    string reason;
    string info;
    boolean fatal;
    error(reason, info = info, fatal = fatal) = getSampleError();

    string reasonTwo;
    map<anydata|error> params;
    error(reasonTwo, ...params) = getSampleError();

    string? detailMsg;
    error(_, detailMsg = detailMsg) = getRecordConstrainedError();
    return [reason, info, fatal, reasonTwo, params, detailMsg];
}

function getSampleError() returns SampleError {
    SampleError e = error SampleError("Sample Error", info = "Detail Info", fatal = true);
    return e;
}

type Foo record {|
    string message?;
    error cause?;
    string detailMsg;
    boolean isFatal;
|};

function getRecordConstrainedError() returns error<Foo> {
    error<Foo> e = <error<Foo>> error("Some Error", detailMsg = "Failed Message", isFatal = true);
    return e;
}
