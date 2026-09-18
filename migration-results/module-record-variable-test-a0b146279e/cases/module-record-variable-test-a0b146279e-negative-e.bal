type Person record {|
    string name;
    boolean married;
|};

string Fname = "myfirst name";
Person {name: Fname, married: Married} = {name: "Jhone", married: true}; // @error
boolean Married = false; // @error

public function testBasic() returns [string, boolean] {
    return [Fname, Married];
}

Person {name: Fname2, married: Married2, age: Age2} = {name: "Jhone", married: true}; // @error

isolated Person {name: name3, married: married3} = {name: "Jhone", married: true}; // @error

configurable Person {name: name4, married: married4} = {name: "Jhone", married: true}; // @error

const annotation annot on source function;

@annot // @error
Person {name: name5} = {name: "Mack"}; // @error

Person {name: name6, married: married6} = {name: name7, married: n}; // @error
var {name: name7} = getVarValues();
boolean n = false;

function getVarValues() returns record {string name;} {
    return {name: "Sam"};
}

var {fieldA: {fieldAVar}, fieldB: error(msg)} = foo(); // @error // @error

type ComplexRecord record {|
    [int] fieldA;
    map<string> fieldB;
    error fieldC;
    int...;
|};

function foo() returns ComplexRecord =>
    {fieldA: [8], fieldB: {a: "Ballerina"}, fieldC: error("NullPointer"), "int1": 1, "int2": 2};

type Employee record {
    string name;
    int id;
    int age?;
};

function getEmployee() returns Employee {
    return {name: "Jo", id: 1234, age: 12};
}

var {name: eName, id: eId, age: eAge} = getEmployee();
Employee {name: eNameNew, id: eIdNew, age: eAgeNew} = getEmployee();

type EmployeeNew record {
    string name;
    record {
        int id;
        int age?;
    } details?;
};

function getNewEmployeeList() returns EmployeeNew[2] {
    return [{name: "Jo", details: {id: 1234}}, {name: "Amy", details: {id: 1234}}];
}

var [{name: nameNew, details: {id: idNew, age: ageNew}}, ...x] = getNewEmployeeList();

type Topt record {
    int a;
    record {
        int b?;
    }[1] c?;
};

Topt topt = {a: 4, c: [{b: 5}]};
var {a, c} = topt;
var _ = c[0]; // @error
