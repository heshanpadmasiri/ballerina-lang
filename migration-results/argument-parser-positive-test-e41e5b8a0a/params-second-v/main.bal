import ballerina/io;

public function main(int i, float f) {
    io:println(f > 5.0 ? i + 5 : 5 - i); // @output 105
}

// @args ["100", "50.1"]
