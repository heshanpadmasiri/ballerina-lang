type Rec record {
    Person p;
    Student s;
};

class Person {
    public int age = 10;
    public string name = "sample name";
    int year = 50;
    string month = "february";
}

class Student {
    *Person;
    int grade = 1;

    function init(int age, string name, int year, string month)  {
        self.age = age;
        self.name = name;
        self.year = year;
        self.month = month;
    }
}

class Stu {
    *Per;
    Rec r0 = {}; // @error
    Rec r1;

    function init(int i) {
        self.i = i;
        self.r1 = {}; // @error
    }

    function f() {
    }
}

class Per {
    int i = 0;

    function f() {
    }
}

function testFunc() {
    Student s = new(); // @error
    var s0 = new Student(); // @error
}
