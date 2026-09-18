import ballerina/io;

public function main() {
    testTableConstructExprs();
}

function testTableConstructExprs() {
    testTableConstructExprWithAnyMap();
    testTableConstructExprWithAnydataMap();
    testTableConstructExprVar();
}

type CustomerTable table<map<any>>;

function testTableConstructExprWithAnyMap() {
    CustomerTable customerTable = table [
        {id: 13, name: "Sanjiva", lname: "Weerawarana"},
        {id: 23, name: "James", lname: "Clark"}
    ];

    io:println(customerTable.toString()); // @output [{"id":13,"name":"Sanjiva","lname":"Weerawarana"},{"id":23,"name":"James","lname":"Clark"}]
}

type TableWithAnydata table<map<anydata>>;

function testTableConstructExprWithAnydataMap() {
    TableWithAnydata customerTable = table [
        {id: 13, name: "Sanjiva", lname: "Weerawarana"},
        {id: 23, name: "James", lname: "Clark"}
    ];

    io:println(customerTable.toString()); // @output [{"id":13,"name":"Sanjiva","lname":"Weerawarana"},{"id":23,"name":"James","lname":"Clark"}]
}

function testTableConstructExprVar() {
    map<int> m = {a: 1, b: 2};

    var v1 = table [
        {name: "Jo"},
        {...m}
    ];

    table<record {|(string|int) name?; int...;|}> t1 = v1;
    io:println(t1.toString()); // @output [{"name":"Jo"},{"a":1,"b":2}]
}
