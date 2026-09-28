import ballerina/lang.runtime; import ballerina/io; import ballerina/time;

function testSleep() {
    runtime:sleep(1);
}

public function main() {
    time:Utc startTime = time:utcNow();
    testSleep();
    time:Utc endTime = time:utcNow();
    int elapsedSeconds = endTime[0] - startTime[0];
    boolean sleptForOneSecond = elapsedSeconds > 1 ||
        (elapsedSeconds == 1 && endTime[1] >= startTime[1]);
    io:println(sleptForOneSecond); // @output true
}
