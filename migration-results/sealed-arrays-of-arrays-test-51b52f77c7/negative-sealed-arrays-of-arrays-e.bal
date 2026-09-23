function twoDimensionArrayDeclaration() {
    string[2][2] x1 = [["1", "2"], ["3", "4"]];
    string[2][2] x2 = [["1", "2"], ["3", "4"], ["4", "5"]]; // @error
    string[2][2] x3 = [["1", "2"], ["3", "4", "5"]]; // @error
    string[2][2] x4 = [["1", "2", "3"], ["3", "4"]]; // @error
}

function threeDimensionArrayDeclarationAndAccess() {
    int[*][][] x1 = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 2, 3], [4, 5, 6], [7, 8, 9]]];
    int[][] x2 = x1[1];
    int[][] x3 = x1[2]; // @error
    int[] x4 = x1[1][2];
    int[] x5 = x1[1][3];
    int x6 = x1[1][2][2];
    int x7 = x1[1][2][3];
}

function threeDimensionArrayValueAssigning() {
    int[3][2][3] x1 = [[[0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0]]];
    x1[2][1][2] = 1;
    x1[3][1][2] = 1; // @error
    x1[2][3][1] = 1; // @error
    x1[2][1][3] = 1; // @error
    x1[2][1] = [1, 2, 3, 4]; // @error
    x1[2] = [1, 2]; // @error @error
    x1[2] = [[1, 2, 3], [3, 4, 5, 6]]; // @error
}

function arrayAssignments() {
    int[] x1 = [];
    int[2][3] x2 = [x1, x1]; // @error @error
    int[3] x3 = [0, 0, 0];
    int[2][3] x4 = [x3, x3];
    int[2][] x5 = [x1, x1];
    x5[1][4] = 12;
    x4[1][4] = 12; // @error
}

function jsonArrays() {
    json[] x1 = [1, 2];
    json[3][2] x = [[1, 2], [3, 4], [5, 6]];

    int l = 1;
    x[l] = x1; // @error

    json[2][3][3] x2 = [[[1, 2, "3"], [4, 5, 6], [7, "8", 9]], [[1, 2, 3], [4, "5", 6], ["7", 8, 9]]];
    x2[2] = true; // @error
    x2[1][2][4] = "abc"; // @error

    json[2][][3] x3 = [[[1, 2, "3"], [4, 5, 6], [7, "8", 9]], [[1, 2, 3], [4, "5", 6], ["7", 8, 9]]];
    x3[1][4][2] = "abc";
    x3[1][4][4] = "abc"; // @error
}

function invalidSealedLiteralUsage() {
    int[2][][*] a1 = [[[1, 2, 3], [4, 5, 6], [6, 7, 8, 9, 10]], [[1, 2, 3, 4], [4, 5, 6], [7, 8, 9]]]; // @error @error
    float[2][*] a2; // @error

    (float[2][2]) & readonly a3 = [[3, 4], [3, 4]];
    (float[*][] | string) & readonly _ = a3;
}

function invalidSealedLiteralIndexAccess() {
    int[2][] x1 = [[1, 2, 3], [4, 5, 6]];
    int[*][3] x2 = [[1, 2, 3], [4, 5, 6]];
    x1[1][4] = 7;
    x2[1][4] = 7; // @error
}

function invalidInferredArrayUsage() {
    int[*][2][2] a1 = [[[5, 5], [6, 6]]];
    int[*][2][2] _ = a1; // @error

    string[*][] & readonly a2 = [["1", "2"], ["3", "4"]];
    string[*][*] & readonly _ = a2; // @error

    (float[2][2]) & readonly a3 = [[3, 4], [3, 4]];
    (float[*][]) & readonly _ = a3; // @error

    boolean b3 = true;
    if (b3) {
        int[*][][] _ = a1; // @error
    }

    map<float | int[*][*]> a4 = {"1": [[3]]};
    map<int[*][]> _ = a4; // @error

    [string | int[*][], float] a5 = [[[1]], 1.2];
    [int[*][] & readonly, float] _ = a5; // @error
}

int[*][2][2] a1 = [[[5, 5], [6, 6]]];
int[*][2][2] _ = a1; // @error

string[*][] & readonly a2 = [["1", "2"], ["3", "4"]];
string[*][*] & readonly _ = a2; // @error

(float[2][2]) & readonly a3 = [[3, 4], [3, 4]];
(float[*][]) & readonly _ = a3; // @error

map<float | int[*][*]> a4 = {"1": [[3]]};
map<int[*][]> _ = a4; // @error

[string | int[*][], float] a5 = [[[1]], 1.2];
[int[*][] & readonly, float] _ = a5; // @error
