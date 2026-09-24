function syncSendWithPanicInReceive() {
    @strand{thread:"any"}
    worker w1 {
        int a = 10;
        () r1 = a ->> w2;
        () r2 = a + a ->> w2;
    }

    @strand{thread:"any"}
    worker w2 {
        int b1 = <- w1;
        if 0 < 1 {
            error err = error("err from panic from w2"); // @panic
            panic err;
        }
        int b2 = <- w1;
    }
    wait w1;
}

public function main() {
    syncSendWithPanicInReceive();
}
