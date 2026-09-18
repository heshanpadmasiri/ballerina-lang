import ballerina/io;
import ballerina/lang.runtime;

int i = 0;

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000.0);
}

function testVoidFunction() returns int {
    testVoid();
    sleep(1500);
    return i;
}

function testVoid() {
    @strand{thread:"any"}
    worker w1 {
        sleep(3000);
        testNew();
    }
    @strand{thread:"any"}
    worker w2 {
        int x = i + 10;
        i = 10;
    }
}

function testNew() {
    @strand{thread:"any"}
    worker w1 {
        sleep(2000);
    }
    @strand{thread:"any"}
    worker w2 {
        i = 5;
    }
}

public function main() {
    io:println(testVoidFunction()); // @output 10
}
