import ballerina/io;
import ballerina/lang.runtime;

int globalResult = 0;

function testAsyncNonNativeBasic1() returns int {
    future<int> f1 = start add(5, 2);
    return checkpanic wait f1;
}

function testAsyncNonNativeBasic2() returns int {
    future<int> f1 = start add(5, 2);
    int result1 = checkpanic wait f1;
    future<int> f2 = start add(10, 2);
    runtime:sleep(0.1);
    int result2 = checkpanic wait f2;
    return result1 + result2;
}

function testAsyncNonNativeBasic3() returns int {
    future<int> f1 = start add(5, 2);
    int result = checkpanic wait f1;
    future<int> f2 = start add(10, 2);
    result += checkpanic wait f2;
    f2 = start add(10, 2);
    result += checkpanic wait f2;
    return result;
}

function testAsyncNonNativeBasic4() returns int {
    future<any> f1 = start addGlobal(1, 2);
    _ = checkpanic wait f1;
    return globalResult;
}

function testAsyncNonNativeBasic5() returns float {
    future<float> f1 = start addSlow(10.5, 20.5);
    return checkpanic wait f1;
}

function testAsyncNonNativeBasic6() returns boolean {
    future<float> f1 = start addSlower(5.0, 5.0);
    float v1 = checkpanic wait f1;
    future<any> f2 = start infiniteFunc();
    f2.cancel();
    future<any> f3 = start testNativeAsynchBlocking();
    f3.cancel();
    future<any> f4 = start sleep(100);
    f4.cancel();
    return v1 == 10.0;
}

function testNativeAsynchBlocking() {
}

function testAsyncNonNativeBasic9() {
    future<int> f1 = @strand {thread: "parent"} start subtract(5, 2);
    future<int> f2 = @strand {thread: "parent"} start addNum(5, 2);
    f1.cancel();
    int|error result = trap wait f1 | f2;
    if result is error {
        if result.message() != "{ballerina/lang.future}FutureAlreadyCancelled" || result.detail().toString() != "{}" {
            panic error("unexpected future cancellation error");
        }
    } else if result != 7 {
        panic error("unexpected future result");
    }
}

function addNum(int i, int j) returns int {
    int l = 0;
    while l < 10000 {
        l += 1;
    }
    return i + j;
}

function subtract(int a, int b) returns int {
    infiniteFunc();
    return a - b;
}

function add(int a, int b) returns int => a + b;

function addGlobal(int a, int b) {
    globalResult = a + b;
}

function addSlow(float a, float b) returns float {
    runtime:sleep(0.2);
    return a + b;
}

function addSlower(float a, float b) returns float {
    runtime:sleep(1.2);
    return a + b;
}

function infiniteFunc() {
    int i = 0;
    while true {
        i += 1;
        runtime:sleep(0.0001);
    }
}

function sleep(int millis) {
    runtime:sleep(millis * 0.001);
}

function testAsyncObjectAttachedFunctions() returns int {
    Foo f = new;
    return f.doFoo(5);
}

class Foo {
    Bar b = new;

    function doFoo(int x) returns int {
        future<int> f1 = start self.b.doBar(x);
        future<int> f2 = start self.doFoo1(x);
        int a = checkpanic wait f1;
        int b = checkpanic wait f2;
        return a + b;
    }

    function doFoo1(int x) returns int => x;
}

class Bar {
    function doBar(int x) returns int => x;
}

function testAsyncInvWithoutDefaultParams() returns int {
    future<int> aa = start asyncTest("example value!!!!!!!!");
    return checkpanic wait aa;
}

function testAsyncInvWithDefaultParams() returns int {
    future<int> aa = start asyncTest("example value!!!!!!!!", e = 45);
    return checkpanic wait aa;
}

function asyncTest(string a, int e = 5) returns int => e;

Person p = new;

function testAttachedAsyncInvWithoutDefaultParams() returns int {
    future<int> aa = start p.asyncTest("value");
    return checkpanic wait aa;
}

function testAttachedAsyncInvWithDefaultParams() returns int {
    future<int> aa = start p.asyncTest("value", e = new);
    return checkpanic wait aa;
}

class Person {
    function asyncTest(string a, Emp e = new Emp(val = 40)) returns int => e.val;
}

class Emp {
    int val;

    function init(int val = 9) {
        self.val = val;
    }
}

public function main() {
    io:println(testAsyncNonNativeBasic1()); // @output 7
    io:println(testAsyncNonNativeBasic2()); // @output 19
    io:println(testAsyncNonNativeBasic3()); // @output 31
    io:println(testAsyncNonNativeBasic4()); // @output 3
    io:println(testAsyncNonNativeBasic5()); // @output 31.0
    io:println(testAsyncNonNativeBasic6()); // @output true
    testAsyncNonNativeBasic9();
    io:println(testAsyncObjectAttachedFunctions()); // @output 10
    io:println(testAsyncInvWithoutDefaultParams()); // @output 5
    io:println(testAsyncInvWithDefaultParams()); // @output 45
    io:println(testAttachedAsyncInvWithoutDefaultParams()); // @output 40
    io:println(testAttachedAsyncInvWithDefaultParams()); // @output 9
}
