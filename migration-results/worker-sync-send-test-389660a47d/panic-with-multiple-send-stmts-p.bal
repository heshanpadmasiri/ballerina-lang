import ballerina/lang.runtime;

function panicWithMultipleSendStmtsTest() returns error? {
    @strand{thread:"any"}
    worker w1 returns error? {
        int a = 10;
        a + 5 -> w2;
        () result = a + 10 ->> w3;
        a + 15 -> w2;
        result = a + 20 ->> w3;
        return result;
    }

    @strand{thread:"any"}
    worker w2 {
        int b1 = <- w1;
        b1 -> w3;
        int b2 = <- w1;
        () result = b2 ->> w3;
        runtime:sleep(1.0);
    }

    @strand{thread:"any"}
    worker w3 returns string {
        int b = <- w1;
        if b == 2 {
            error err = error("err returned from w3");
            panic err;
        }
        b = <- w2;
        b += b;
        b = <- w2;
        if b > 10 {
            error err = error("err from panic from w3w3"); // @panic
            panic err;
        }
        b = <- w1;
        return "w3 received all send statments";
    }

    error? res = wait w1;
    return res;
}

public function main() {
    error? result = panicWithMultipleSendStmtsTest();
}
