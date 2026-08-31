# Define a constant
# # Deprecated
# This constant is deprecated
@deprecated
const string CONST1 = "CONST1";
const string CONST2 = "CONST2";

# Define a type
# # Deprecated
# This type is deprecated
@deprecated
public type Foo CONST1|CONST2;

# The `DummyObject` is a user-defined object.
#
# + fieldOne - This is the description of the `DummyObject`'s `fieldOne` field.
# + fieldTwo - This is the description of the `DummyObject`'s `fieldTwo` field.
# # Deprecated
# This object is deprecated
@deprecated
public class DummyObject {
    public string fieldOne = "Foo";
    Foo foo = CONST1; // @error
    public string fieldTwo = "";
    @deprecated
    public function doThatOnObject(string paramOne) {
    }
}

@deprecated
public function func1() {
    DummyObject _ = new; // @error
}

public function func2(DummyObject obj, Foo foo, string str = CONST1) { // @error
    func1(); // @error
}

@deprecated
public function func3() {
}

public function func4() {
    func3(); // @error
}

type Annot record {
    string foo;
    int bar?;
};

@deprecated
public annotation Annot v1 on type, class;
@deprecated
public annotation Annot[] v2 on class;
@deprecated
public annotation map<int> v4 on object function, function, class;

string strValue = "v1 value";

@v1 { // @error
    foo: strValue,
    bar: 1
}
public type T1 record {
    string name;
};

T1 a = { name: "John" };

function testAnnotationDeprecation() {
    typedesc<any> t = typeof a;
    Annot? _ = t.@v1; // @error
    Annot[]? _ = t.@v2; // @error
}

@v1 { // @error
    foo: strValue
}
@v2 { // @error
    foo: "v2 value 1"
}
@v2 { // @error
    foo: "v2 value 2"
}
class T2 {
    string name = "ballerina";
    @v4 { // @error
        val: 42
    }
    public function objMethod() {
    }
}

@v4 { // @error
    val: 42
}
public function deprecated_annotation_func() {
}

@deprecated
function add1(@deprecated int x, @deprecated int y, @deprecated int z) returns int {
    return x + y + z; // @error
}

@deprecated
function add2(@deprecated int x, @deprecated int y, @deprecated int z) returns int {
    return x + y + z; // @error
}

const string CONST3 = "CONST3";
const string CONST4 = "CONST4";
public type TYPE1 CONST3|CONST4;

@deprecated
public class Object1 {
    @deprecated
    public string fieldOne = "Foo";
    @deprecated
    TYPE1 t = CONST3;
    public string fieldTwo = "";
    public function doThatOnObject(string paramOne, TYPE1 t) {
        self.fieldOne = paramOne; // @error
        self.t = t; // @error
    }
}

public class Object2 {
    @deprecated
    public string fieldOne = "Foo";
    @deprecated
    TYPE1 t = CONST3;
    public string fieldTwo = "";
    public function doThatOnObject(string paramOne, TYPE1 t) {
        self.fieldOne = paramOne; // @error
        self.t = t; // @error
    }
}

public class Object3 {
    @deprecated
    public string fieldOne = "Foo";
    @deprecated
    TYPE1 t = CONST3;
    public string fieldTwo = "";
    public function doThatOnObject(string paramOne, TYPE1 t) {
        self.fieldOne = paramOne; // @error
        self.t = t; // @error
    }
}

public function func5() {
    int _ = add1(2, 3, 3); // @error
    int _ = add2(2, 4, 5); // @error
    Object1 _ = new; // @error
    Object2 _ = new;
}

function add3(int x, int y, @deprecated int... z) {
    int _ = z[0]; // @error
}

public function typeReturn() returns Foo { // @error
    Foo f = CONST2; // @error
    return f;
}

public function getType() {
    Foo _ = typeReturn(); // @error
}

class SimpleClass {
}

function testObjectConstructorWithCodeAnalyzer() {
    SimpleClass|float _ = object SimpleClass { // @error
        @deprecated
        function init() {
        }
    };
}

@deprecated
annotation myAnnot on function;

@myAnnot // @error
function testUsingDeprecatedAnnotation() {
}

function testAccessingDeprecatedAnnotation() {
    typedesc funcType = typeof testUsingDeprecatedAnnotation();
    _ = funcType.@myAnnot; // @error
}

@deprecated
type MyObject client object {
    @deprecated
    int id;
    @deprecated
    remote function getId() returns int;
};

@deprecated
class Person {
    @deprecated
    string name = "john";
    @deprecated
    function getName() returns string {
        return self.name; // @error
    }
    function getAge() {
    }
}

function testUsingDeprecatedFieldsMethodsAndTypes(int i, string s) {
    MyObject obj = client object MyObject { // @error
        @deprecated
        int id = 4;
        remote function getId() returns int {
            return self.id; // @error
        }
    };
    int _ = obj.id; // @error
    int _ = obj->getId(); // @error
    Person obj2 = new Person(); // @error
    string _ = obj2.name; // @error
    string _ = obj2.getName(); // @error
    obj2.getAge();
}

@deprecated
function myFunction(int i, string s) {
}

function testUsingDepricatedFunction() {
    myFunction(1, "hello"); // @error
}

type Employee record {|
    @deprecated
    string name;
    int id;
    @deprecated
    Job job;
|};

type Job record {|
    string title;
    @deprecated
    int experience;
|};

public function testDeprecatedRecordFields() {
    Employee employee = {name: "John", id: 112, job: {title: "SE", experience: 2}}; // @error
    _ = employee.name; // @error
    _ = employee.id;
    _ = employee.job; // @error
    _ = employee.job.title; // @error
    _ = employee.job.experience; // @error
}

type Employee2 record {|
    @deprecated
    string name;
    int id;
    @deprecated
    Job job;
|};

public function testDeprecatedRecordFieldsWithDocumentation() {
    Employee2 employee2 = {name: "John", id: 112, job: {title: "SE", experience: 2}}; // @error
    _ = employee2.name; // @error
    _ = employee2.id;
    _ = employee2.job; // @error
}

record {|
    @deprecated
    string name;
    int id;
|} employee3 = {name: "Jo", id: 123}; // @error

public function testDeprecatedAnonRecord() {
    _ = employee3.name; // @error
    _ = employee3.id;
}

record {|
    @deprecated
    string name;
    int id;
|} employee4 = {name: "Jo", id: 123}; // @error

public function testDeprecatedAnonRecordWithDocumentation() {
    _ = employee4.name; // @error
    _ = employee4.id;
}

type Employee5 record {
    string fname = "";
    string lname = "";
    int age = 0;
    @deprecated
    record { string line01 = "";
             @deprecated
             string line02 = "";
             string city = "";
             string state = "";
             string zipcode = "";
    } address;
};

public function testDeprecatedAnonStructAsStructField() {
    Employee5 employee5 = {address: {}}; // @error
    _ = employee5.address; // @error
    _ = employee5.address.line02; // @error
}

type Company record {
    int companyId;
    @deprecated
    string name;
    @deprecated
    string city;
    @deprecated
    string country;
};

public function testDeprecatedAnonRecordFieldInInitialization() {
    Job _ = {
        title: "SE",
        experience: 1 // @error
    };
    int experience = 2;
    Job _ = {
        title: "SE",
        experience // @error
    };
    var details = {experience: 2};
    Job _ = {
        title: "SE",
        ...details // @error
    };
    string city = "Berlin";
    var companyDetails = {country: "Germany"};
    Company _ = {
        companyId: 1,
        name: "Foo", // @error
        city: city, // @error
        ...companyDetails // @error
    };
}

function fooFn(int x1, @deprecated int x2) {
}

function barFn(string s, *Company company) {
}

function bazFn(string a, @deprecated string b, @deprecated int... c) {
}

function quxFn(@deprecated string y1 = "Qux", @deprecated int y2 = 10) {
}

function quuxFn(record {|
    int id;
    record {|string name; @deprecated int age;|} person;
|} z) {
}

public function testDeprecatedParamUsages() {
    fooFn(10, 11); // @error
    fooFn(12, x2 = 13); // @error
    fooFn(x1 = 14, x2 = 15); // @error
    barFn("bar", {
        companyId: 1,
        city: "Berlin", // @error
        country: "Germany", // @error
        name: "Bar" // @error
    });
    barFn(
        "bar",
        companyId = 1,
        city = "Berlin", // @error
        country = "Germany", // @error
        name = "Bar" // @error
    );
    bazFn(
        "A",
        "B", // @error
        1, // @error
        2, // @error
        3 // @error
    );
    quxFn(
        "Quux", // @error
        11 // @error
    );
    quxFn(
        y1 = "Quux", // @error
        y2 = 11 // @error
    );
    quuxFn({
        id: 1,
        person: {
            name: "John",
            age: 12 // @error
        }
    });
    [int, int] argX = [1, 2];
    fooFn(...argX); // @error
    fooFn(...[
            1,
            2 // @error
        ]
    );
    var fn1 = function () returns int => 1;
    fooFn(...[
        1,
        ...[
            fn1() // @error
            ]
        ]
    );
    var fn2 = function () returns [int, int] => [1, 2];
    fooFn(...[
        ...[
            ...fn2() // @error
            ]
        ]
    );
    bazFn(
        "A",
        ...[
            "B", // @error
            1, // @error
            3 // @error
        ]
    );
}
