type Index 1|2|9;
public function main() {
    int[4] values = [1, 2, 3, 4];
    Index index = 9;
    _ = values[index]; // @panic
}
