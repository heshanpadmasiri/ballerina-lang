import ballerina/io;
import ballerina/lang.'int as ints;

function testPrint1() {
    io:println("Hello"); // @output Hello
    io:println(sampleFunction1()); // @output
    io:println("Ballerina"); // @output Ballerina
}

function testPrint2() {
    io:println("Hello"); // @output Hello
    io:println(sampleFunction2()); // @output
    io:println("Ballerina"); // @output Ballerina
}

function testPrint3() {
    io:println("Hello"); // @output Hello
    io:println(sampleFunction3()); // @output
    io:println("Ballerina"); // @output Ballerina
}

function testPrint4() {
    io:println("Hello"); // @output Hello
    io:println(sampleFunction4()); // @output
    io:println("Ballerina"); // @output Ballerina
}

function testPrintInMatchBlock() {
    match sampleFunction1() {
        () => {
            io:println("Hello"); // @output Hello
            io:println(sampleFunction2()); // @output
            io:println("Ballerina"); // @output Ballerina
        }
    }
}

function testPrintInWorkers() {
    worker w1 {
        string hello = "Hello";
        hello -> w2;
    }

    worker w2 {
        string hello = "";
        hello = <- w1;
        io:println(hello); // @output Hello
        io:println(sampleFunction1()); // @output
        io:println("Ballerina"); // @output Ballerina
    }
    wait w2;
}

function sampleFunction1() {
}

function sampleFunction2() returns () {
}

function sampleFunction3() {
    return ();
}

function sampleFunction4() returns () {
    return ();
}

function nilReturnFuncInvokingNoRetFuncInRetStmt() returns () {
    io:println("nil returns here"); // @output nil returns here
    return noReturnFunc();
}

function noReturnFunc() {
    io:println("no returns here"); // @output no returns here
}

function testNoReturnFuncInvocnInNilReturnFuncRetStmt() {
    io:println(nilReturnFuncInvokingNoRetFuncInRetStmt()); // @output
}

function nilReturnFuncInvokingNilRetFuncInRetStmt() returns () {
    io:println("nil returns here"); // @output nil returns here
    return nilReturnFunc();
}

function nilReturnFunc() returns () {
    io:println("explicit nil returns here"); // @output explicit nil returns here
    return;
}

function testNilReturnFuncInvocnInNilReturnFuncRetStmt() {
    io:println(nilReturnFuncInvokingNilRetFuncInRetStmt()); // @output
}

function testMissingReturnInIfElse() returns int? {
    int x = 100;
    if x > 200 {
        return 1;
    }
}

function testMissingReturnInNestedIfElse() returns string? {
    int x = 100;
    string foo = "Foo";
    if x > 200 {
        return "asdf";
    } else {
        if foo.length() < 5 {
            x = 5;
        } else {
            return foo;
        }
    }
}

function testReturningInMatch() returns string? {
    int x = 10;
    match x {
        2|4|6|8 => {
            return "even";
        }
        1|3|5|7|9 => {
            return "odd";
        }
    }
}

function testReturnsDuringValidCheck() returns error? {
    int _ = checkpanic ints:fromString("15");
}

function testValidCheckWithExplicitReturn() returns error? {
    int _ = checkpanic ints:fromString("15");
    return;
}

function testNilableInt() returns int? {}
function testNilableFloat() returns float? {}
function testNilableDecimal() returns decimal? {}
function testNilableString() returns string? {}
function testNilableBoolean() returns boolean? {}
function testNilableByte() returns byte? {}
function testNilableJSON() returns json? {}
function testNilableXML() returns xml? {}
function testNilableMap() returns map<any>? {}

function testNilableIntArray() returns int[]? {}
function testNilableFloatArray() returns float[]? {}
function testNilableDecimalArray() returns decimal[]? {}
function testNilableStringArray() returns string[]? {}
function testNilableBooleanArray() returns boolean[]? {}
function testNilableByteArray() returns byte[]? {}
function testNilableJSONArray() returns json[]? {}
function testNilableXMLArray() returns xml[]? {}

type OpenPerson record {
    string name;
    int age;
};

function testNilableOpenRecord() returns OpenPerson? {}
function testNilableOpenRecordArray() returns OpenPerson[]? {}

type ClosedPerson record {|
    string name;
    int age;
|};

function testNilableClosedRecord() returns ClosedPerson? {}
function testNilableClosedRecordArray() returns ClosedPerson[]? {}

class PersonObj {
    string name = "John Doe";
}

function testNilableObject() returns PersonObj? {}
function testNilableObjectArray() returns PersonObj[]? {}
function testNilableUnion() returns int|string|OpenPerson|() {}
function testNilableUnionArray() returns (int|string|OpenPerson)?[]? {}
function testNilableTuple() returns [int, string, OpenPerson]? {}
function testNilableTupleArray() returns [int, string, OpenPerson][]? {}
function testNilableTypedesc() returns typedesc<any>? {}
function testNilableTypedescArray() returns typedesc<any>[]? {}

public function main() {
    testPrint1();
    testPrint2();
    testPrint3();
    testPrint4();
    testPrintInMatchBlock();
    testPrintInWorkers();
    testNoReturnFuncInvocnInNilReturnFuncRetStmt();
    testNilReturnFuncInvocnInNilReturnFuncRetStmt();
    io:println(testReturnsDuringValidCheck()); // @output
    io:println(testMissingReturnInIfElse()); // @output
    io:println(testMissingReturnInNestedIfElse()); // @output
    io:println(testReturningInMatch()); // @output
    io:println(testValidCheckWithExplicitReturn()); // @output
    io:println(testNilableInt()); // @output
    io:println(testNilableFloat()); // @output
    io:println(testNilableDecimal()); // @output
    io:println(testNilableString()); // @output
    io:println(testNilableBoolean()); // @output
    io:println(testNilableByte()); // @output
    io:println(testNilableJSON()); // @output
    io:println(testNilableXML()); // @output
    io:println(testNilableMap()); // @output
    io:println(testNilableIntArray()); // @output
    io:println(testNilableFloatArray()); // @output
    io:println(testNilableDecimalArray()); // @output
    io:println(testNilableStringArray()); // @output
    io:println(testNilableBooleanArray()); // @output
    io:println(testNilableByteArray()); // @output
    io:println(testNilableJSONArray()); // @output
    io:println(testNilableXMLArray()); // @output
    io:println(testNilableOpenRecord()); // @output
    io:println(testNilableClosedRecord()); // @output
    io:println(testNilableObject()); // @output
    io:println(testNilableUnion()); // @output
    io:println(testNilableTuple()); // @output
    io:println(testNilableTypedesc()); // @output
    io:println(testNilableOpenRecordArray()); // @output
    io:println(testNilableClosedRecordArray()); // @output
    io:println(testNilableObjectArray()); // @output
    io:println(testNilableUnionArray()); // @output
    io:println(testNilableTupleArray()); // @output
    io:println(testNilableTypedescArray()); // @output
}
