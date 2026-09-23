public function testDuplicate() { // @error redeclared symbol 'testDuplicate'
}

public type Person record {| // @error redeclared symbol 'Person'
    string name;
    int age;
|};

string testString = "test"; // @error redeclared symbol 'testString'

public class Company { // @error redeclared symbol 'Company'
    string name;
    string address;

    public function init() {
        self.name = "test";
        self.address = "test";
    }
}

function testFunction() {
    testDuplicate();
    main();
}

function beforeFunc() {
}

function afterFunc() {
}
