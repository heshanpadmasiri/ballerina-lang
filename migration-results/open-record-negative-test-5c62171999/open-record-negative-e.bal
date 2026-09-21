type Person record {|
    string name = "";
    int age = 0;
    string...;
|};

function invalidRestField() {
    Person p = { name: "John", age: 20, "height": 6, "employed": false, "city": "Colombo" }; // @error @error
}

type PersonA record {|
    string name = "";
    int age = 0;
    anydata|json...;
|};

function ambiguousEmptyRecordForRestField() {
    PersonA p = { name:"John", "misc": {} }; // @error
}

type Pet record {
    Animal lion; // @error
};

class Bar {
    int a = 0;
}

function testInvalidRestFieldAddition() {
    PersonA p = {};
    p["invField"] = new Bar(); // @error
}

type Baz record {|
    int a;
    anydata...;
|};

type Qux record {
    string s;
};

type MyError error;

function testErrorAdditionForInvalidRestField() {
    error e1 = error("test reason");
    MyError e2 = error("test reason 2", err = e1);
    Baz b = { a: 1 };
    b["err1"] = e1; // @error
    b["err2"] = e2; // @error

    Qux q = { s: "hello" };
    q["e1"] = e1; // @error
    q["e2"] = e2; // @error
}

function testAnydataOrErrorRestFieldRHSAccess() {
    Person p = {};
    anydata|error name = p?.firstName; // @error
}

type Teacher record {
    int toJson = 44;
};

function testLangFuncOnRecord() returns json {
    Teacher p = {};
    json toJsonResult = p.toValue(); // @error
    return toJsonResult;
}
