public function main() {
    int[3][3] fixed = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
    int[3][] open = fixed;
    open[0][0] = 10;
    open[0][3] = 12; // @panic
}
