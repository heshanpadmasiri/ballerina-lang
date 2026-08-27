function arrayIndexOutOfBoundTest() {
    string name = "";
    string[] animals = ["Lion", "Cat"];
    name = animals[5]; // @panic
}

public function main() {
    arrayIndexOutOfBoundTest();
}
