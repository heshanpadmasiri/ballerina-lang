import ballerina/io;

type Name record { string fname; string lname; };
type Customer record { readonly Name name; readonly int id; string address; };
type CustomerTableWithKS table<Customer> key(name);
type CustomerTableWithCKS table<Customer> key(id, name);
type CustomerTableWithKTC table<Customer> key<Name>;
type CustomerTableWithCKTC table<Customer> key<[int, Name]>;

const string TABLE = "[{\"name\":{\"fname\":\"Sanjiva\",\"lname\":\"Weerawarana\"},\"id\":13,\"address\":\"Sri Lanka\"},{\"name\":{\"fname\":\"James\",\"lname\":\"Clark\"},\"id\":23,\"address\":\"Thailand\"}]";
const int id = 1;
const string status = "status - 1";

public function main() {
    runKeySpecifierTestCases();
    runMemberAccessTestCases();
    testKeylessTable();
    testMemberAccessWithInvalidSingleKey();
    testMemberAccessWithInvalidMultiKey();
    runTableTestcasesWithVarType();
    testDefaultValueFieldAsKeyField();
    testDefaultValueFieldAsKeyField2();
    testDefaultValueFieldAsKeyField3();
    testDefaultValueFieldAsKeyField4();
    testDefaultValueFieldAsKeyField5();
    testDefaultValueFieldAsKeyField6();
    io:println("ok"); // @output ok
}

function runKeySpecifierTestCases() {
    testTableTypeWithKeySpecifier();
    testTableConstructorWithKeySpecifier();
    testTableTypeWithCompositeKeySpecifier();
    testTableConstructorWithCompositeKeySpecifier();
    testTableTypeWithKeyTypeConstraint();
    testTableTypeWithCompositeKeyTypeConstraint();
    testTableTypeWithMultiFieldKeys();
    testVariableNameFieldAsKeyField();
    testVariableNameFieldAsKeyField2();
}

function testTableTypeWithKeySpecifier() {
    CustomerTableWithKS tab = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

function testTableConstructorWithKeySpecifier() {
    CustomerTableWithKS tab = table key(name) [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

function testTableTypeWithCompositeKeySpecifier() {
    CustomerTableWithCKS tab = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

function testTableConstructorWithCompositeKeySpecifier() {
    CustomerTableWithCKS tab = table key(id, name) [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

function testTableTypeWithKeyTypeConstraint() {
    CustomerTableWithKTC tab = table key(name) [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

function testTableTypeWithCompositeKeyTypeConstraint() {
    CustomerTableWithCKTC tab = table key(id, name) [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    assertEquality(TABLE, tab.toString());
}

type EmployeeId record { readonly string firstname; readonly string lastname; };
type Employee1 record { *EmployeeId; int leaves; };
type EmployeeTable table<Employee1> key<EmployeeId>;

function testTableTypeWithMultiFieldKeys() {
    string expected = "[{\"leaves\":10,\"firstname\":\"John\",\"lastname\":\"Wick\"}]";
    table<Employee1> key<EmployeeId> t1 = table key(firstname, lastname) [{firstname: "John", lastname: "Wick", leaves: 10}];
    assertEquality(expected, t1.toString());
    EmployeeTable t2 = table key(firstname, lastname) [{firstname: "John", lastname: "Wick", leaves: 10}];
    assertEquality(expected, t2.toString());
}

function runMemberAccessTestCases() {
    testMemberAccessWithSingleRecordKey();
    testMemberAccessWithMultiKeyAsTuple();
    testMemberAccessWithMultiKey();
}

function testMemberAccessWithSingleRecordKey() {
    table<Customer> key(name) customerTable = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    Customer? customer = customerTable[{fname: "Sanjiva", lname: "Weerawarana"}];
    assertEquality("Sri Lanka", customer["address"]);
}

function testMemberAccessWithMultiKeyAsTuple() {
    table<Customer> key(id, name) customerTable = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    Customer? customer = customerTable[[13, {fname: "Sanjiva", lname: "Weerawarana"}]];
    assertEquality("Sri Lanka", customer["address"]);
}

function testMemberAccessWithMultiKey() {
    table<Customer> key(id, name) customerTable = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    Customer? customer = customerTable[13, {fname: "Sanjiva", lname: "Weerawarana"}];
    assertEquality("Sri Lanka", customer["address"]);
}

function testKeylessTable() {
    table<Customer> customerTable = table [
        {name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"},
        {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"},
        {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}
    ];
    assertEquality(3, customerTable.length());
    assertEquality("[{\"name\":{\"fname\":\"Sanjiva\",\"lname\":\"Weerawarana\"},\"id\":13,\"address\":\"Sri Lanka\"},{\"name\":{\"fname\":\"James\",\"lname\":\"Clark\"},\"id\":23,\"address\":\"Thailand\"},{\"name\":{\"fname\":\"James\",\"lname\":\"Clark\"},\"id\":23,\"address\":\"Thailand\"}]", customerTable.toString());
}

function testMemberAccessWithInvalidSingleKey() {
    table<Customer> key(name) customerTable = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    Customer? customer = customerTable[{fname: "Sanjiva", lname: "Clark"}];
    assertEquality((), customer);
}

function testMemberAccessWithInvalidMultiKey() {
    table<Customer> key(id, name) customerTable = table [{name: {fname: "Sanjiva", lname: "Weerawarana"}, id: 13, address: "Sri Lanka"}, {name: {fname: "James", lname: "Clark"}, id: 23, address: "Thailand"}];
    Customer? customer = customerTable[18, {fname: "Sanjiva", lname: "Clark"}];
    assertEquality((), customer);
}

function runTableTestcasesWithVarType() {
    testSimpleTableInitializationWithVarType();
    testTableWithKeySpecifier();
    testInferTableType();
    testInferTableTypeV2();
}

function testSimpleTableInitializationWithVarType() {
    var customerTable = table [{id: 13, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: xml `<city>COL</city>`}, {id: 23, name: {fname: "James", lname: "Clark"}, address: xml `<city>BNK</city>`}];
    assertEquality(2, customerTable.length());
}

function testTableWithKeySpecifier() {
    var customerTable = table key(id) [{id: 13, name: {fname: "Sanjiva", lname: "Weerawarana"}, address: xml `<city>COL</city>`}, {id: 23, name: {fname: "James", lname: "Clark"}, address: xml `<city>BNK</city>`}];
    assertEquality(2, customerTable.length());
    Name name = {fname: "Sanjiva", lname: "Weerawarana"};
    assertEquality(name, customerTable[13]["name"]);
}

function testInferTableType() {
    string expected = "[{\"id\":13,\"name\":\"Sanjiva\",\"lname\":\"Weerawarana\"},{\"id\":23,\"name\":\"James\"},{\"id\":133,\"name\":\"Mohan\",\"lname\":\"Darshan\",\"address\":{\"no\":32,\"road\":\"High level\"}}]";
    var tab = table [{id: 13, name: "Sanjiva", lname: "Weerawarana"}, {id: 23, name: "James"}, {id: 133, name: "Mohan", lname: "Darshan", address: {no: 32, road: "High level"}}];
    assertEquality(expected, tab.toString());
}

function testInferTableTypeV2() {
    var tb = table [{id: 1, name: "Mary", salary: 100.0, address: {no: 32, road: "High level"}}, {id: 2, name: "Jo", age: 12}];
    tb.put({id: 3, name: "Pope", salary: 200.0, age: 19, address: {no: 12, road: "Sea street"}});
    assertEquality(3, tb.length());
}

function expectedRecords() returns record { readonly int id; string name; }[] => [
    {id: 1, name: "Jo"}, {id: 2, name: "Amy"}
];

function testVariableNameFieldAsKeyField() {
    record { readonly int id; string name; }[] expected = expectedRecords();
    table<record { readonly int id; string name; }> key(id) tb = table [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach int i in 0..<tb.length() { assertEquality(tb[i + 1], expected[i]); }
}

function testVariableNameFieldAsKeyField2() {
    int index = 0;
    var expected = [{"id": 1, "name": "Jo"}, {"id": 2, "name": "Amy"}];
    table<record { readonly int id; string name; }> tb = table key(id) [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach var rec in tb { assertEquality(rec, expected[index]); index += 1; }
}

type CustomRecord record { readonly int id = 1; string name; };
type CustomRecord2 record { readonly int id = 1; readonly string status = "status - 1"; string name; };

function testDefaultValueFieldAsKeyField() {
    record { readonly int id; string name; }[] expected = expectedRecords();
    table<record { readonly int id = 1; string name; }> key(id) tb = table [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach int i in 0..<tb.length() { assertEquality(tb[i + 1], expected[i]); }
}

function testDefaultValueFieldAsKeyField2() {
    record { readonly int id; string name; }[] expected = expectedRecords();
    table<CustomRecord> key(id) tb = table [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach int i in 0..<tb.length() { assertEquality(tb[i + 1], expected[i]); }
}

function testDefaultValueFieldAsKeyField3() {
    CustomRecord2[] expected = [{id: 1, status, name: "Jo"}, {id: 2, status: "status - 2", name: "Amy"}];
    table<CustomRecord2> key(id, status) tb = table [{id, status, name: "Jo"}, {id: 2, status: "status - 2", name: "Amy"}];
    foreach int i in 0..<tb.length() { assertEquality(tb[i + 1, string `status - ${i + 1}`], expected[i]); }
}

function testDefaultValueFieldAsKeyField4() {
    int index = 0;
    var expected = [{"id": 1, "name": "Jo"}, {"id": 2, "name": "Amy"}];
    table<record { readonly int id = 1; string name; }> tb = table key(id) [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach var rec in tb { assertEquality(rec, expected[index]); index += 1; }
}

function testDefaultValueFieldAsKeyField5() {
    int index = 0;
    var expected = [{"id": 1, "name": "Jo"}, {"id": 2, "name": "Amy"}];
    table<CustomRecord> tb = table key(id) [{id, name: "Jo"}, {id: 2, name: "Amy"}];
    foreach var rec in tb { assertEquality(rec, expected[index]); index += 1; }
}

function testDefaultValueFieldAsKeyField6() {
    int index = 0;
    var expected = [{"id": 1, "status": "status - 1", "name": "Jo"}, {"id": 2, "status": "status - 2", "name": "Amy"}];
    table<CustomRecord2> tb = table key(id, status) [{id, status, name: "Jo"}, {id: 2, status: "status - 2", name: "Amy"}];
    foreach var rec in tb { assertEquality(rec, expected[index]); index += 1; }
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual { return; }
    if expected === actual { return; }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("AssertionError", message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
