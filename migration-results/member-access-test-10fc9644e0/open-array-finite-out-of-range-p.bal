type Index 1|2|9;
public function main() {
    int[] values = [1, 2];
    Index index = 9;
    _ = values[index]; // @panic
}
