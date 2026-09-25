public type ClientCredentialsGrantConfig record {|
    string tokenUrl;
    ClientConfiguration clientConfig = {};
|};
type AnydataConfig record {| anydata auth?; |};
public type ClientConfiguration record {| *AnydataConfig; ClientAuth auth?; |};
public type ClientAuth ClientCredentialsGrantConfig;

function testCyclicRecordResolution() {
    ClientAuth cl = {tokenUrl: "Token@1", clientConfig: {auth: {tokenUrl: "Token@2"}}};
    assertValueEquality("Token@1", cl.tokenUrl);
    assertValueEquality("Token@2", cl.clientConfig?.auth?.tokenUrl);
}

final readonly & map<function> func1 = {"f1": f2};
isolated function f2() returns boolean {
    function? res = func1["f1"];
    return res is function;
}
function testFunctionPointerNotCyclicViaRecordField() { assertValueEquality(true, f2()); }
function assertValueEquality(anydata expected, anydata actual) {
    if expected != actual { panic error("AssertionError"); }
}
public function main() {
    testCyclicRecordResolution();
    testFunctionPointerNotCyclicViaRecordField();
}
