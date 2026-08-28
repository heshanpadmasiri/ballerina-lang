public function main() {
    int|float _ = testBasicCheckpanic(1);
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        1 => {int _ = checkpanic getGenericError();}
    }
    return 0.0;
}

function getGenericError() returns int|error {
    error e = error("Generic Error"); // @panic
    return e;
}
