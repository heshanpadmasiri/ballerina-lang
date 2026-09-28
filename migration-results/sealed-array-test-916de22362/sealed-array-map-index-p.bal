public function main() {
    int[3] values = [1, 3, 5];
    testSealedArrayConstrainedMapInvalidIndex(values, 3);
}

function testSealedArrayConstrainedMapInvalidIndex(int[3] x1, int index) {
    map<int[]> x = {};
    x["v1"] = x1;
    x["v1"][index] = 4; // @panic
}
