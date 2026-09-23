import ballerina/io;

function initTwoDimensionalSealedArray() returns [int, int, int, int] {
    string[3][4] x1 = [["00", "01", "02", "03"], ["10", "11", "12", "13"], ["20", "21", "22", "23"]];
    float[*][3] x2 = [[1.0, 2.1, 3.2], [4.3, 5.4, 6.5]];

    return [x1.length(), x1[0].length(), x2.length(), x2[0].length()];
}

function initThreeDimensionalSealedArray() returns [int, int, int, int, int, int] {
    boolean[3][4][5] x1 = [[[false, true, false, true, false], [false, true, false, true, false],
    [false, true, false, true, false], [false, true, false, true, false]], [[false, true, false, true, false],
    [false, true, false, true, false], [false, true, false, true, false], [false, true, false, true, false]],
    [[false, true, false, true, false], [false, true, false, true, false], [false, true, false, true, false],
    [false, true, false, true, false]]];
    int[*][3][3] x2 = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 2, 3], [4, 5, 6], [7, 8, 9]]];

    return [x1.length(), x1[0].length(), x1[0][0].length(), x2.length(), x2[0].length(), x2[0][0].length()];
}

function twoDArrayIntAssignment(int[2] x2) returns [int, int, int] {
    int[*] x1 = [3, 2];
    int[3][2] xx1 = [x1, x2, x1];

    return [xx1[0][0], xx1[1][0], xx1[2][0]];
}

function twoDArrayStringAssignment(string[2] x2) returns [string, string, string] {
    string[*] x1 = ["val1", "val2"];
    string[3][2] xx1 = [x1, x2, x1];

    return [xx1[0][0], xx1[1][0], xx1[2][0]];
}

public function main() {
    [int, int, int, int] twoDimensional = initTwoDimensionalSealedArray();
    io:println(twoDimensional[0]); // @output 3
    io:println(twoDimensional[1]); // @output 4
    io:println(twoDimensional[2]); // @output 2
    io:println(twoDimensional[3]); // @output 3

    [int, int, int, int, int, int] threeDimensional = initThreeDimensionalSealedArray();
    io:println(threeDimensional[0]); // @output 3
    io:println(threeDimensional[1]); // @output 4
    io:println(threeDimensional[2]); // @output 5
    io:println(threeDimensional[3]); // @output 2
    io:println(threeDimensional[4]); // @output 3
    io:println(threeDimensional[5]); // @output 3

    [int, int, int] integers = twoDArrayIntAssignment([10, 12]);
    io:println(integers[0]); // @output 3
    io:println(integers[1]); // @output 10
    io:println(integers[2]); // @output 3

    [string, string, string] strings = twoDArrayStringAssignment(["ballerina", "multidimensional"]);
    io:println(strings[0]); // @output val1
    io:println(strings[1]); // @output ballerina
    io:println(strings[2]); // @output val1
}
