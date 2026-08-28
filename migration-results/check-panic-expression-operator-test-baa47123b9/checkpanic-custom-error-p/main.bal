public function main() {
    int|float _ = testBasicCheckpanic(6);
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        6 => {int _ = checkpanic getCustomError();}
    }
    return 0.0;
}

public type MyError error<record { int code; string message?; error cause?;}>;

function getCustomError() returns int|MyError {
    MyError e = error MyError("My Error", code = 12); // @panic
    return e;
}
