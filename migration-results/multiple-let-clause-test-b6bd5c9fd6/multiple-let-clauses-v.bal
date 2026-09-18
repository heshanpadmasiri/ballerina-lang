import ballerina/io;

type Person record {|
    string firstName;
    string lastName;
    string deptAccess;
|};
type Company record { string name; };
type Teacher record {|
    string firstName;
    string lastName;
    int age;
    string teacherId;
|};
type Department record {| int id; string name; |};
type Employee record {| string fname; string lname; int deptId; |};

function testMultipleLetClausesWithSimpleVariable1() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Person[] outputPersonList = from var person in personList
        let string depName = "WSO2", string replaceName = "Alexander"
        where person.deptAccess == "XYZ" && person.firstName == "Alex"
        select {firstName: replaceName, lastName: person.lastName, deptAccess: depName};
    return outputPersonList;
}

function testMultipleLetClausesWithSimpleVariable2() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Person[] outputPersonList = from var person in personList
        let string depName = "WSO2"
        let string replaceName = "Alexander"
        where person.deptAccess == "XYZ" && person.firstName == "Alex"
        select {firstName: replaceName, lastName: person.lastName, deptAccess: depName};
    return outputPersonList;
}

function testMultipleLetClausesWithRecordVariable() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Person[] outputPersonList = from var {firstName: nm1, lastName: nm2, deptAccess: _} in personList
        let Company companyRecord = {name: "WSO2"}
        select {firstName: nm1, lastName: nm2, deptAccess: companyRecord.name};
    return outputPersonList;
}

function testMultipleVarDeclReuseLetClause() returns Teacher[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"}
    ];
    Teacher[] outputPersonList = from var person in personList
        let int x = 20, int y = x + 10
        select {firstName: person.firstName, lastName: person.lastName, age: y, teacherId: "TER1200"};
    return outputPersonList;
}

function getDept(Person p, stream<Department> dStream) returns Department? {
    foreach var d in dStream {
        if d.name == p.deptAccess {
            return d;
        }
    }
}

function assertEquality(anydata actual, anydata expected) {
    if actual != expected {
        panic error("assertion failed");
    }
}

function testQueryExpressionWithinLetClause() {
    Person[] personList = [
        {deptAccess: "OP", firstName: "Ranjan", lastName: "Fonseka"},
        {deptAccess: "MKT", firstName: "Alex", lastName: "George"},
        {deptAccess: "ENG", firstName: "Grainier", lastName: "Perera"}
    ];
    Department[] deptList = [{id: 1, name: "ENG"}, {id: 2, name: "HR"}, {id: 3, name: "OP"}];
    Employee[] empList = from var person in personList
        let stream<Department> dS = (stream from var dep in deptList where dep.name != "HR" select dep)
        let Department? d = getDept(person, dS)
        where d != ()
        select {fname: person.firstName, lname: person.lastName, deptId: d.id};
    Employee emp;
    any res = empList;
    assertEquality(true, res is Employee[]);
    assertEquality(true, res is (any|error)[]);
    assertEquality(2, empList.length());
    emp = empList[0];
    assertEquality("Ranjan", emp.fname);
    assertEquality("Fonseka", emp.lname);
    assertEquality(3, emp.deptId);
    emp = empList[1];
    assertEquality("Grainier", emp.fname);
    assertEquality("Perera", emp.lname);
    assertEquality(1, emp.deptId);
}

function testwildcardBindingPatternInLetClause() {
    Person[] personList = [
        {deptAccess: "OP", firstName: "Ranjan", lastName: "Fonseka"},
        {deptAccess: "MKT", firstName: "Mark", lastName: "George"},
        {deptAccess: "ENG", firstName: "Grainier", lastName: "Perera"}
    ];
    Person[] outputPersonList = from var person in personList
        let error error(_, msg = message1) = bar()
        let var [_, name] = foo()
        where person.deptAccess == "MKT" && person.firstName == name
        select {firstName: name, lastName: person.lastName, deptAccess: "WSO2"};
    assertEquality(1, outputPersonList.length());
    Person p = outputPersonList[0];
    assertEquality(p.firstName, "Mark");
    assertEquality(p.lastName, "George");
}

function foo() returns [string, string] { return ["Mark", "Mark"]; }
function bar() returns FooError { return error("", msg = "asdasd"); }
type Foo record { string msg; };
type FooError error<Foo>;

type Label record { string name; };
type PR record { string url; Label[] labels; };

function testQueryInLetClauseAsAClosure1() {
    PR[] prs = [
        {url: "url1", labels: [{name: "name1", "default": false}]},
        {url: "url2", labels: [{name: "name2", "default": false}, {name: "name3", "default": false}]}
    ];
    PR[] projectedPRs = from var {url, labels} in prs
        let var projectedLabels = from var {name} in labels select {name}
        select {url, labels: projectedLabels};
    assertEquality(projectedPRs[0].url, "url1");
    assertEquality(projectedPRs[0].labels[0].name, "name1");
    assertEquality(projectedPRs[1].url, "url2");
    assertEquality(projectedPRs[1].labels[0].name, "name2");
    assertEquality(projectedPRs[1].labels[1].name, "name3");
}

function testQueryInLetClauseAsAClosure2() {
    PR[] prs = [
        {url: "url1", labels: [{name: "name1", "default": false}]},
        {url: "url2", labels: [{name: "name2", "default": false}, {name: "name3", "default": false}]}
    ];
    PR[] projectedPRs = from var {url, labels: l} in prs
        let var projectedLabels = from var {name} in l select {name}
        select {url, labels: projectedLabels};
    assertEquality(projectedPRs[0].url, "url1");
    assertEquality(projectedPRs[0].labels[0].name, "name1");
    assertEquality(projectedPRs[1].url, "url2");
    assertEquality(projectedPRs[1].labels[0].name, "name2");
    assertEquality(projectedPRs[1].labels[1].name, "name3");
}

type LabelA record { string name; ColorA[] labels; };
type ColorA record { string code; };
type PRA record { string url; LabelA[] labels; };

function testQueryInLetClauseAsAClosure3() {
    PRA[] prs = [
        {url: "url1", labels: [{name: "name1", "default": false, labels: [{code: "0x2354F1"}]}]},
        {url: "url2", labels: [
            {name: "name2", "default": false, labels: [{code: "0xFFEA45"}]},
            {name: "name3", "default": false, labels: [{code: "0xHGEABB"}]}
        ]}
    ];
    PRA[] projectedPRs = from var {url, labels: l} in prs
        let var projectedLabels = from var {name, labels} in l
            let var projectedColors = from var {code} in labels select {code: code.concat("FOO")}
            select {name, labels: projectedColors}
        select {url, labels: projectedLabels};
    assertEquality(projectedPRs[0].url, "url1");
    assertEquality(projectedPRs[0].labels[0].name, "name1");
    assertEquality(projectedPRs[0].labels[0].labels[0].code, "0x2354F1FOO");
    assertEquality(projectedPRs[1].url, "url2");
    assertEquality(projectedPRs[1].labels[0].name, "name2");
    assertEquality(projectedPRs[1].labels[0].labels[0].code, "0xFFEA45FOO");
    assertEquality(projectedPRs[1].labels[1].name, "name3");
    assertEquality(projectedPRs[1].labels[1].labels[0].code, "0xHGEABBFOO");
}

public function main() {
    Person[] simpleOne = testMultipleLetClausesWithSimpleVariable1();
    io:println(simpleOne[0].firstName); // @output Alexander
    io:println(simpleOne[0].lastName); // @output George
    io:println(simpleOne[0].deptAccess); // @output WSO2

    Person[] simpleTwo = testMultipleLetClausesWithSimpleVariable2();
    io:println(simpleTwo[0].firstName); // @output Alexander
    io:println(simpleTwo[0].lastName); // @output George
    io:println(simpleTwo[0].deptAccess); // @output WSO2

    Person[] records = testMultipleLetClausesWithRecordVariable();
    io:println(records[0].keys().length()); // @output 3
    io:println(records[0].firstName); // @output Alex
    io:println(records[0].lastName); // @output George
    io:println(records[0].deptAccess); // @output WSO2

    Teacher[] teachers = testMultipleVarDeclReuseLetClause();
    io:println(teachers.length()); // @output 2
    io:println(teachers[0].firstName); // @output Alex
    io:println(teachers[0].lastName); // @output George
    io:println(teachers[0].age); // @output 30
    io:println(teachers[1].firstName); // @output Ranjan
    io:println(teachers[1].lastName); // @output Fonseka
    io:println(teachers[1].age); // @output 30

    testQueryExpressionWithinLetClause();
    testwildcardBindingPatternInLetClause();
    testQueryInLetClauseAsAClosure1();
    testQueryInLetClauseAsAClosure2();
    testQueryInLetClauseAsAClosure3();
}
