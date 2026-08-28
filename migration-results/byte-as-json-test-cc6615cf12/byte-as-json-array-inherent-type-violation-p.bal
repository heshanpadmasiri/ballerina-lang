public function main() {
    testInherentTypeViolationForArray();
}

function testInherentTypeViolationForArray() {
    byte[] barr = [0, 1, 233, 255];
    json[] jarr = barr;
    jarr[6] = 256; // @panic
}
