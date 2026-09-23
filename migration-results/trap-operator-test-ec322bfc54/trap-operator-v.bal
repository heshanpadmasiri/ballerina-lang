import ballerina/io;
import ballerina/test;

function trapInsideFunctionArg() {
    function () fn = function () {
    };

    function () panicfn = function () {
        panic error("panic inside function");
    };

    errFn(fn());
    errFn(trap fn());
    errFn(trap panicfn());
    error? errFnResult = trap errFn(panicfn());

    test:assertTrue(errFnResult is error);
    if errFnResult is error {
        test:assertEquals("panic inside function", errFnResult.message());
    }
}

function errFn(error? res) {
}

int loopTrapCounter = 0;

function testTrapInsideForLoop() {
    foreach int i in 0 ..< 10 {
        error? unionResult = trap func();
    }
    test:assertEquals(loopTrapCounter, 10);
}

function func() {
    loopTrapCounter += 1;
    panic error("err");
}

public function main() {
    var print = io:println;
    trapInsideFunctionArg();
    testTrapInsideForLoop();
}
