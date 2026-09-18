public function main() {
    [string, float] values = ["hello", 2.0];
    int index = 3;
    _ = values[index]; // @panic
}
