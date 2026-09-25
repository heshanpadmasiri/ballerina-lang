public function main() {
    string[] a = ["ballerina", "2", "hello world"];
    string[] b = a.cloneReadOnly();
    b[1] = "addition to frozen array"; // @panic
}
