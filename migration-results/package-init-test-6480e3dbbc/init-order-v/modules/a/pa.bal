import ballerina/io;

int a1 = 0;
int b = temp();

public function getA1() returns int {
    return a1;
}

public function updateA1(int val) returns int {
    a1 = a1 + val;
    return a1;
}

function temp() returns int {
    io:println("PackageA"); // @output PackageA
    return 9;
}
