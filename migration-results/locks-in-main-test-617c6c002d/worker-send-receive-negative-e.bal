// Migrated from LocksInMainTest.testWorkerSendReceiveInLockNegativeCases.
int a = 10;
int b = 20;

public function main() {
    worker w1 {
        lock {
            a += 1;
            3 ->> w2; // @error
            b += 1;
        }
    }
    worker w2 {
        lock {
            b += 1;
            int x = <- w1; // @error
            a += 1;
            x += 1;
        }
    }
}

public function test() {
    worker A {
        lock {
            int num = 10;
            num -> B; // @error
            // This marker covers both the unused-variable warning and the receive-action error.
            string msg = <- B; // @error
        }
    }
    worker B {
        lock {
            int num;
            num = <- A; // @error
            string msg = "Hello";
            msg -> A; // @error
            num += 1;
        }
    }
}
