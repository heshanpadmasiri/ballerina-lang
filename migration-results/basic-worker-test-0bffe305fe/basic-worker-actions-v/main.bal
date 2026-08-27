import ballerina/io;
import ballerina/jballerina.java;
import ballerina/lang.'error as errorLib;
import ballerina/lang.runtime;
import ballerina/lang.'value as value;
import ballerina/test;

function sleep(int millis) {
    runtime:sleep(<decimal> millis / 1000);
}

function getStrand() returns handle = @java:Method {
    'class: "io.ballerina.runtime.internal.scheduling.Scheduler",
    name: "getStrand"
} external;

function getIsolated(handle strand) returns boolean = @java:FieldGet {
    'class: "io.ballerina.runtime.internal.scheduling.Strand",
    name: "isIsolated"
} external;

function isIsolated() returns boolean => getIsolated(getStrand());

function workerDeclTest() {
    fork {
        @strand {thread: "any"}
        worker w1 { int x = 0; }
        @strand {thread: "any"}
        worker w2 { int y = 0; int g = y + 1; }
    }
    map<any> results = wait {w1, w2};
    worker wy { }
}

function forkWithMessageParsingTest() returns int {
    int x = 5;
    fork {
        @strand {thread: "any"}
        worker w1 { int a = 5; int b = 0; a -> w2; b = <- w2; }
        @strand {thread: "any"}
        worker w2 { int a = 0; int b = 15; a = <- w1; b -> w1; }
    }
    map<any> results = wait {w1, w2};
    return x;
}

function basicForkTest() returns int {
    int x = 10;
    fork {
        worker w1 { int a = 5; int b = a + 1; }
        worker w2 { int a = 0; int b = 15; }
    }
    map<any> results = wait {w1, w2};
    return x;
}

function simpleWorkerMessagePassingTest() {
    worker w1 { int a = 10; a -> w2; a = <- w2; }
    worker w2 { int a = 0; int b = 15; a = <- w1; b -> w1; }
}

function forkWithWaitForAny() returns int|error {
    map<any> m = {x: 25};
    fork {
        worker w1 { m["x"] = 5; sleep(1000); }
        worker w2 { sleep(1000); m["x"] = 5; }
        worker w3 { m["x"] = 15; }
    }
    () results = wait w1|w2|w3;
    return <int>m["x"];
}

function workerReturnTest() returns int {
    worker wx returns int { return 51; }
    return wait wx;
}

function workerSameThreadTest() returns map<boolean> {
    worker w1 returns boolean { return isIsolated(); }
    worker w2 returns boolean { return isIsolated(); }
    map<boolean> res = wait {w1, w2};
    res["w"] = isIsolated();
    return res;
}

function testSimpleSendActionWithCloneableType() {
    worker w1Cloneable returns boolean {
        value:Cloneable w1a = 10; value:Cloneable w1b = 11;
        w1a -> w2Cloneable; w1b ->> w2Cloneable; return true;
    }
    worker w2Cloneable returns boolean {
        sleep(10); value:Cloneable w2a = <- w1Cloneable; value:Cloneable w2b = <- w1Cloneable;
        if w2a is int { assertValueEquality(10, w2a); } else { return false; }
        if w2b is int { assertValueEquality(11, w2b); } else { return false; }
        return true;
    }
    record {| boolean w1Cloneable; boolean w2Cloneable; |} x = wait {w1Cloneable, w2Cloneable};
    assertValueEquality(true, x.w1Cloneable); assertValueEquality(true, x.w2Cloneable);
}

function testSimpleSendActionErrorType() {
    @strand {thread: "parent"}
    worker w1Error returns error { error w1a = error("10"); error w1b = error("11"); w1a -> w2Error; w1b ->> w2Error; return error("Completed"); }
    @strand {thread: "parent"}
    worker w2Error returns error { sleep(10); error w2a = <- w1Error; error w2b = <- w1Error; assertValueEquality("10", w2a.message()); assertValueEquality("11", w2b.message()); return error("Completed"); }
    record {| error w1Error; error w2Error; |} x = wait {w1Error, w2Error};
    assertValueEquality("Completed", x.w1Error.message()); assertValueEquality("Completed", x.w2Error.message());
}

function testSimpleSendActionXMLType() {
    @strand {thread: "parent"}
    worker w1Xml returns xml { xml w1a = xml `10`; xml w1b = xml `11`; w1a -> w2Xml; w1b ->> w2Xml; return xml `Completed`; }
    @strand {thread: "parent"}
    worker w2Xml returns xml { sleep(10); xml w2a = <- w1Xml; xml w2b = <- w1Xml; assertValueEquality(xml `10`, w2a); assertValueEquality(xml `11`, w2b); return xml `Completed`; }
    record {| xml w1Xml; xml w2Xml; |} x = wait {w1Xml, w2Xml};
    assertValueEquality("Completed", x.w1Xml.toString()); assertValueEquality("Completed", x.w2Xml.toString());
}

type IntRec readonly & record {| int ID = 0; |};

function testSimpleSendActionReadonlyRecord() {
    @strand {thread: "parent"}
    worker w1readonlyRec returns string { IntRec w1a = {ID: 10}; IntRec w1b = {ID: 11}; w1a -> w2readonlyRec; w1b ->> w2readonlyRec; return "Completed"; }
    @strand {thread: "parent"}
    worker w2readonlyRec returns string { sleep(10); IntRec w2a = <- w1readonlyRec; IntRec w2b = <- w1readonlyRec; assertValueEquality(10, w2a.ID); assertValueEquality(11, w2b.ID); return "Completed"; }
    record {| string w1readonlyRec; string w2readonlyRec; |} x = wait {w1readonlyRec, w2readonlyRec};
    assertValueEquality("Completed", x.w1readonlyRec); assertValueEquality("Completed", x.w2readonlyRec);
}

function simpleSendActionWithMapType() returns map<anydata> {
    @strand {thread: "parent"}
    worker w1 returns boolean {
        map<int> x = {a: 1, b: 2}; map<int> y = {c: 40, d: 50};
        map<value:Cloneable> a = x; map<value:Cloneable> b = y;
        a -> w2; b ->> w2; return true;
    }
    @strand {thread: "parent"}
    worker w2 returns boolean {
        map<value:Cloneable> data = <- w1; sleep(10); map<value:Cloneable> dataSet2 = <- w1;
        if data is map<int> { assertValueEquality(1, data["a"]); assertValueEquality(2, data["b"]); } else { return false; }
        if dataSet2 is map<int> { assertValueEquality(40, dataSet2["c"]); assertValueEquality(50, dataSet2["d"]); } else { return false; }
        return true;
    }
    @strand {thread: "any"}
    worker w3 returns map<anydata> { return wait {w1, w2}; }
    return wait w3;
}

function testSimpleSendActionWithMapType() {
    map<anydata> result = simpleSendActionWithMapType();
    assertValueEquality(true, result["w1"]); assertValueEquality(true, result["w2"]);
}

function simpleSendActionWithListType() returns map<anydata> {
    @strand {thread: "parent"}
    worker w1 returns boolean {
        int[] x = [1, 2, 3]; int[2] y = [40, 50];
        value:Cloneable[] a = x; value:Cloneable[2] b = y;
        a -> w2; b ->> w2; return true;
    }
    @strand {thread: "parent"}
    worker w2 returns boolean {
        value:Cloneable[] data = <- w1; sleep(10); value:Cloneable[] dataSet2 = <- w1;
        if data is int[] { assertValueEquality(1, data[0]); assertValueEquality(2, data[1]); assertValueEquality(3, data[2]); } else { return false; }
        if dataSet2 is int[] { assertValueEquality(40, dataSet2[0]); assertValueEquality(50, dataSet2[1]); } else { return false; }
        return true;
    }
    @strand {thread: "any"}
    worker w3 returns map<anydata> { return wait {w1, w2}; }
    return wait w3;
}

function testSimpleSendActionWithListType() {
    map<anydata> result = simpleSendActionWithListType();
    assertValueEquality(true, result["w1"]); assertValueEquality(true, result["w2"]);
}

function testPanicWithMessagePassing() {
    foreach int i in 0...100 { foo(); bar(); }
}
function bar() { foo(); }
function foo() {
    worker w1 { if 1 > 0 { panic error("err"); } 10 -> w2; }
    worker w2 { int y = <- w1; }
}

function testEarlyReturnWithMessagePassing() {
    foreach int i in 0...100 { func1(); func2(); }
}
function func2() { func1(); }
function func1() {
    foo();
    worker w1 { if 1 > 0 { return; } else { 10 -> w2; } }
    worker w2 { int|errorLib:NoMessage y = <- w1; }
}

function testWorkerMessagePassingRepeatedly() {
    future<()> futureResult1 = @strand {thread: "any"} start testSyncSendRecursively(0, 10000);
    foreach int i in 1...100 { future<()> futureResult2 = @strand {thread: "any"} start testSyncSendIteratively(i, 2 * i); error? unionResult = wait futureResult2; }
    testSyncSendRecursively(0, 10000);
    foreach int i in 1...100 { testSyncSendIteratively(i, 2 * i); }
    future<()> futureResult3 = @strand {thread: "any"} start testAsyncSendRecursively(0, 10000);
    future<()> futureResult4;
    foreach int i in 1...100 { futureResult4 = @strand {thread: "any"} start testAsyncSendIteratively(i, 2 * i); error? unionResult = wait futureResult4; }
    testAsyncSendRecursively(0, 10000);
    foreach int i in 1...100 { testAsyncSendIteratively(i, 2 * i); }
    future<()> futureResult5 = @strand {thread: "any"} start testFlushRecursively(0, 10000);
    future<()> futureResult6;
    foreach int i in 1...100 { futureResult6 = @strand {thread: "any"} start testFlushIteratively(i, 2 * i); error? unionResult = wait futureResult4; }
    testFlushRecursively(0, 10000);
    foreach int i in 1...100 { testFlushIteratively(i, 2 * i); }
    error? unionResult1 = wait futureResult1; error? unionResult2 = wait futureResult3; error? unionResult3 = wait futureResult5;
}

function testSyncSendIteratively(int p, int q) {
    @strand {thread: "any"}
    worker A { p ->> B; }
    @strand {thread: "any"}
    worker B { int x1 = <- A; test:assertEquals(x1, p); q ->> function; }
    int x2 = <- B; test:assertEquals(x2, q);
}
function testSyncSendRecursively(int r, int s) {
    @strand {thread: "any"}
    worker C { r ->> D; }
    @strand {thread: "any"}
    worker D { int x1 = <- C; test:assertEquals(x1, r); s ->> function; }
    int x2 = <- D; test:assertEquals(x2, s);
    if r > 100 { return; } else { testSyncSendRecursively(r + 1, s + 1); }
}
function testAsyncSendIteratively(int p, int q) {
    @strand {thread: "any"}
    worker A { p -> B; }
    @strand {thread: "any"}
    worker B { int x1 = <- A; test:assertEquals(x1, p); q -> function; }
    int x2 = <- B; test:assertEquals(x2, q);
}
function testAsyncSendRecursively(int r, int s) {
    @strand {thread: "any"}
    worker C { r -> D; }
    @strand {thread: "any"}
    worker D { int x1 = <- C; test:assertEquals(x1, r); s -> function; }
    int x2 = <- D; test:assertEquals(x2, s);
    if r > 100 { return; } else { testSyncSendRecursively(r + 1, s + 1); }
}
function testFlushIteratively(int p, int q) {
    @strand {thread: "any"}
    worker A { p -> B; error? unionResult1 = flush; }
    @strand {thread: "any"}
    worker B { int x1 = <- A; test:assertEquals(x1, p); q -> function; error? unionResult2 = flush; }
    int x2 = <- B; test:assertEquals(x2, q);
}
function testFlushRecursively(int r, int s) {
    @strand {thread: "any"}
    worker C { r -> D; error? unionResult1 = flush; }
    @strand {thread: "any"}
    worker D { int x1 = <- C; test:assertEquals(x1, r); s -> function; error? unionResult2 = flush; }
    int x2 = <- D; test:assertEquals(x2, s);
    if r > 100 { return; } else { testSyncSendRecursively(r + 1, s + 1); }
}

function basicWorkerTest1() returns error? {
    string username = "";
    if username == "" { return; }
    int x = 1; worker w { int _ = x; } function _ = function () { int _ = x; };
}
function basicWorkerTest2() returns error? {
    string? username = "ABC";
    if username is () { return; }
    string x = username; worker w { string y = x; } function _ = function () { string z = x; }; string _ = x;
}

function assertValueEquality(anydata expected, anydata actual) {
    if expected != actual { panic error("AssertionError", message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'"); }
}

public function main() {
    workerDeclTest();
    simpleWorkerMessagePassingTest();
    io:println(basicForkTest()); // @output 10
    io:println(forkWithMessageParsingTest()); // @output 5
    int forkWithWaitForAnyResult = checkpanic forkWithWaitForAny();
    io:println(forkWithWaitForAnyResult == 15 || forkWithWaitForAnyResult == 5); // @output true
    io:println(workerReturnTest()); // @output 51
    map<boolean> sameThread = workerSameThreadTest();
    io:println(sameThread["w"]); // @output false
    io:println(sameThread["w1"]); // @output false
    io:println(sameThread["w2"]); // @output false
    testSimpleSendActionWithCloneableType();
    testSimpleSendActionErrorType();
    testSimpleSendActionXMLType();
    testSimpleSendActionReadonlyRecord();
    testSimpleSendActionWithMapType();
    testSimpleSendActionWithListType();
    error? basicWorkerTest1Result = basicWorkerTest1();
    error? basicWorkerTest2Result = basicWorkerTest2();
    testWorkerMessagePassingRepeatedly();
    testPanicWithMessagePassing();
    testEarlyReturnWithMessagePassing();
}
