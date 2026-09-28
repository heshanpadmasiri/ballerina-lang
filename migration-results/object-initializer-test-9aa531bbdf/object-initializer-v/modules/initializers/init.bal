public class employee {
    public int age = 0;
    public string name = "";
    public string address = "";
    public function init(string name, int a = 10) { self.age = a; self.name = name; }
    public function getAge() { self.age = 12; }
}

public class student {
    public int age = 20;
    public string name = "";
    public string address = "";
    function init() {}
    public function getAge() { self.age = 20; }
}
