public function main() {
    addTooLargeIndex(2147483648, 7);
}

function addTooLargeIndex(int i, int val) {
    int[] arr = [];
    arr[i] = val; // @panic
}
