function testCheckedExprErrors1() returns error? {
    string _ = checkpanic readLineError(); // @error
    return;
}

function readLineError() returns error {
    error e = error("io error");
    return e;
}

function testCheckedExprErrors2() returns error? {
    string _ = checkpanic readLine(); // @error
    return;
}

public type MyError error<record { int code; string message?; error cause?; }>;

public type CustomError error<record { int code; string data; string message?; error cause?; }>;

function readLine() returns MyError | CustomError {
    MyError e = error MyError("io error", code = 0);
    return e;
}
