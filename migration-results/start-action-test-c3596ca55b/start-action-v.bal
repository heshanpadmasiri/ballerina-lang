type FooRec record {|
    function () returns string fn = () => "FOO";
    any...;
|};

function testRecFieldFuncPointerAsyncCall() {
    FooRec fr = {};
    function () returns string fi = fr.fn;
    future<string> fs = start fi();
    string result = checkpanic wait fs;
    assert("FOO", result);

    fr["rec"] = <FooRec>{};
    FooRec fr2 = <FooRec>fr["rec"];
    function () returns string fi2 = fr.fn;
    fs = start fi2();
    string result2 = checkpanic wait fs;
    assert("FOO", result2);
}

client class BarObj {
    remote function getInt() returns int => 100;

    function getName() returns string => "BAR";
}

function testObjectMethodsAsAsyncCalls() {
    BarObj bo = new;
    future<int> fi = start bo->getInt();
    int resulti = checkpanic wait fi;
    assert(100, resulti);

    future<string> fs = start bo.getName();
    string results = checkpanic wait fs;
    assert("BAR", results);
}

function assert(anydata expected, anydata actual) {
    if (expected != actual) {
        typedesc<anydata> expT = typeof expected;
        typedesc<anydata> actT = typeof actual;
        string detail = "expected [" + expected.toString() + "] of type [" + expT.toString()
                            + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
        panic error("{AssertionError}", message = detail);
    }
}

function testCast() {
    future<string> fs1 = start getMessage([1,2]);
    string result1 = checkpanic wait fs1;
    assert("The value is [1,2]", result1);

    map<int> marks = {sam: 50, jon: 60};
    future<string> fs2 = start getMessage(marks);
    string result2 = checkpanic wait fs2;
    assert("The value is {\"sam\":50,\"jon\":60}", result2);
}

function getMessage(any j) returns string {
   return "The value is " + j.toString();
}

public function main() {
    testRecFieldFuncPointerAsyncCall();
    testObjectMethodsAsAsyncCalls();
    testCast();
}
