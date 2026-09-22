type Details record {|
    string name;
    int yob;
|};

type Department record {
    string name = "IT";
};

readonly class Employee {
    Details details;
    Department dept;
    int id;

    function init(Details details, Department dept, int id) {
        self.details = details; // @error incompatible types: expected '(Details & readonly)', found 'Details'
        self.dept = dept; // @error incompatible types: expected '(Department & readonly)', found 'Department'
        self.id = id;
    }

    function invalidUpdate() {
        self.id = 2345; // @error cannot update 'readonly' value of type 'Employee'
        self.details.yob = 1998; // @error cannot update 'readonly' value of type 'Employee'
    }
}

readonly class Controller {
    map<int|float> config = {
        quota: 10,
        factor: 2.0
    };

    function getConfig() returns map<int|float> {
        return self.config;
    }
}

function testReadOnlyIntersectionInvalidInitialization() {
    Controller & readonly x = new; // @error cannot initialize abstract object '(Controller & readonly)'
}

readonly class InvalidReadOnlyObject { // @error invalid 'readonly object' 'InvalidReadOnlyObject': cannot have fields that are never 'readonly'
    int i = 1;
    future<int> f;

    function init(future<int> g) {
        self.f = g;
    }
}

service readonly class InvalidReadOnlyServiceClass {
    int[] y;

    function init(int[] y) {
        self.y = y; // @error incompatible types: expected '(int[] & readonly)', found 'int[]'
    }

    resource function get bar() {

    }
}
public class Foo {
    int i = 0;

    public isolated function func() {

    }
}

public readonly class Bar {
    int i = 1;

    function func() {

    }
}

public readonly class Baz {
    int i = 2;

    public function func() {

    }
}

Foo & readonly readonlyFoo1 = new Bar(); // @error incompatible types: expected '(Foo & readonly)', found 'Bar'

function testReadOnlyClassIntersectionWithMismatchedQualifiers() {
    Foo & readonly readonlyFoo1 = new Baz(); // @error incompatible types: expected '(Foo & readonly)', found 'Baz'
}
