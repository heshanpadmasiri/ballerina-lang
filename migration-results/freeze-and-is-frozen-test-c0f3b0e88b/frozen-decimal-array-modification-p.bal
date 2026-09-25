public function main() {
    decimal[4] d = [1.0d, 0.2d, 310.0d, 22222.3d];
    decimal[4] d2 = d.cloneReadOnly();
    d2[3] = 200.23d; // @panic
}
