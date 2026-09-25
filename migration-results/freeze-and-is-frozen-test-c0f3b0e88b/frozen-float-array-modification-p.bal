public function main() {
    float[] a = [1.0, 0.2, 300.23];
    float[] b = a.cloneReadOnly();
    b[1] = 200.23; // @panic
}
