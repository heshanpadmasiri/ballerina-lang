import ballerina/io;
import ballerina/lang.runtime;

function workerAlternateReceiveTest() {
    worker w1 { 2 -> w2; }
    worker w2 returns int {
        int result = <- w1 | w3;
        return result;
    }
    worker w3 { runtime:sleep(2); 3 -> w2; }
    worker w4 { runtime:sleep(2); 2 -> w5; }
    worker w5 returns int {
        int result = <- w4 | w6;
        return result;
    }
    worker w6 { 3 -> w5; }
    map<int> results = wait {a: w2, b: w5};
    io:println(results["a"]); // @output 2
    io:println(results["b"]); // @output 3
}

function workerAlternateReceiveTest2() {
    worker w1 { runtime:sleep(2); 1 -> w5; }
    worker w2 { runtime:sleep(3); 2 -> w5; }
    worker w3 { 3 -> w5; }
    worker w4 { runtime:sleep(4); 4 -> w5; }
    worker w5 returns int {
        int result = <- w1 | w2 | w3 | w4;
        return result;
    }
    int result = wait w5;
    io:println(result); // @output 3
}

function alternateReceiveWithSenderPanic() {
    worker w1 {
        int value = 10;
        if value == 10 { panic error("Error in worker 1"); }
        value -> w2;
    }
    worker w2 returns int {
        int a = <- w1 | w3;
        return a;
    }
    worker w3 { runtime:sleep(2); 3 -> w2; }
    int|error unionResult = trap wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    io:println(e.message()); // @output Error in worker 1
}

function alternateReceiveWithMultiplePanic() {
    worker w1 {
        int value = 10;
        if value == 10 { panic error("Error in worker 1"); }
        value -> w2;
    }
    worker w2 returns int {
        int a = <- w1 | w3;
        return a;
    }
    worker w3 {
        int value = 10;
        if value == 10 { panic error("Error in worker 3"); }
        3 -> w2;
    }
    int|error unionResult = trap wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    boolean validError = e.message() == "Error in worker 1" || e.message() == "Error in worker 3";
    io:println(validError); // @output true
}

function alternateReceiveWithSenderError() {
    worker w1 returns error? {
        int value = 10;
        if value == 10 { return error("Error in worker 1"); }
        value -> w2;
    }
    worker w2 returns int|error {
        int|error a = <- w1 | w3;
        return a;
    }
    worker w3 { runtime:sleep(2); 3 -> w2; }
    int|error unionResult = wait w2;
    io:println(unionResult is int); // @output true
    io:println(unionResult); // @output 3
}

function alternateReceiveWithMultipleError() {
    worker w1 returns error? {
        int value = 10;
        if value == 10 { return error("Error in worker 1"); }
        value -> w2;
    }
    worker w2 returns int|error {
        int|error a = <- w1 | w3;
        return a;
    }
    worker w3 returns error? {
        int value = 10;
        runtime:sleep(2);
        if value == 10 { return error("Error in worker 3"); }
        value -> w2;
    }
    int|error unionResult = wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    io:println(e.message()); // @output Error in worker 3
}

function alternateReceiveWithPanicAndError() {
    worker w1 {
        int value = 10;
        if value == 10 { panic error("Error in worker 1"); }
        value -> w2;
    }
    worker w2 returns int|error {
        int|error a = <- w1 | w3;
        return a;
    }
    worker w3 returns error? {
        int value = 10;
        if value == 10 { return error("Error in worker 3"); }
        value -> w2;
    }
    int|error unionResult = trap wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    io:println(e.message()); // @output Error in worker 1
}

function alternateReceiveWithReceiverPanic() {
    worker w1 { 10 -> w2; }
    worker w2 returns int {
        int value = 10;
        if value == 10 { panic error("Error in worker 2"); }
        int a = <- w1 | w3;
        return a;
    }
    worker w3 { 3 -> w2; }
    int|error unionResult = trap wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    io:println(e.message()); // @output Error in worker 2
}

function alternateReceiveWithReceiverError() {
    worker w1 { 10 -> w2; }
    worker w2 returns int|error {
        int value = 10;
        if value == 10 { return error("Error in worker 2"); }
        int a = <- w1 | w3;
        return a;
    }
    worker w3 { 3 -> w2; }
    int|error unionResult = wait w2;
    io:println(unionResult is error); // @output true
    error e = <error>unionResult;
    io:println(e.message()); // @output Error in worker 2
}

function alternateReceiveWithSameWorkerSend() {
    worker w1 { 1 -> w2; 2 -> w2; }
    worker w2 returns int {
        int x = <- w1 | w1;
        return x;
    }
    int intResult = wait w2;
    io:println(intResult); // @output 1
}

function alternateReceiveWithSameWorkerSendError1() {
    worker w1 {
        int|error x = int:fromString("invalid");
        x -> w2;
        2 -> w2;
    }
    worker w2 returns int|error {
        int|error x = <- w1 | w1;
        return x;
    }
    int|error intResult = wait w2;
    io:println(intResult); // @output 2
}

function alternateReceiveWithSameWorkerSendError2() {
    worker w1 {
        int|error x = int:fromString("invalid");
        x -> w2;
        x -> w2;
    }
    worker w2 returns int|error {
        int|error x = <- w1 | w1;
        return x;
    }
    int|error intResult = wait w2;
    io:println(intResult is error); // @output true
    error e = <error>intResult;
    io:println(e.message()); // @output {ballerina/lang.int}NumberParsingError
    io:println(e.detail().toString()); // @output {"message":"'string' value 'invalid' cannot be converted to 'int'"}
}

function alternateReceiveWithSameWorkerSendPanic() {
    worker w1 {
        int x = checkpanic int:fromString("invalid");
        x -> w2;
        2 -> w2;
    }
    worker w2 returns int {
        int x = <- w1 | w1;
        return x;
    }
    int|error intResult = trap wait w2;
    io:println(intResult is error); // @output true
    error e = <error>intResult;
    io:println(e.message()); // @output {ballerina/lang.int}NumberParsingError
    io:println(e.detail().toString()); // @output {"message":"'string' value 'invalid' cannot be converted to 'int'"}
}

function multilpleAlternateReceive1() {
    worker w1 { 1 -> w2; 2 -> w2; }
    worker w2 returns [int, int] {
        int x = <- w1 | w3;
        int y = <- w1;
        return [x, y];
    }
    worker w3 { runtime:sleep(2); 3 -> w2; }
    [int, int] [x, y] = wait w2;
    io:println(x); // @output 1
    io:println(y); // @output 2
}

function multilpleAlternateReceive2() {
    worker w1 { runtime:sleep(2); 1 -> w2; 2 -> w2; }
    worker w2 returns [int, int] {
        int x = <- w1 | w3;
        int y = <- w1;
        return [x, y];
    }
    worker w3 { 3 -> w2; }
    [int, int] [x, y] = wait w2;
    io:println(x); // @output 3
    io:println(y); // @output 2
}

public function main() {
    workerAlternateReceiveTest();
    workerAlternateReceiveTest2();
    alternateReceiveWithSenderPanic();
    alternateReceiveWithMultiplePanic();
    alternateReceiveWithSenderError();
    alternateReceiveWithMultipleError();
    alternateReceiveWithPanicAndError();
    alternateReceiveWithReceiverPanic();
    alternateReceiveWithReceiverError();
    alternateReceiveWithSameWorkerSend();
    alternateReceiveWithSameWorkerSendError1();
    alternateReceiveWithSameWorkerSendError2();
    alternateReceiveWithSameWorkerSendPanic();
    multilpleAlternateReceive1();
    multilpleAlternateReceive2();
}
