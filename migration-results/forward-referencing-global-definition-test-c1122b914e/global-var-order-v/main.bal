import ballerina/io;

int j = incI();
int k = incI();
int i = 0;

public function main() {
    [int, int, int] values = getIJK();
    io:println(values[0]); // @output 2
    io:println(values[1]); // @output 1
    io:println(values[2]); // @output 2
}

function getIJK() returns [int, int, int] {
    return [i, j, k];
}

function incI() returns int {
    i = i + 1;
    return i;
}
