import ballerina/lang.runtime;

function panicTest() returns error? {
    @strand{thread:"any"}
    worker w1 returns error? {
        int a = 10;
        a -> w2;
        var result = a ->> w3;
        a -> w2;
        result = a ->> w3;
        return result;
    }

    @strand{thread:"any"}
    worker w2 {
        int b = 15;
        runtime:sleep(0.01);
        b -> w3;
        b = <- w1;
        var result = b ->> w3;
        error? res = result;
        b = <- w1;
    }

    @strand{thread:"any"}
    worker w3 returns string|error {
        int b;
        b = <- w2;
        b = <- w1;
        b = <- w2;
        if b > 0 {
            error er3 = error("error3", message = "msg3"); // @panic
            panic er3;
        }
        b = <- w1;
        return "success";
    }

    error? w1Result = wait w1;
    return w1Result;
}

public function main() {
    error? result = panicTest();
}
