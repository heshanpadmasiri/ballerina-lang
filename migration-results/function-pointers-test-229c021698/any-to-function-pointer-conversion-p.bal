class Person {
    int age;

    function init(int age) {
        self.age = age;
    }

    function getAge() returns int => self.age;
}

class Student {
    int age = 40;
    private int marks = 0;

    function getAge() returns int => self.age;
}

public function main() {
    _ = checkpanic testAnyToFuncPointerConversion_2();
}

function testAnyToFuncPointerConversion_2() returns int|error {
    any anyFunc = function (Student s) returns int => s.getAge();
    function (Person) returns int personFunc = <function (Person) returns int> anyFunc; // @panic
    Person p = new(23);
    return personFunc(p);
}
