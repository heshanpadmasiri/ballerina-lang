type Index 1|2|9;
public function main() {
    [float, boolean, string] values = [1.0, true, "hello"];
    Index index = 9;
    _ = values[index]; // @panic
}
