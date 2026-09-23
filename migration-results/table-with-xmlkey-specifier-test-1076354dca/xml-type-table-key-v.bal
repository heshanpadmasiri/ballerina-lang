import ballerina/io;

type Customer record {
    readonly xml id;
    readonly Name name;
    string address;
};

type Name record {
    string fname;
    string lname;
};

type CustomerTableWithKS table<Customer> key(id);
type CustomerTableWithoutKS table<Customer>;
type CustomerTableWithKC table<Customer> key<xml>;

public function main() {
    runKeySpecifierTestCases();
    runMemberAccessTestCases();
    testMemberAccessWithInvalidXMLRecordKey();
    testMemberAccessWithInvalidXMLMultiKey();
    runTableTestcasesWithVarType();
}

function runKeySpecifierTestCases() {
    testTableTypeWithXMLKeySpecifierV1();
    testTableTypeWithXMLKeySpecifierV2();
    testTableTypeWithXMLKeyTypeConstraint();
    testTableTypeWithXMLKeyAndVar();
}

function testTableTypeWithXMLKeySpecifierV1() {
    CustomerTableWithKS tab = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(tab); // @output [{"id":`<id>123</id>`,"name":{"fname":"Sanjiva","lname":"Weerawarana"},"address":"Sri Lanka"},{"id":`<id>234</id>`,"name":{"fname":"James","lname":"Clark"},"address":"Thailand"}]
}

function testTableTypeWithXMLKeySpecifierV2() {
    CustomerTableWithoutKS tab = table key(id) [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(tab); // @output [{"id":`<id>123</id>`,"name":{"fname":"Sanjiva","lname":"Weerawarana"},"address":"Sri Lanka"},{"id":`<id>234</id>`,"name":{"fname":"James","lname":"Clark"},"address":"Thailand"}]
}

function testTableTypeWithXMLKeyTypeConstraint() {
    CustomerTableWithKC tab = table key(id) [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(tab); // @output [{"id":`<id>123</id>`,"name":{"fname":"Sanjiva","lname":"Weerawarana"},"address":"Sri Lanka"},{"id":`<id>234</id>`,"name":{"fname":"James","lname":"Clark"},"address":"Thailand"}]
}

function testTableTypeWithXMLKeyAndVar() {
    var tab = table key(id) [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(tab); // @output [{"id":`<id>123</id>`,"name":{"fname":"Sanjiva","lname":"Weerawarana"},"address":"Sri Lanka"},{"id":`<id>234</id>`,"name":{"fname":"James","lname":"Clark"},"address":"Thailand"}]
}

function runMemberAccessTestCases() {
    testMemberAccessWithSingleXMLRecordKey();
    testMemberAccessWithXMLMultiKeyAsTuple();
    testMemberAccessWithXMLMultiKey();
}

function testMemberAccessWithSingleXMLRecordKey() {
    table<Customer> key(id) customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    Customer? customer = customerTable[xml `<id>123</id>`];
    io:println(customer["address"]); // @output Sri Lanka
}

function testMemberAccessWithXMLMultiKeyAsTuple() {
    table<Customer> key(id, name) customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    Customer? customer = customerTable[[xml `<id>123</id>`, {fname: "Sanjiva", lname: "Weerawarana"}]];
    io:println(customer["address"]); // @output Sri Lanka
}

function testMemberAccessWithXMLMultiKey() {
    table<Customer> key(id, name) customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    Customer? customer = customerTable[xml `<id>123</id>`, {fname: "Sanjiva", lname: "Weerawarana"}];
    io:println(customer["address"]); // @output Sri Lanka
}

function testMemberAccessWithInvalidXMLRecordKey() {
    table<Customer> key(id) customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    Customer? customer = customerTable[xml `<id>245</id>`];
    io:println(customer is () ? "()" : customer); // @output ()
}

function testMemberAccessWithInvalidXMLMultiKey() {
    table<Customer> key(id, name) customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    Customer? customer = customerTable[xml `<id>245</id>`, {fname: "Sanjiva", lname: "Weerawarana"}];
    io:println(customer is () ? "()" : customer); // @output ()
}

function runTableTestcasesWithVarType() {
    testSimpleTableInitializationWithVarType();
    testTableWithKeySpecifier();
    testInferTableType();
    testInferTableTypeV2();
}

function testSimpleTableInitializationWithVarType() {
    var customerTable = table [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(customerTable.length()); // @output 2
}

function testTableWithKeySpecifier() {
    var customerTable = table key(id) [
        {id: xml `<id>123</id>`, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: "Sri Lanka"},
        {id: xml `<id>234</id>`, name: {fname: "James", lname: "Clark"}, address: "Thailand"}
    ];
    io:println(customerTable.length()); // @output 2
    io:println(customerTable[xml `<id>123</id>`]["address"]); // @output Sri Lanka
}

function testInferTableType() {
    var tab = table [
        {id: xml `<id>123</id>`, name: "Sanjiva", lname: "Weerawarana"},
        {id: xml `<id>1233</id>`, name: "James"},
        {id: xml `<id>444</id>`, name: "Mohan", lname: "Darshan", address: {no: 32, road: "High level"}}
    ];
    io:println(tab); // @output [{"id":`<id>123</id>`,"name":"Sanjiva","lname":"Weerawarana"},{"id":`<id>1233</id>`,"name":"James"},{"id":`<id>444</id>`,"name":"Mohan","lname":"Darshan","address":{"no":32,"road":"High level"}}]
}

function testInferTableTypeV2() {
    var tb = table [
        {id: xml `<id>1233</id>`, name: "Mary", salary: 100.0, address: {no: 32, road: "High level"}},
        {id: xml `<id>453</id>`, name: "Jo", age: 12}
    ];
    tb.put({id: xml `<id>1233</id>`, name: "Pope", salary: 200.0, age: 19, address: {no: 12, road: "Sea street"}});
    io:println(tb.length()); // @output 3
}
