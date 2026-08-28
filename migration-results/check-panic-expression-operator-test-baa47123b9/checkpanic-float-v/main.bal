import ballerina/io;

public function main() {
    io:println(testBasicCheckpanic(4)); // @output 2.2
}

function testBasicCheckpanic(int testNumber) returns int|float {
    match testNumber {
        4 => {return checkpanic getFloat();}
    }
    return 0.0;
}

function getFloat() returns int|float|error {
    float f = 2.2;
    return f;
}
