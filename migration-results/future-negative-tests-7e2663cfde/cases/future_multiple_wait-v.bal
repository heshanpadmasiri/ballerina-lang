import ballerina/io;

public function main() {
    io:println(testWaitTwiceOnSingleFuture()); // @output error("multiple waits on the same future is not allowed")

    record {|int|error r1; int|error r2;|} twiceOnTwo = testMultipleWaitTwiceOnTwoFutures();
    io:println(twiceOnTwo.r1); // @output error("multiple waits on the same future is not allowed")
    io:println(twiceOnTwo.r2); // @output error("multiple waits on the same future is not allowed")

    record {|int|error r1; int|error r2;|} twiceOnDifferent = testMultipleWaitTwiceOnDifferentFutures();
    io:println(twiceOnDifferent.r1); // @output error("multiple waits on the same future is not allowed")
    io:println(twiceOnDifferent.r2); // @output 12

    io:println(testAlternateWaitTwiceOnTwoFutures()); // @output error("multiple waits on the same future is not allowed")
    io:println(testMultipleWaitAndAlternateWait()); // @output error("multiple waits on the same future is not allowed")
    io:println(testWaitError()); // @output error("multiple waits on the same future is not allowed")
}

public function testWaitTwiceOnSingleFuture() returns int|error {
    future<int|error> f4 = start calculate(9, 8);
    int|error r = wait f4;
    int|error r1 = wait f4;
    return r1;
}

public function testMultipleWaitTwiceOnTwoFutures() returns record {|int|error r1; int|error r2;|} {
    future<int|error> f4 = start calculate(9, 8);
    future<int|error> f5 = start calculate(5, 4);
    record {|int|error r1; int|error r2;|} result = wait {r1: f4, r2: f5};
    record {|int|error r1; int|error r2;|} result1 = wait {r1: f4, r2: f5};
    return result1;
}

public function testMultipleWaitTwiceOnDifferentFutures() returns record {|int|error r1; int|error r2;|} {
    future<int> f1 = start calculate(3, 4);
    future<int|error> f4 = start calculate(9, 8);
    future<int|error> f5 = start calculate(5, 4);
    record {|int|error r1; int|error r2;|} result = wait {r1: f4, r2: f5};
    record {|int|error r1; int|error r2;|} result1 = wait {r1: f4, r2: f1};
    return result1;
}

public function testAlternateWaitTwiceOnTwoFutures() returns int|error {
    future<int|error> f4 = start calculate(9, 8);
    future<int|error> f5 = start calculate(5, 4);
    int|error result = wait f4|f5;
    int|error result1 = wait f4|f5;
    int|error r1 = wait f4|f5;
    return r1;
}

public function testMultipleWaitAndAlternateWait() returns int|error {
    future<int|error> f4 = start calculate(9, 8);
    future<int|error> f5 = start calculate(5, 4);
    record {|int|error r1; int|error r2;|} result = wait {r1: f4, r2: f5};
    int|error r1 = wait f4;
    return r1;
}

public function testWaitError() returns error {
    future<error> f1 = @strand {thread: "any"} start getError();
    future<error> f2 = @strand {thread: "any"} start getError();
    error result = wait f1|f2;
    error r1 = wait f1;
    return r1;
}

function calculate(int a, int b) returns int {
    return a * b;
}

function getError() returns error {
    return error("This is an error");
}
