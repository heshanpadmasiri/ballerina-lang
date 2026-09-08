class PersonObj4 {
    int id;
    string name;

    public function init(int id, string name = "Alex") {
        self.id = id;
        self.name = name;
    }
}

public function main() {
    testObjectArrays2();
}

function testObjectArrays2() {
    PersonObj4 p = new(1001);
    PersonObj4[] arr = [];
    arr[1] = p; // @panic
}
