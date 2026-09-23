public function main() {
    [string, string] animals = ["Dog", "Mouse"];
    int index = -1;
    string name = animals[index]; // @panic
    _ = name;
}
