import ballerina/io;

public function main() {
    io:println(m()); // @output 3
}

function m() returns int {
    int x;
    int y;
    [_, x, y] = abc();
    return y;
}

function abc() returns [int, int, int] {
    return [1, 2, 3];
}
