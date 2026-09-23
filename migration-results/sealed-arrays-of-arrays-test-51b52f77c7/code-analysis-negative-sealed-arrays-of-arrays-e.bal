function invalidSealedLiteralUsage() {
    int[*][*] a1 = [[1, 2], [3, 4]]; // @error
    int[][2][*] _ = [[[5, 6], [7, 8]], a1]; // @error
    int[*][2][*] _ = [[[5, 6], [7, 8]], a1]; // @error
    int[*][2][2] _ = [[[5, 5], [6, 6]]];

    int[][*] | string _ = "a1"; // @error
    int[][*][] | string _ = [[[5, 6], [7, 8]], a1]; // @error

    string[*][*] & readonly _ = [["1", "2"], ["3", "4"]]; // @error

    float[*] & readonly a2 = [3, 4];
    float[*][] & readonly | string _ = [[1, 2], a2];
    (float[][*] | string) & readonly _ = [[1, 2], a2]; // @error
    (float[2][2]) & readonly _ = [[3, 4], [3, 4]];
    (float[*][*]) & readonly _ = [[3, 4], [3, 4]]; // @error
}

function value1(int[*][*] a = [[1]]) returns int[*] { // @error @error
    return [10];
}

public function invalidInferredArrays() {
    function (int[*][*] a = [[1]]) returns int[] _ = value1; // @error
    var _ = function(int b) returns int {[int[*]] _ = [[1]]; int[*] _ = [32]; return b;}; // @error
    var _ = function(int[3] b) returns int[*] {return [2, 3];}; // @error

    boolean b3 = true;
    if (b3) {
        int[*] _ = [12, 12];
    }
}

function fn1() returns int[*][*] & readonly { // @error
    return [[21]];
}

function fn2() returns string[*][*] | string[1] { // @error
    return [["1"]];
}

function fn3() returns int[] & readonly | string[*][] | int[*][*] { // @error @error
    return [["1"]];
}

function fn4(int[*][] x = [[1]]) { // @error
}

[int[*]] a2 = [[1]]; // @error
[string | int[*][], float] a3 = [[[1]], 1.2]; // @error
[int[*][] & readonly, float] a4 = [[[1]], 1.2]; // @error

map<int[*][]> a5 = {"1": [[3]]}; // @error
map<float | int[*][*]> a6 = {"1": [[3]]}; // @error
map<int[*][]> a7 = {}; // @error
var _ = function(int[3] b) returns int[*][] {return [[2, 3]];}; // @error
