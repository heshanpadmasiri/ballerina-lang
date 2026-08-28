public function main() {
    int|float _ = testBasicCheckpanic(2);
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        2 => {int _ = checkpanic getGenericErrorWithDetail();}
    }
    return 0.0;
}

function getGenericErrorWithDetail() returns int|error {
    error e = error("Generic Error", fatal = true, message = "Something Went Wrong"); // @panic
    return e;
}
