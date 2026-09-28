public function main() {
    invalidIndexAccess(5);
}

function invalidIndexAccess(int index) {
    boolean[3] x1 = [true, false, true];
    boolean x2 = x1[index]; // @panic
}
