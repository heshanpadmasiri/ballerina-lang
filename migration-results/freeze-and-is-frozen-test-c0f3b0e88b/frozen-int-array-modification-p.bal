public function main() {
    int[] a = [1, 2, 3];
    int[] b = a.cloneReadOnly();
    b[4] = 200; // @panic
}
