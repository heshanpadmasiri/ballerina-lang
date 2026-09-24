function invalidWorkerReceiveBeforeWorker() {
    int _ = <- w1; // @error
    worker w1 {
        int i = 1;
        i -> function;
    }
}

function workerReceiveAfterNonErrorReturn1() {
    worker w1 {
        1 ->> w2;
        2 ->> w2;
    }
    worker w2 {
        boolean b = true;
        int _ = <- w1;
        if b {
            return;
        }
        int _ = <- w1; // @error
    }
    wait w1;
}

function workerReceiveAfterNonErrorReturn2() {
    worker w1 {
        1 ->> w2;
        2 ->> w2;
    }
    worker w2 {
        boolean b = true;
        if b {
            return;
        }
        int _ = <- w1|w1; // @error @error
    }
    wait w1;
}
