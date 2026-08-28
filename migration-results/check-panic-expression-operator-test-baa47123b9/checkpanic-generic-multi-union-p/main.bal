public function main() {
    int|float _ = testBasicCheckpanic(3);
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        3 => {int|boolean _ = checkpanic getGenericErrorWithMultiUnion();}
    }
    return 0.0;
}

function getGenericErrorWithMultiUnion() returns int|boolean|error {
    error e = error("Generic Error"); // @panic
    return e;
}
