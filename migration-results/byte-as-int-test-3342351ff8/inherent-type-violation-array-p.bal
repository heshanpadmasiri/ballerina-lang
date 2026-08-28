public function main() {
    byte[] barr = [0, 1, 233, 255];
    int[] iarr = barr;
    iarr[6] = 256; // @panic
}
