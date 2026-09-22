import ballerina/io;

type R1 record {
    string y?;
};

type R2 record {
    int x?;
};

type R3 record {|
    string y?;
    int...;
|};

type R4 record {
    int a?;
    string b;
};

type R5 record {
    string b;
};

type R6 record {
    int a?;
    int b;
};

type R7 record {
    readonly int? b;
};

function testOpenRecordToRecordWithOptionalFieldTypingRuntimeNegative() {
    R2 a = {x: 1, "y": 10};
    assertFalse(a is R1);

    record {| int|string...; |} b = {};
    assertFalse(b is R1);

    record {| int...; |} c = {};
    assertFalse(c is R1);
    assertFalse(c is R3);

    R5[] d = [];
    assertFalse(d is R4[]);

    R7 e = {b: 1};
    assertFalse(e is R6);
}

type R8 record {
    string y?;
};

type R9 record {|
    int x?;
    string...;
|};

type R10 record {
    int a?;
    int b;
};

type R11 record {|
    readonly int? b;
    int...;
|};

function testRecordToRecordWithOptionalFieldTypingRuntimePositive() {
    R9 a = {};
    R8 _ = a;
    assertTrue(<any>a is R8);

    record {| int x?; |} b = {};
    assertTrue(<any>b is R8);

    record {| int x?; never...; |} c = {};
    assertTrue(<any>c is R8);

    R9[] d = [];
    R8[] _ = d;
    assertTrue(<any>d is R8[]);

    record {| readonly int? b; int...; |} e = {b: 1};
    assertTrue(e is record { int a?; int b; });
}

function assertTrue(anydata actual) {
    assertEquality(true, actual);
}

function assertFalse(anydata actual) {
    assertEquality(false, actual);
}

function assertEquality(anydata expected, anydata actual) {
    if expected != actual {
        panic error(string `expected ${expected.toBalString()}, found ${actual.toBalString()}`);
    }
}

public function main() {
    testOpenRecordToRecordWithOptionalFieldTypingRuntimeNegative();
    io:println(()); // @output
    testRecordToRecordWithOptionalFieldTypingRuntimePositive();
    io:println(()); // @output
}
