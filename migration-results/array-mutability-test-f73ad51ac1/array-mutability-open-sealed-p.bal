public function main() {
    int[*] sealed = [1, 2, 3, 4];
    int[] open = sealed;
    open[4] = 5; // @panic
}
