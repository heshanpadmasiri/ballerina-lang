type NoDefBar 1|2;

public function main() {
    testNoDefFiniteTyped2DArrays();
}

function testNoDefFiniteTyped2DArrays() {
    NoDefBar[][][] arr = [];
    arr[2][1][1] = 2; // @panic
}
