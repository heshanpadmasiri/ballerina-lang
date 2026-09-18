// Migrated from LocksInMainTest.simpleLock.
import ballerina/test;

string simpleLockCounter = "not-started";

function testSimpleLock() {
    test:assertEquals(simpleLock(), "main in critical after w1 is out");
}

function simpleLock() returns string {
    @strand {thread: "any"}
    worker w1 {
        lock {
            simpleLockCounter = "w1 in critical";
            busyWait();
            busyWait();
            busyWait();
            busyWait();
            busyWait();
        }
        lock {
            simpleLockCounter = "w1 out of critical";
        }
    }

    busyWait();
    wait w1;
    if (getSimpleLockCounter() == "not-started") {
        return "main didn't wait for w1";
    }
    lock {
        busyWait();
        if (getSimpleLockCounter() == "w1 out of critical") {
            simpleLockCounter = "main in critical after w1 is out";
        }
    }
    return getSimpleLockCounter();
}

function getSimpleLockCounter() returns string {
    lock {
        return simpleLockCounter;
    }
}

function busyWait() {
    int i = 0;
    while (i < 10000000) {
        i += 1;
    }
}

public function main() {
    testSimpleLock();
}
