// Migrated from the shared locksCompileResult invocations in LocksInMainTest.
import ballerina/lang.'int as ints;
import ballerina/lang.runtime;
import ballerina/test;

int lockWithinLockInt1 = 0;
string lockWithinLockString1 = "";
byte[] blobValue = [];
boolean boolValue = false;

function resetlockWithinLockInt1() {
    lock { lockWithinLockInt1 = 0; }
}

function testLockWithinLock() {
    test:assertEquals(lockWithinLock(), [77, "second sample value"]);
}

function lockWithinLock() returns [int, string] {
    lock {
        lockWithinLockInt1 = 50;
        lockWithinLockString1 = "sample value";
        lock {
            lockWithinLockString1 = "second sample value";
            lockWithinLockInt1 = 99;
            lock { lockWithinLockInt1 = 90; }
        }
        lockWithinLockInt1 = 77;
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testLockWithinLockInWorkers() {
    test:assertEquals(lockWithinLockInWorkers(), [66, "sample output"]);
}

function lockWithinLockInWorkers() returns [int, string] {
    @strand {thread: "any"}
    worker w1 {
        lock {
            lockWithinLockInt1 = 90;
            lockWithinLockString1 = "sample output";
            lock { lockWithinLockInt1 = 66; }
            sleep(100);
            lockWithinLockInt1 = 45;
        }
    }
    @strand {thread: "any"}
    worker w2 {
        sleep(20);
        lock {
            lockWithinLockString1 = "hello";
            lock { lockWithinLockInt1 = 88; }
            lockWithinLockInt1 = 56;
        }
    }
    sleep(30);
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testLockInsideWhileLoop() {
    test:assertEquals(lockInsideWhileLoop(), 56);
}

function lockInsideWhileLoop() returns int {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w2 {
        sleep(10);
        lock { lockWithinLockInt1 += 50; }
    }
    int i = 0;
    while (i < 6) {
        lock { lockWithinLockInt1 += 1; }
        i += 1;
        sleep(10);
    }
    return lockWithinLockInt1;
}

function convertStringToInt() {
    lock {
        sleep(50);
        lockWithinLockInt1 += 1;
        lockWithinLockString1 = "hello";
        var result = ints:fromString(lockWithinLockString1);
        if (result is error) { panic result; }
    }
}

function testThrowErrorInsideLock() {
    var [intResult, stringResult] = throwErrorInsideLock();
    test:assertEquals(intResult, 51);
    test:assertTrue(stringResult is "second worker string" || stringResult is "hello");
}

function throwErrorInsideLock() returns [int, string] {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w1 { lock { convertStringToInt(); } }
    sleep(10);
    lock {
        lockWithinLockString1 = "second worker string";
        lockWithinLockInt1 += 50;
    }
    error? waitResult = trap wait w1;
    test:assertTrue(waitResult is error);
    if (waitResult is error) {
        test:assertEquals(waitResult.message(), "{ballerina/lang.int}NumberParsingError");
    }
    lock { return [lockWithinLockInt1, lockWithinLockString1]; }
}

function errorPanicInsideLock() { lock { convertStringToInt(); } }

function testThrowErrorInsideLockInsideTrap() {
    test:assertEquals(throwErrorInsideLockInsideTryFinally(), [53,
        "worker 2 sets the string value after try catch finally"]);
}

function throwErrorInsideLockInsideTryFinally() returns [int, string] {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w2 {
        sleep(10);
        lock {
            lockWithinLockString1 = "worker 2 sets the string value after try catch finally";
            lockWithinLockInt1 += 50;
        }
    }
    var err = trap errorPanicInsideLock();
    wait w2;
    if (err is error) {
        sleep(10);
        lock { lockWithinLockInt1 += 1; }
    }
    lock { lockWithinLockInt1 += 1; }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testThrowErrorInsideTryCatchFinallyInsideLock() {
    test:assertEquals(throwErrorInsideTryCatchFinallyInsideLock(), [53,
        "worker 2 sets the string after try catch finally inside lock"]);
}

function throwErrorInsideTryCatchFinallyInsideLock() returns [int, string] {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w2 {
        sleep(10);
        lock {
            lockWithinLockString1 = "worker 2 sets the string after try catch finally inside lock";
            lockWithinLockInt1 += 50;
        }
    }
    lock {
        var err = trap convertStringToInt();
        if (err is error) {
            sleep(10);
            lock { lockWithinLockInt1 += 1; }
        }
        lock { lockWithinLockInt1 += 1; }
    }
    wait w2;
    sleep(10);
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testThrowErrorInsideTryFinallyInsideLock() {
    test:assertEquals(throwErrorInsideTryFinallyInsideLock(), [552,
        "worker 2 sets the string after try finally"]);
}

function throwErrorInsideTryFinallyInsideLock() returns [int, string] {
    lock { lockWithinLockInt1 = 500; }
    @strand {thread: "any"}
    worker w1 {
        lock {
            sleep(50);
            lockWithinLockInt1 += 1;
            lockWithinLockString1 = "hello";
            var result = ints:fromString(lockWithinLockString1);
            if (result is error) {
                lock { lockWithinLockInt1 += 1; }
                panic result;
            }
        }
    }
    sleep(10);
    error? w1Result = trap wait w1;
    test:assertTrue(w1Result is error);
    lock {
        lockWithinLockString1 = "worker 2 sets the string after try finally";
        lockWithinLockInt1 += 50;
    }
    lock { return [lockWithinLockInt1, lockWithinLockString1]; }
}

function testThrowErrorInsideLockInsideTryCatch() {
    test:assertEquals(throwErrorInsideLockInsideTryCatch(), [52,
        "worker 2 sets the string value after try catch"]);
}

function throwErrorInsideLockInsideTryCatch() returns [int, string] {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w2 {
        sleep(10);
        lock {
            lockWithinLockString1 = "worker 2 sets the string value after try catch";
            lockWithinLockInt1 += 50;
        }
    }
    var err = trap errorPanicInsideLock();
    wait w2;
    if (err is error) {
        sleep(10);
        lock { lockWithinLockInt1 += 1; }
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testThrowErrorInsideTryCatchInsideLock() {
    test:assertEquals(throwErrorInsideTryCatchInsideLock(), [52,
        "worker 2 sets the string after try catch inside lock"]);
}

function throwErrorInsideTryCatchInsideLock() returns [int, string] {
    resetlockWithinLockInt1();
    @strand {thread: "any"}
    worker w2 {
        sleep(10);
        lock {
            lockWithinLockString1 = "worker 2 sets the string after try catch inside lock";
            lockWithinLockInt1 += 50;
        }
    }
    lock {
        var err = trap convertStringToInt();
        if (err is error) {
            sleep(10);
            lock { lockWithinLockInt1 += 1; }
        }
    }
    wait w2;
    sleep(10);
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testLockWithinLockInWorkersForBlobAndBoolean() {
    test:assertEquals(lockWithinLockInWorkersForBlobAndBoolean(), [true, "sample blob output".toBytes()]);
}

function lockWithinLockInWorkersForBlobAndBoolean() returns [boolean, byte[]] {
    @strand {thread: "any"}
    worker w1 {
        lock {
            boolValue = true;
            blobValue = "sample blob output".toBytes();
            lock { boolValue = true; }
            sleep(100);
        }
    }
    @strand {thread: "any"}
    worker w2 {
        sleep(20);
        lock {
            boolValue = false;
            lock { blobValue = "wrong output".toBytes(); }
            boolValue = false;
        }
    }
    sleep(30);
    return [boolValue, blobValue];
}

function testReturnInsideLock() { test:assertEquals(returnInsideLock(), [88, "changed value11"]); }

function returnInsideLock() returns [int, string] {
    @strand {thread: "any"}
    worker w1 { test:assertEquals(returnInsideLockPart(), "value1"); }
    sleep(10);
    wait w1;
    lock {
        if (lockWithinLockInt1 == 44) {
            lockWithinLockString1 = "changed value11";
            lockWithinLockInt1 = 88;
        } else {
            lockWithinLockString1 = "wrong value";
            lockWithinLockInt1 = 34;
        }
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function returnInsideLockPart() returns string {
    lock {
        lockWithinLockInt1 = 44;
        lockWithinLockString1 = "value1";
        return lockWithinLockString1;
    }
}

function testBreakInsideLock() {
    test:assertEquals(breakInsideLock(), [657, "lock value inside second worker after while"]);
}

function breakInsideLock() returns [int, string] {
    @strand {thread: "any"}
    worker w1 {
        int i = 0;
        while (i < 3) {
            lock {
                lockWithinLockInt1 = 40;
                lockWithinLockString1 = "lock value inside while";
                if (i == 0) { break; }
            }
            i += 1;
        }
    }
    sleep(20);
    lock {
        if (lockWithinLockInt1 == 40) {
            lockWithinLockInt1 = 657;
            lockWithinLockString1 = "lock value inside second worker after while";
        } else {
            lockWithinLockInt1 = 3454;
            lockWithinLockString1 = "wrong value";
        }
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function testNextInsideLock() {
    test:assertEquals(nextInsideLock(), [657, "lock value inside second worker after while"]);
}

function nextInsideLock() returns [int, string] {
    @strand {thread: "any"}
    worker w1 {
        int i = 0;
        while (i < 1) {
            i += 1;
            lock {
                lockWithinLockInt1 = 40;
                lockWithinLockString1 = "lock value inside while";
                if (i == 0) { continue; }
            }
        }
    }
    sleep(20);
    lock {
        if (lockWithinLockInt1 == 40) {
            lockWithinLockInt1 = 657;
            lockWithinLockString1 = "lock value inside second worker after while";
        } else {
            lockWithinLockInt1 = 3454;
            lockWithinLockString1 = "wrong value";
        }
    }
    return [lockWithinLockInt1, lockWithinLockString1];
}

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000);
}

public function main() {
    testLockWithinLock();
    testLockWithinLockInWorkers();
    testLockInsideWhileLoop();
    testThrowErrorInsideLock();
    testThrowErrorInsideLockInsideTrap();
    testThrowErrorInsideTryCatchFinallyInsideLock();
    testThrowErrorInsideTryFinallyInsideLock();
    testThrowErrorInsideLockInsideTryCatch();
    testThrowErrorInsideTryCatchInsideLock();
    testLockWithinLockInWorkersForBlobAndBoolean();
    testReturnInsideLock();
    testBreakInsideLock();
    testNextInsideLock();
}
