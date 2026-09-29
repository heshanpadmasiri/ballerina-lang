import ballerina/io;

public function main(int i, int a = addFive(i), int b = addFive(a), int c = addFive(a + b)) {
    io:println(i.toString() + ", a: " + a.toString() + ", b: " + b.toString() + ", c: " + c.toString()); // @output 1, a: 6, b: 11, c: 22
}

function addFive(int x) returns int => x + 5;

// @args ["1"]
