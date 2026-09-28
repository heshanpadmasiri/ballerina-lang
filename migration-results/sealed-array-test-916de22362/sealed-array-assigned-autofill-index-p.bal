public function main() {
    assignedAutoFilledArrayInvalidIndexAccess();
}

function assignedAutoFilledArrayInvalidIndexAccess() {
    int[3] x1 = [1, 2];
    int[] x2 = x1;
    x2[4] = 10; // @panic
}
