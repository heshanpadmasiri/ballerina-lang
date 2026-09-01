type Data record {
    int b;
    string s;
};

type Data2 record {
    int a;
    Data d;
};

function getRecord() returns Data {
    return {b: 1, s: "A"};
}

function getNestedRecord() returns Data2 {
    return {a: 2, d: {b: 1, s: "A"}};
}

function getTuple() returns [int, string] {
    return [1, "A"];
}

function getNestedTuple() returns [int, [string, float]] {
    return [1, ["A", 5.6]];
}

function testFinalRecordVariableWithoutType() {
    final var {
        b, // @error
        s: j // @error
    } = getRecord();
    b = 2; // @error
    j = "B"; // @error
}

function testFinalRecordVariableWithType() {
    final Data {
        b, // @error
        s: j // @error
    } = getRecord();
    b = 2; // @error
    j = "B"; // @error
}

function testFinalNestedRecordVariableWithType1() {
    final var {
        a, // @error
        d: {
            b, // @error
            s // @error
        }
    } = getNestedRecord();
    a = 2; // @error
    s = "B"; // @error
}

function testFinalNestedRecordVariableWithType2() {
    final Data2 {
        a, // @error
        d: {
            b, // @error
            s // @error
        }
    } = getNestedRecord();
    a = 2; // @error
    b = 5; // @error
    s = "fd"; // @error
}

function testFinalTupleVariableWithoutType() {
    final var [
        i, // @error
        j // @error
    ] = getTuple();
    i = 2; // @error
    j = "B"; // @error
}

function testFinalTupleVariableWithType() {
    final [int, string] [
        i, // @error
        j // @error
    ] = getTuple();
    i = 2; // @error
    j = "B"; // @error
}

function testFinalNestedTupleVariableWithoutType() {
    final var [
        i, // @error
        j // @error
    ] = getNestedTuple();
    i = 2; // @error
    j = ["C", 1.4]; // @error
}

function testFinalNestedTupleVariableWithType() {
    final [int, [string, float]] [
        i, // @error
        [
            j, // @error
            k // @error
        ]
    ] = getNestedTuple();
    i = 2; // @error
    j = "B"; // @error
    k = 3.4; // @error
}
