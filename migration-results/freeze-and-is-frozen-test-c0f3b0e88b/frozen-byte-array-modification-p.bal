public function main() {
    byte[] a = [1, 2, 3];
    byte[] b = a.cloneReadOnly();
    b[5] = 200; // @panic
}
