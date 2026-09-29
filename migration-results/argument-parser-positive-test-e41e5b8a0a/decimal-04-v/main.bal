import ballerina/io;

public function main(decimal d) {
    io:println(d); // @output -1.0123E+1424
}

// @args ["-10.123e1423"]
