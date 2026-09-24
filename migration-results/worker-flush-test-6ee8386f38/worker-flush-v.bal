import ballerina/io;
import ballerina/lang.runtime;

string append = "";

function singleFlush() returns string {
    worker w1 {
        int a = 10;
        a -> w2;
        error? result = flush w2;
        ignore(result);
        foreach var i in 1 ... 5 {
            append += "w1";
        }
    }
    worker w2 {
        foreach var i in 1 ... 5 {
            append += "w2";
        }
        int b = <- w1;
        _ = b;
    }
    wait w1;
    return append;
}

string append1 = "";

function flushReturn() returns error? {
    worker w1 returns error? {
        int a = 10;
        a -> w2;
        a -> w2;
        error? result = flush w2;
        foreach var i in 1 ... 5 {
            append1 += "w1";
        }
        return result;
    }
    worker w2 {
        foreach var i in 1 ... 5 {
            append1 += "w2";
        }
        int b = <- w1;
        b = <- w1;
        _ = b;
    }
    return wait w1;
}

string append2 = "";

function flushAll() returns string {
    worker w1 {
        int a = 10;
        var sync = a ->> w2;
        any|error res = sync;
        ignore(res);
        a -> w3;
        a -> w2;
        error? result = flush;
        ignore(result);
        foreach var i in 1 ... 5 {
            append2 += "w1";
        }
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
    worker w3 {
        sleep(5);
        foreach var i in 1 ... 5 {
            append2 += "w3";
        }
        int b = <- w1;
        _ = b;
    }
    wait w1;
    return append2;
}

function errorTest() {
    var inner1 = function() returns error? {
        worker w1 returns error? {
            20 -> w3;
            30 -> w2;
            return flush;
        }
        worker w2 {
            int asyncD = <- w1;
            _ = asyncD;
        }
        worker w3 returns error? {
            int k = 1;
            if k > 0 {
                return error("err3");
            }
            int b = <- w1;
            _ = b;
        }
        return wait w1;
    };
    var inner2 = function() returns error? {
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
                return error(errorReason, message = "msg3");
            }
            int b = <- w1;
            _ = b;
            return "done";
        }
        return wait w1;
    };
    foreach int i in 0 ... 100 {
        future<error?> futureResult = start inner1();
        error? unionResult = wait futureResult;
        validateError(unionResult, "err3");
    }
    foreach int i in 0 ... 10 {
        validateError(inner2(), "error3");
    }
}

function flushInDefaultError() {
    var inner = function() returns error? {
        worker w2 returns error? {
            int a = 0;
            int b = 15;
            if 0 < 1 {
                return error("err", message = "err msg");
            }
            a = <- function;
            b += a;
            b -> function;
        }
        int a = 10;
        a -> w2;
        error? res = flush;
        error|int c = <- w2;
        ignore(c);
        return res;
    };
    validateError(inner(), "err");
}

function flushInDefault() returns int {
    worker w2 {
        int a = 0;
        int b = 15;
        a = <- function;
        b += a;
        b -> function;
    }
    int a = 10;
    a -> w2;
    error? res = flush;
    ignore(res);
    return <- w2;
}

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000.0);
}

function validateError(any|error value, string message) {
    if value is error {
        if value.message() == message {
            return;
        }
        panic error("Expected error message: " + message + ", found: " + value.message());
    }
    panic error("Expected error, found: " + (typeof value).toString());
}

function ignore(any|error value) {
}

public function main() {
    io:println(singleFlush()); // @output w2w2w2w2w2w1w1w1w1w1
    io:println(flushReturn()); // @output
    io:println(flushAll().startsWith("w1")); // @output false
    errorTest();
    flushInDefaultError();
    io:println(flushInDefault()); // @output 25
}
