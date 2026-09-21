class Person1 {
    public string name = "sample name";
    public int age = 10;
    int year = 50;
    string month = "february";
    function init(string name, int age) {
        self.age = age;
        self.name = name;
    }
}

class Employee1 {
    public string name = "no name";
    public int age = 3;
    int year = 2;
    string month = "idk";
    function init(string name, int age) {
        self.age = age;
        self.name = name;
        self.year = 50;
        self.month = "february";
    }
    function getName() returns string { return self.name; }
    function getYear() returns int { return self.year; }
}

function testCastingRuntimeError() returns Person1 {
    Person1 p = new("John Doe", 25);
    Employee1 e = <Employee1>p; // @panic incompatible types: 'Person1' cannot be cast to 'Employee1'
    return e;
}

public function main() {
    Person1 _ = testCastingRuntimeError();
}
