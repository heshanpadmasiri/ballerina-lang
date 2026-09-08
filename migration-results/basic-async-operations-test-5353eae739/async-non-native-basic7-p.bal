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
    future<int> f1 = start subtract(5, 2);
    f1.cancel();
    int result = checkpanic wait f1; // @panic
}
