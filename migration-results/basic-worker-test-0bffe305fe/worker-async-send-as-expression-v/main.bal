import ballerina/io;

function keepIoImport(boolean shouldPrint) {
    if shouldPrint { io:println(""); }
}

function testAsyncSendAsExpressionReturnType() {
    worker w1 { () a = 5 -> w2; assertValueEquality(a, ()); var b = "Foo" -> w2; assertValueEquality(b, ()); }
    worker w2 { int x = <- w1; assertValueEquality(5, x); string y = <- w1; assertValueEquality("Foo", y); }
    _ = wait {w1, w2};
}
function testAsyncSendAsExpressionWithPanic() {
    worker w1 { () a = 5 -> w2; () b = 15 -> w2; assertValueEquality(b, ()); }
    worker w2 returns error? { int x = <- w1; if x == 5 { return error("This is an error"); } x = <- w1; }
    map<error?> mapResult = wait {w1, w2}; _ = mapResult;
}
function testAsyncSendAsExpressionWithTrapAndCheckExpr() {
    worker w1 { () a = check (5 -> w2); assertValueEquality(a, ()); error? b = trap (15 -> w2); if b is error { assertValueEquality("This is an error", b.message()); } else { assertValueEquality(b, ()); } }
    worker w2 returns error? { int x = <- w1; if x == 5 { return error("This is an error"); } x = <- w1; }
    map<error?> mapResult = wait {w1, w2}; _ = mapResult;
}
function testAsyncSendAsExpressionWithTypeCastExpr() {
    worker w1 { () a = <()>(5 -> w2); assertValueEquality((), a); }
    worker w2 { int x = <- w1; assertValueEquality(5, x); }
    _ = wait {w1, w2};
}
function testAsyncSendAsExpressionWithReturnStmt() {
    worker w1 { return (5 -> w2); }
    worker w2 { int x = <- w1; assertValueEquality(5, x); }
    _ = wait {w1, w2};
}
function testAsyncSendAsExpressionWithWildCardBindingPattern() {
    worker w1 { _ = 5 -> w2; }
    worker w2 { int x = <- w1; assertValueEquality(5, x); }
    _ = wait {w1, w2};
}
function testAsyncSendAsExpressionWithMatchStmt() {
    worker w1 { match (5 -> w2) { () => { return; } _ => { panic error("This is an error"); } } }
    worker w2 { int x = <- w1; assertValueEquality(5, x); }
    _ = wait {w1, w2};
}
function assertValueEquality(anydata expected, anydata actual) {
    if expected != actual { panic error("AssertionError", message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'"); }
}
public function main() {
    keepIoImport(false);
    testAsyncSendAsExpressionReturnType();
    testAsyncSendAsExpressionWithPanic();
    testAsyncSendAsExpressionWithTrapAndCheckExpr();
    testAsyncSendAsExpressionWithTypeCastExpr();
    testAsyncSendAsExpressionWithReturnStmt();
    testAsyncSendAsExpressionWithWildCardBindingPattern();
    testAsyncSendAsExpressionWithMatchStmt();
}
