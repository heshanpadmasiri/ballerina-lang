public function main() {
    int[] integers = [1, 2];
    json[] jsonValues = integers;
    jsonValues[2] = 3;
    jsonValues[3] = "json"; // @panic
}
