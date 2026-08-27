public function main() {
    int[] integers = [1, 2, 3, 4];
    int?[] nullableIntegers = integers;
    nullableIntegers[0] = 5;
    nullableIntegers[1] = (); // @panic
}
