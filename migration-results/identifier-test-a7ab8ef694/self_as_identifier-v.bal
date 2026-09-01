import ballerina/io;
import ballerina/test;

class MyClass {
    int n;

    function init(int n) {
        self.n = n;
    }

    function func() {
        self.n += 1;
    }
}

function funcWithSelfAsParamName(int self) returns int {
    return self + 5;
}

function funcWithSelfAsDefaultableParamName(string self = "abc") returns string {
    return self;
}

function funcWithQuotedSelfAsParamName(int 'self) returns int {
    return 'self + 5;
}

function testFuncWithSelfAsParamName() {
    test:assertEquals(funcWithSelfAsParamName(2), 7);
    test:assertEquals(funcWithQuotedSelfAsParamName(2), 7);
    test:assertEquals(funcWithSelfAsDefaultableParamName(), "abc");
}

function testSelfAsIdentifier() {
    int self = funcWithSelfAsParamName(2);
    MyClass x = new MyClass(12);
    x.func();
    int n = x.n + self;
    test:assertEquals(n, 20);
}

public function main() {
    if shouldPrint() {
        io:println("");
    }
    testFuncWithSelfAsParamName();
    testSelfAsIdentifier();
}

function shouldPrint() returns boolean {
    return false;
}
