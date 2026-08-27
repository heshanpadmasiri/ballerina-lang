public function main() {
    int[]|boolean[] arrays = [true];
    (int|boolean)?[] widened = arrays;
    widened[0] = 3; // @panic
}
