public function main() {
    int _ = accessTooLargeIndex(2147483648);
}

function accessTooLargeIndex(int i) returns int {
    int[] arr = [];
    return arr[i]; // @panic
}
