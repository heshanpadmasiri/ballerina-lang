class Student {
    public string name;
    public int age;

    public function init(string name, int age) {
        self.name = name;
        self.age = age;
    }
}

public function main() {
    Student s = new("Grainier", 28);
    Student[] arr = [];
    int i = 0;
    while (i < 10) {
        arr[i] = s; // @panic
        i += 2;
    }
}
