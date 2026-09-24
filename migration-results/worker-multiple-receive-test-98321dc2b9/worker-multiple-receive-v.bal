// Migrated from WorkerMultipleReceiveTest.
// The calls in main preserve the TestNG data-provider order.

import ballerina/io;
import ballerina/test;
import ballerina/lang.runtime;
import ballerina/lang.'error as errorLib;

function workerMultipleReceiveTest1() {
    worker w1 {
        2 -> w2;
    }

    worker w2 returns map<int> {
        map<int> result = <- { w1, w3};
        return result;
    }

    worker w3 {
        runtime:sleep(2);
        3 -> w2;
    }

    map<int> results = wait w2;
    io:println(results["w1"]); // @output 2
    test:assertEquals(results["w1"], 2, "Invalid int result");
    io:println(results["w3"]); // @output 3
    test:assertEquals(results["w3"], 3, "Invalid int result");
}

function workerMultipleReceiveTest2() {
    worker w1 {
        2 -> w2;
    }

    worker w2 returns map<int> {
        map<int> result = <- { a:w1, b:w3};
        return result;
    }

    worker w3 {
        runtime:sleep(2);
        3 -> w2;
    }

    map<int> results = wait w2;
    io:println(results["a"]); // @output 2
    test:assertEquals(results["a"], 2, "Invalid int result");
    io:println(results["b"]); // @output 3
    test:assertEquals(results["b"], 3, "Invalid int result");
}

function workerMultipleReceiveTest3() {
    worker w1 {
        100 -> w2;
        20 -> w2;
    }

    worker w2 returns map<anydata> {
        map<anydata> result = {};
        map<int> m = <- { a:w1, b:w3 };
        result["first"] = m;
        m = <- { aa:w1, bb:w3 };
        result["second"] = m;
        return result;
    }

    worker w3 {
        6 -> w2;
        45 -> w2;
    }

    map<anydata> mapResult = wait w2;
    io:println(mapResult["first"]); // @output {"a":100,"b":6}
    test:assertEquals(mapResult["first"], { "a":100, "b":6}, "Invalid map result");
    io:println(mapResult["second"]); // @output {"aa":20,"bb":45}
    test:assertEquals(mapResult["second"], { "aa":20, "bb":45}, "Invalid map result");
}

type MyRec record {|
    int firstValue;
    int secondValue;
|};

function workerMultipleReceiveWithUserDefinedRecord() {
    worker w1 {
        100 -> w2;
        20 -> w2;
    }

    worker w2 returns map<anydata> {
        map<anydata> result = {};
        MyRec m = <- { firstValue:w1, secondValue:w3 };
        result["first"] = m;
        m = <- { firstValue:w1, secondValue:w3 };
        result["second"] = m;
        return result;
    }

    worker w3 {
        6 -> w2;
        45 -> w2;
    }

    map<anydata> mapResult = wait w2;
    io:println(mapResult["first"]); // @output {"firstValue":100,"secondValue":6}
    test:assertEquals(mapResult["first"], {"firstValue":100,"secondValue":6}, "Invalid map result");
    io:println(mapResult["second"]); // @output {"firstValue":20,"secondValue":45}
    test:assertEquals(mapResult["second"], {"firstValue":20,"secondValue":45}, "Invalid map result");
}

function workerMultipleReceiveWithErrorReturn() {
    worker w1 returns error? {
        int v = 10;
        if v == 10 {
            return error("Error in worker w1");
        }
        100 -> w2;
    }

    worker w2 returns map<int|error> {
        map<int|error> m = <- { firstValue:w1, secondValue:w3 };
        return m;
    }

    worker w3 {
        6 -> w2;
    }

    map<int|error> mapResult = wait w2;
    io:println(mapResult["firstValue"] is error); // @output true
    test:assertTrue(mapResult["firstValue"] is error, "Invalid map result");
    error e = <error> mapResult["firstValue"];
    io:println(e.message()); // @output Error in worker w1
    test:assertEquals(e.message(), "Error in worker w1", "Invalid error message");
    io:println(mapResult["secondValue"]); // @output 6
    test:assertEquals(mapResult["secondValue"], 6, "Invalid int result");
}

function workerMultipleReceiveWithAllErrorReturn() {
    worker w1 returns error? {
        int v = 10;
        if v == 10 {
            return error("Error in worker w1");
        }
        100 -> w2;
    }

    worker w2 returns map<int|error> {
        map<int|error> m = <- { firstValue:w1, secondValue:w3 };
        return m;
    }

    worker w3 returns error? {
        int v = 10;
        if v == 10 {
            return error("Error in worker w3");
        }
        6 -> w2;
    }

    map<int|error> mapResult = wait w2;
    io:println(mapResult["firstValue"] is error); // @output true
    test:assertTrue(mapResult["firstValue"] is error, "Invalid map result");
    error e = <error> mapResult["firstValue"];
    io:println(e.message()); // @output Error in worker w1
    test:assertEquals(e.message(), "Error in worker w1", "Invalid error message");
    io:println(mapResult["secondValue"] is error); // @output true
    test:assertTrue(mapResult["secondValue"] is error, "Invalid map result");
    e = <error> mapResult["secondValue"];
    io:println(e.message()); // @output Error in worker w3
    test:assertEquals(e.message(), "Error in worker w3", "Invalid error message");
}

function workerMultipleReceiveWithPanic() {
    worker w1 {
        int v = 10;
        if v == 10 {
            panic error("Error in worker w1");
        }
        100 -> w2;
    }

    worker w2 returns map<int> {
        map<int> m = <- { firstValue:w1, secondValue:w3 };
        return m;
    }

    worker w3 {
        6 -> w2;
    }

    map<int>|error result = trap wait w2;
    io:println(result is error); // @output true
    test:assertTrue(result is error, "Invalid map result");
    error e = <error> result;
    io:println(e.message()); // @output Error in worker w1
    test:assertEquals(e.message(), "Error in worker w1", "Invalid error message");
}

function workerMultipleReceiveWithAllPanic() {
    worker w1 {
        runtime:sleep(2);
        int v = 10;
        if v == 10 {
            panic error("Error in worker w1");
        }
        100 -> w2;
    }

    worker w2 returns map<int> {
        map<int> m = <- { firstValue:w1, secondValue:w3 };
        return m;
    }

    worker w3 {
        int v = 10;
        if v == 10 {
            panic error("Error in worker w3");
        }
        6 -> w2;
    }

    map<int>|error result = trap wait w2;
    io:println(result is error); // @output true
    test:assertTrue(result is error, "Invalid map result");
    error e = <error> result;
    io:println(e.message()); // @output Error in worker w3
    test:assertEquals(e.message(), "Error in worker w3", "Invalid error message");
}

function workerMultipleReceiveWithErrorReturnRec() {
    worker w1 returns error? {
        int v = 10;
        if v == 10 {
            return error("Error in worker w1");
        }
        100 -> w2;
    }

    worker w2 returns ErrRec {
        ErrRec m = <- { firstValue:w1, secondValue:w3 };
        return m;
    }

    worker w3 {
        6 -> w2;
    }

    ErrRec mapResult = wait w2;
    io:println(mapResult.firstValue is error); // @output true
    test:assertTrue(mapResult.firstValue is error, "Invalid map result");
    error e = <error> mapResult.firstValue;
    io:println(e.message()); // @output Error in worker w1
    test:assertEquals(e.message(), "Error in worker w1", "Invalid error message");
    io:println(mapResult.secondValue); // @output 6
    test:assertEquals(mapResult.secondValue, 6, "Invalid int result");
}

type ErrRec record {|
    int|error firstValue;
    int secondValue;
|};

function workerMultipleReceiveWithConditionalSend1() {
    boolean foo = true;

    worker w1 {
        if foo {
            1 -> w2;
        } else {
            2 -> w3;
        }
    }

    worker w2 returns map<int|errorLib:NoMessage> {
        map<int|errorLib:NoMessage> m = <- {w1, w3};
        return m;
    }

    worker w3 {
        int|errorLib:NoMessage a = <- w1;
        io:println(a is error); // @output true
        test:assertTrue(a is error, "Invalid result");
        error e = <error> a;
        io:println(e.message()); // @output NoMessage
        test:assertEquals(e.message(), "NoMessage", "Invalid error message");
        io:println(e.detail().toString()); // @output {"message":"no message received from worker 'w1' to worker 'w3'"}
        test:assertEquals(e.detail().toString(), "{\"message\":\"no message received from worker 'w1' to worker 'w3'\"}", "Invalid error detail");
        3 -> w2;
    }

    map<int|errorLib:NoMessage> mapResult = wait w2;
    io:println(mapResult["w1"]); // @output 1
    test:assertEquals(mapResult["w1"], 1, "Invalid map result");
    io:println(mapResult["w3"]); // @output 3
    test:assertEquals(mapResult["w3"], 3, "Invalid map result");
}

function workerMultipleReceiveWithConditionalSend2() {
    boolean foo = true;

    worker w1 {
        if foo {
            1 -> w3;
        } else {
            2 -> w2;
        }
    }

    worker w2 returns map<int|errorLib:NoMessage> {
        map<int|errorLib:NoMessage> m = <- {w1, w3};
        return m;
    }

    worker w3 {
        int|errorLib:NoMessage a = <- w1;
        io:println(a is int); // @output true
        test:assertTrue(a is int, "Invalid result");
        io:println(a); // @output 1
        test:assertEquals(a, 1, "Invalid int result");
        3 -> w2;
    }

    map<int|errorLib:NoMessage> mapResult = wait w2;
    io:println(mapResult["w1"] is errorLib:NoMessage); // @output true
    test:assertTrue(mapResult["w1"] is errorLib:NoMessage, "Invalid map result");
    errorLib:NoMessage e = <errorLib:NoMessage> mapResult["w1"];
    io:println(e.message()); // @output NoMessage
    test:assertEquals(e.message(), "NoMessage", "Invalid error message");
    io:println(e.detail().toString()); // @output {"message":"no message received from worker 'w1' to worker 'w2'"}
    test:assertEquals(e.detail().toString(), "{\"message\":\"no message received from worker 'w1' to worker 'w2'\"}", "Invalid error detail");
    io:println(mapResult["w3"]); // @output 3
    test:assertEquals(mapResult["w3"], 3, "Invalid map result");
}

function workerMultipleReceiveWithConditionalSend3() {
    worker w1 {
        boolean b1 = true;
        boolean b2 = true;
        boolean b3 = false;

        if b1 {
            1 -> function;
        } else if b2 {
            2 -> function;
        } else if b3 {
            3 -> function;
        } else {
            4 -> function;
        }
    }

    map<int|errorLib:NoMessage> mapResult = <- {a:w1, b:w1, c:w1, d:w1};
    io:println(mapResult["a"]); // @output 1
    test:assertEquals(mapResult["a"], 1);

    int|errorLib:NoMessage? bResult = mapResult["b"];
    io:println(bResult is errorLib:NoMessage); // @output true
    test:assertTrue(bResult is errorLib:NoMessage);
    errorLib:NoMessage e = <errorLib:NoMessage> bResult;
    io:println(e.message()); // @output NoMessage
    test:assertEquals(e.message(), "NoMessage", "Invalid error message");
    io:println(e.detail().toString()); // @output {"message":"no message received from worker 'w1' to worker 'function'"}
    test:assertEquals(e.detail().toString(), "{\"message\":\"no message received from worker 'w1' to worker 'function'\"}", "Invalid error detail");

    io:println(mapResult["c"] is errorLib:NoMessage); // @output true
    test:assertTrue(mapResult["c"] is errorLib:NoMessage);
    io:println(mapResult["d"] is errorLib:NoMessage); // @output true
    test:assertTrue(mapResult["d"] is errorLib:NoMessage);
}

public function main() {
    workerMultipleReceiveTest1();
    workerMultipleReceiveTest2();
    workerMultipleReceiveTest3();
    workerMultipleReceiveWithUserDefinedRecord();
    workerMultipleReceiveWithErrorReturn();
    workerMultipleReceiveWithAllErrorReturn();
    workerMultipleReceiveWithPanic();
    workerMultipleReceiveWithAllPanic();
    workerMultipleReceiveWithErrorReturnRec();
    workerMultipleReceiveWithConditionalSend1();
    workerMultipleReceiveWithConditionalSend2();
    workerMultipleReceiveWithConditionalSend3();
}
