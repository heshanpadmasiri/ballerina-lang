function multipleSyncSendWithPanicInSend() returns int {
    @strand{thread:"any"}
    worker w1 returns int {
        int a = 10;
        () r1 = a ->> w2;
        if 0 < 1 {
            error err = error("err from panic from w1 w1"); // @panic
            panic err;
        }
        () r2 = a + 10 ->> w2;
        if 0 < 1 {
            error err = error("err from panic from w1 w1");
            panic err;
        }
        return a;
    }

    @strand{thread:"any"}
    worker w2 {
        int b = 0;
        b = <- w1;
        b = <- w1;
    }
    return wait w1;
}

public function main() {
    int result = multipleSyncSendWithPanicInSend();
}
