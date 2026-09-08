class PersonObj3 {
    string name = "John Doe";

    public function init(string name) {
        self.name = name;
    }
}

public function main() {
    test2DObjectArrays3();
}

function test2DObjectArrays3() {
    PersonObj3[][] arr = [];
    arr[2][1] = new("Pubudu"); // @panic
}
