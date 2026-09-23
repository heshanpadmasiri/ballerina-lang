import ballerina/io;

public function main() {
    io:println(intToFloatExplicit(-1)); // @output -1.0
    io:println(intToFloatExplicit(0)); // @output 0.0
    io:println(intToFloatExplicit(1)); // @output 1.0
    io:println(intToFloatExplicit(150000000)); // @output 1.5E8

    io:println(floatToIntCast(4.5)); // @output 4
    io:println(floatToIntCast(5.5)); // @output 6
    io:println(floatToIntCast(3.2)); // @output 3
    io:println(floatToIntCast(6.7)); // @output 7

    io:println(decimalToIntCast(4.5d)); // @output 4
    io:println(decimalToIntCast(5.5d)); // @output 6
    io:println(decimalToIntCast(3.2d)); // @output 3
    io:println(decimalToIntCast(6.7d)); // @output 7
}

function intToFloatExplicit(int i) returns float {
    float f = <float> i;
    return f;
}

function floatToIntCast(float f) returns int {
    int x = <int>f;
    return x;
}

function decimalToIntCast(decimal d) returns int {
    int x = <int>d;
    return x;
}
