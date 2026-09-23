public function main() {
    [string, string] animals = ["Dog", "Mouse"];
    int index = 2;
    string name = animals[index]; // @panic
    _ = name;
}
