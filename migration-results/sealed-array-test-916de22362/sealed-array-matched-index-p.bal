public function main() {
    int[3] values = [5];
    int _ = accessIndexOfMatchedSealedArray(values, 5);
}

function accessIndexOfMatchedSealedArray(int[] | int[3] x, int index) returns int {
    if (x is int[3]) {
        x[index] = 10; // @panic
        return x[index];
    }
    x[index] = 10;
    return x[index];
}
