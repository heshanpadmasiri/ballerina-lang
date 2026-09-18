public function main() {
    int[2] a = [1, 2];
    any[] b = a;
    b[0] = "hello"; // @panic
}
