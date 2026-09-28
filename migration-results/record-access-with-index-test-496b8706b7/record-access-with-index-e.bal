function testUndeclaredStructAccess() {
    string name = "";
    dpt1[name] = "HR"; // @error
}

function testUndeclaredAttributeAccess() {
    string name;
    Department dpt = {};
    dpt["id"] = "HR"; // @error
}

type Department record {|
    string dptName = "";
    int count = 0;
|};

function testInvalidTypeOfIndexExpression1() {
    Department dpt = {};
    int index = 1;
    var x = dpt[index]; // @error
}

function testInvalidTypeOfIndexExpression2() {
    Department dpt = {};
    string index = "dptName";
    string x = dpt[index]; // @error
}

const string FIELD_FOUR = "fieldFour";
type FiniteOne "fieldOne"|"fieldTwo"|0;
type FiniteTwo 0|1;
type FiniteThree "fieldOne"|"fieldTwo"|"fieldThree";
type FiniteFour FiniteThree|FIELD_FOUR;
type NoIntersection "F1"|"F2"|"F3"|FIELD_FOUR;

type Foo record {
    string|boolean fieldOne;
    int fieldTwo;
    float fieldThree;
};

type Bar record {|
    string|boolean fieldOne;
    int fieldTwo;
|};

function testFiniteTypeAsIndex() {
    FiniteOne f1 = "fieldOne";
    FiniteTwo f2 = 0;
    FiniteThree f3 = "fieldOne";
    NoIntersection f4 = "fieldFour";
    NoIntersection f5 = "F2";
    Foo foo = {fieldOne: "S", fieldTwo: 12, fieldThree: 98.9};
    Bar bar = {fieldOne: "S", fieldTwo: 12};
    string|boolean|int|float? v1 = foo[f1]; // @error
    string|boolean|int|float? v2 = foo[f2]; // @error
    string|boolean|int|float? v3 = foo[f3];
    string|boolean|int|float? v4 = bar[f1]; // @error
    string|boolean|int|float? v5 = bar[f2]; // @error
    string|boolean|int|float? v6 = bar[f4]; // @error
    var v7 = bar[f5]; // @error
}
