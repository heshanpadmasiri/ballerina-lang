public function testInitAbstractObject() {
    Person1 p1 = new Person1(); // @error
    Person2 p2 = new Person2(); // @error
}

public function testInitAbstractObjectWithNew() {
    Person1 p1 = new; // @error
    Person2 p2 = new; // @error
}

type Person1 object {
    public int age;
    public string name;

    int year;
    string month;
};

// Abstract object with constructor method
type Person2 object {
    public int age;
    public string name;
    int year;
    string month;

    function init(int age, string name, int year, string month); // @error
};
