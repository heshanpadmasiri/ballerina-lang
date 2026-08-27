public function main() {
    int[3] fixed = [0, 0, 0];
    int[] open = fixed;
    open[3] = 12; // @panic
}
