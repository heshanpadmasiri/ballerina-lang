class Student {
    final string name;
    final int id;
    float avg = 80.0;
    function init(string n, int i) {
        self.name = n;
        self.id = i;
    }
}

class Employee {
    final Details details;
    string department;
    function init(Details & readonly details, string department) {
        self.details = details;
        self.department = department;
    }
}

type Details record {
    string name;
    int id;
};

function testObjectWithStructuredFinalFields() {
    Details details = {name: "Kim", id: 1000};
    Employee e = new (details, "finance"); // @error
}

type Foo object {
    int[] arr;
    map<string> mp;
    function baz() returns string;
};

class Bar {
    final int[] arr = [1, 2];
    final map<string> mp = {a: "abc"};
    int? oth = ();
    function baz() returns string {
        return "Bar";
    }
}

class Baz {
    final int[] arr = [1, 2];
    map<string> mp = {a: "abc"};
    function baz() returns string {
        return "Baz";
    }
}

class Qux {
    readonly & int[] arr = [1, 2];
    map<string> & readonly mp = {a: "abc"};
    function baz() returns string {
        return "Qux";
    }
}

function testInvalidImmutableTypeAssignmentForNotAllFinalFields() {
    Bar bar = new;
    Foo & readonly f1 = bar; // @error
    Foo & readonly f2 = new Baz(); // @error
    Foo & readonly f3 = new Qux(); // @error
}

class Quux {
    final float i;
    string s;
    boolean b;
}

function testFinalModifierInStringRepresentation() {
    var b = object {
        final int i = 2;
        string s = "world";
        final boolean b = false;
    };
    Quux y = b; // @error
}

class Controller {
    final string id;
    final map<int> config;
    function init(string id, map<int> config) {
        self.id = id;
        self.config = config;
    }
}

function testMutabilityOfFinalFieldOnlyObjectWithMutableTypes() {
    Controller cr = new ("default", {count: 100});
    readonly rd = cr; // @error
    var ob = object {
        final string id;
        final map<int> config;
        function init() {
            self.id = "inline";
            self.config = {};
        }
    };
    readonly rd2 = ob; // @error
}

class NonReadOnlyClassWithImmutableFieldsOnly {
    final int i = 1;
    final readonly j = 2;
    function fn() returns int => self.i;
}

readonly nrc1 = new NonReadOnlyClassWithImmutableFieldsOnly(); // @error

function testReadOnlyFlagNotBeingSetForClassWithImmutableFieldsOnly() {
    NonReadOnlyClassWithImmutableFieldsOnly nrc2 = new;
    readonly & object {} _ = nrc2; // @error
}
