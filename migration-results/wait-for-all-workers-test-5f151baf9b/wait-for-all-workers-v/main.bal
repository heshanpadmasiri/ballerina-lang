import ballerina/io;
import ballerina/lang.runtime;

public function main() {
    testWaitForAllWorkers();
}

public function testWaitForAllWorkers() {
    worker w1 {
        return;
    }

    worker w2 {
        runtime:sleep(2);
        finishWorker();
    }

    io:println("Finishing Default Worker"); // @output Finishing Default Worker
    wait w2;
}

function finishWorker() {
    io:println("Finishing Worker w2"); // @output Finishing Worker w2
}
