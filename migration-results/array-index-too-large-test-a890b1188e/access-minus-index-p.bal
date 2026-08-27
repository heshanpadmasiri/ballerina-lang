public function main() {
    int _ = accessMinusIndex(-4);
}

function accessMinusIndex(int i) returns int {
    int[] arr = [];
    return arr[i]; // @panic
}
