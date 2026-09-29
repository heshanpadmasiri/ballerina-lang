import ballerina/io;

public function main(int i, float f) {
    io:println(f > 5.0 ? i + 5 : 5 - i); // @output 4
}

// @args ["1", "1.0"]
