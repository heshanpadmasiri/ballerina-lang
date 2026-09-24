import ballerina/lang.runtime;

string append2 = "";

function panicTest() returns error? {
    worker w1 returns error? {
        int a = 10;
        var sync = a ->> w2;
        any|error res = sync;
        ignore(res);
        a -> w3;
        a -> w2;
        error? result = flush;
        foreach var i in 1 ... 5 {
            append2 += "w1";
        }
        return result;
    }
    worker w2 returns error? {
        if 0 > 1 {
            return error("err", message = "err msg");
        }
        sleep(5);
        foreach var i in 1 ... 5 {
            append2 += "w2";
        }
        int b = <- w1;
        b = <- w1;
        _ = b;
    }
    worker w3 returns error|string {
        sleep(5);
        int k;
        foreach var i in 1 ... 5 {
            append2 += "w3";
            k = i;
        }
        if k > 3 {
            map<string> reason = {k1: "error3"};
            string errorReason = reason["k1"] ?: "";
            error er3 = error(errorReason, message = "msg3"); // @panic
            panic er3;
        }
        int b = <- w1;
        _ = b;
        return "done";
    }
    return wait w1;
}

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000.0);
}

public function main() {
    error? result = panicTest();
    ignore(result);
}

function ignore(any|error value) {
}
