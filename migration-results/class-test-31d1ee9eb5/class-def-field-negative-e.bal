class ClassA {
    any a = 12;
    any b = a; // @error

    function init() {
    }
}

class ClassB {
    any a = 12;
    int b = <int> a; // @error

    function init() {
    }
}

class ClassC {
    string name = "John Doe";
    int age = 25;
    string lname = name; // @error

    function init() {
    }
}

class ClassD {
    int age = 25;
    string lname = name; // @error
    string name = "John Doe";

    function init() {
    }
}
