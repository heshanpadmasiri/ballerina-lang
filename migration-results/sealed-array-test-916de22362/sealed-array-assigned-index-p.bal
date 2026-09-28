public function main() {
    assignedArrayInvalidIndexAccess();
}

function assignedArrayInvalidIndexAccess() {
    int[3] x1 = [1, 2, 3];
    int[] x2 = x1;
    x2[4] = 10; // @panic
}
