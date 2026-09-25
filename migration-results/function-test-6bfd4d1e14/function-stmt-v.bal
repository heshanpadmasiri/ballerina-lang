import ballerina/io;
import ballerina/lang.runtime;

function emptyFunction() {
}

function funcEmptyDefaultWorker() {
    worker newWorker1 {
        int a = 5;
    }

    worker newWorker2 {
        int a = 5;
    }
}

function test1() {
    string a = "hello";
    if (a == "a") {
        a = "b";
    }
}

function test2() {
    string a = "hello";
    if (a == "a") {
        a = "b";
    } else {
        a = "c";
    }
}

function test3() {
    string a = "hello";
    if (a == "a") {
        a = "b";
    } else if (a == "b") {
        a = "c";
    }
}

function testRecursiveFunctionWhichYields() {
    bar(0, 1000);
}

function bar(int x, int lim) {
    if (x == lim) {
        runtime:sleep(0.01);
        return;
    }
    bar(x + 1, lim);
}

public function main() {
    io:println(emptyFunction()); // @output
    io:println(funcEmptyDefaultWorker()); // @output
    test1();
    test2();
    test3();
    testRecursiveFunctionWhichYields();
}
