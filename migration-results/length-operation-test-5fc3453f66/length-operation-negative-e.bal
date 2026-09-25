class Person {
    public int age;
    public string firstName;
    public string lastName;

    function init(int age, string firstName, string lastName) {
        self.age = age;
        self.firstName = firstName;
        self.lastName = lastName;
    }
}

function assignLengthToInvalidType() {
    int[] intArr = [1, 2];
    string length = intArr.length(); // @error
}

function invokeLengthOnObject() {
    Person p1 = new(5, "John", "Doe");
    int length = p1.length(); // @error
}
