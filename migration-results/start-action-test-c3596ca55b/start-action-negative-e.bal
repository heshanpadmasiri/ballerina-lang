import ballerina/jballerina.java;

function foo() returns int {
    return 1;
}

function bar(int i) returns int {
    return i + 1;
}

function baz(future<int> f) returns int {
    return 3;
}

function zee(future<int>|error f) returns int {
    return 4;
}

function c() {
    future<int>|error k = trap start foo();
    future<int> r1 = start foo();
    var p = baz(start foo()); // @error
    future<int> r2 = start baz(start foo()); // @error
    future<int> r3 = start zee(trap start foo()); // @error
}

function flushTestHelper(error? er) {

}

function flushTestHelper2(error? er) returns error? {
    return er;
}

function process() returns string {
    worker w1 {
        int a = 10;
        wait start foo() -> w2; // @error // @error // @error // @error
        () result = a ->> w2;
        a -> w2;
        error? e = flushTestHelper2(flush w2); // @error
        a -> w2;
        error? e1 = wait start flushTestHelper2(flush w2); // @error // @error
        a = <- w2;

        foreach var i in 1 ... 5 {
        }
    }

    worker w2 {
        int b = 15;
        sleep(10);

        foreach var i in 1 ... 5 {
        }
        b = bar(<- w1)  ; // @error
        b = wait start bar(<- w1); // @error // @error // @error
        b = <- w1;
        b = <- w1;
        b -> w1;
        flushTestHelper(flush w1); // @error
        future<int> r3;
        r3 = start foo();
    }

   wait w1;
   return "done";
}

function retList() returns int[] {
    return [1, 2];
}

function forI() {
    foreach int i in wait start retList() { // @error // @error

    }
}

function testFunction1(int a) {
    start
} // @error // @error // @error // @error

function testFunction2(int a) {
    start a + b; // @error
}

function testInvalidRemoteMtdCallWithStartAction() returns string {
    worker w1 {
        int a = 10;
        start fooFunc() -> w2; // @error // @error // @error
    }

    worker w2 {
        int b = <- w1;
    }
}

function fooFunc() returns int {
    return 1;
}

public function sleep(int millis) = @java:Method {
    'class: "org.ballerinalang.test.utils.interop.Utils"
} external;
