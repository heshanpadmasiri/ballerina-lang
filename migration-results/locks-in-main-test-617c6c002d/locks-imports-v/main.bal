import ballerina/lang.runtime;
import locks_in_imports_test_project.mod1;

function testLockWithInvokableChainsAccessingGlobal() {
    @strand {thread: "any"}
    worker w1 {
        lock {
            sleep(20);
            mod1:chain(1, true);
        }
    }
    @strand {thread: "any"}
    worker w2 {
        lock {
            sleep(20);
            mod1:chain2(2, true);
        }
    }
    sleep(20);
    var [recurs1, recurs2] = mod1:getValues();
    if (recurs2 == 20 || recurs1 == 20) {
        panic error("Invalid Value");
    }
}

public function main() {
    testLockWithInvokableChainsAccessingGlobal();
}

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000);
}
