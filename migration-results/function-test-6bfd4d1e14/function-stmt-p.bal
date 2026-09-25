import ballerina/lang.runtime;

public function main() {
    testRecursiveFunctionWhereStackOverflows();
}

function testRecursiveFunctionWhereStackOverflows() {
    bar(0, 10000);
}

function bar(int x, int lim) {
    if (x == lim) {
        runtime:sleep(0.01); // @panic
        return;
    }
    bar(x + 1, lim);
}
