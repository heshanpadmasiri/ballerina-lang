public function main() {
    int[2] a = [1, 2];
    any[] b = a;
    b[2] = 1; // @panic
}
