public function main() {
    addMinusIndex(-4, 7);
}

function addMinusIndex(int i, int val) {
    int[] arr = [];
    arr[i] = val; // @panic
}
