function intMod(int a, int b) returns int {
    return a % b; // @panic
}

public function main() {
    int ignored = intMod(2000, 0);
}
