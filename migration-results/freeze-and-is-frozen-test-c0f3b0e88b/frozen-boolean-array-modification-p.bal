public function main() {
    boolean[] a = [false, true];
    boolean[] b = a.cloneReadOnly();
    b[1] = true; // @panic
}
