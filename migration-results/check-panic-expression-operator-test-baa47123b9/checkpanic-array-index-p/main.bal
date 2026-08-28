public function main() {
    int|float _ = testBasicCheckpanic(5);
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        5 => {int _ = checkpanic returnBallerinaPanicedError();}
    }
    return 0.0;
}

function returnBallerinaPanicedError() returns int|error {
    int[2] arr = [1, 2];
    int[] oArr = arr;
    int|error ret = trap oArr[4]; // @panic
    return ret;
}
