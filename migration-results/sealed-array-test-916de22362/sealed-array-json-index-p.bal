public function main() {
    invalidIndexJSONArray(1);
    invalidIndexJSONArray(4);
}

function invalidIndexJSONArray(int index) {
    json[3] x1 = [true, 12, false];
    x1[index] = 100.1; // @panic
}
