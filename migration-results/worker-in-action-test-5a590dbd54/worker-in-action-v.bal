import ballerina/io;
import ballerina/lang.runtime;

public type ClientEndpointConfiguration record {};

public client class ABCClient {
    remote function testAction1() returns string {
        worker sampleWorker {
            string m = <- function;
            string v = m == "xxx" ? "result from sampleWorker" : "";
            v -> function;
        }

        "xxx" -> sampleWorker;
        string result = <- sampleWorker;
        return result;
    }

    remote function testAction2() returns string {
        worker sampleWorker {
            "request" -> function;
        }

        string result = <- sampleWorker;
        return result;
    }
}

function testAction1() returns string {
    ABCClient ep1 = new;
    string x = ep1->testAction1();
    return x;
}

function testAction2() returns string {
    ABCClient ep1 = new;
    string x = ep1->testAction2();
    return x;
}

string testStr = "";

function testDefaultError() returns string {
    error? res = test1(5);
    consumeError(res);
    test2();
    runtime:sleep(0.2);
    return testStr;
}

function test1(int c) returns error|() {
    worker w1 returns int {
        int|error a = <- function;
        consumeIntOrError(a);
        testStr = "REACHED";
        return 8;
    }
    int b = 9;

    if 0 < 1 {
        error e = error("error occurred");
        return e;
    }
    b -> w1;
    return;
}

function test2() {}

function consumeError(error? value) {}

function consumeIntOrError(int|error value) {}

public function main() {
    io:println(testAction1()); // @output result from sampleWorker
    io:println(testAction2()); // @output request
    io:println(testDefaultError()); // @output REACHED
}
