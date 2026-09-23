public function main() {
    [string, boolean, int] tuple = ["str", true, 10];
    int index = 0;
    tuple[index] = "str2";
    tuple[index] = false; // @panic
}
