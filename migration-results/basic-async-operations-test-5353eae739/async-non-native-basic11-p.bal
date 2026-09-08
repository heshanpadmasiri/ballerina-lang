import ballerina/lang.runtime;

function subtract(int a, int b) returns int {
    infiniteFunc();
    return a - b;
}

function infiniteFunc() {
    while true {
        runtime:sleep(0.0001);
    }
}

public function main() {
    future<int> f1 = @strand {thread: "parent"} start subtract(7, 2);
    future<int> f2 = @strand {thread: "parent"} start subtract(5, 2);
    f1.cancel();
    f2.cancel();
    record {| int|error f1; int|error f2; |} result = wait {f1, f2}; // @panic
}
