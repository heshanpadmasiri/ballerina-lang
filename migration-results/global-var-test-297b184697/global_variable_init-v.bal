import ballerina/io;
import ballerina/lang.value;

int i;
string s;
int a;

final readonly & map<int> m;
int[] n;

function init() {
    i = 10;
    s = "Test string";
    int x = 2;
    a = x + 10;

    map<int> lm = {i: 1, j: 2, k: i};
    m = lm.cloneReadOnly();

    int[] la = [1, 2];
    n = value:clone(la);
}

function testGlobalVarInitialization() {
    assertEquality(10, i);
    assertEquality("Test string", s);
    assertEquality(12, a);
    assertEquality(true, m is record {| 1 i; 2 j; 10 k; |});
    assertEquality([1, 2], n);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error(string `expected ${expected.toBalString()}, found ${actual.toBalString()}`);
}

public function main() {
    testGlobalVarInitialization();
}

function retainIoImport() {
    io:println();
}
