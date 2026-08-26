import ballerina/io;

public function main() {
    [int, int, ()] x = [1, 2, ()];
    [int, int?, ()] y = x;
    y[0] = 5;
    y[1] = 5;
    error? result = trap nilValueAssignment(y);
    io:println(y[1] ?: 1);
}

function nilValueAssignment([int, int?, ()] y) {
    y[1] = ();
}

// @output 5
