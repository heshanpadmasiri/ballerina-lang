import ballerina/io;

type Person record {|
    string firstName;
    string lastName;
    string deptAccess;
|};

type Department record {|
    string name;
|};

function testMultipleSelectClausesWithSimpleVariable() returns Person[] {
    Person p1 = {firstName: "Alex", lastName: "George", deptAccess: "XYZ"};
    Person p2 = {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"};
    Person p3 = {firstName: "John", lastName: "David", deptAccess: "XYZ"};
    Department d1 = {name: "HR"};
    Department d2 = {name: "Operations"};
    Person[] personList = [p1, p2, p3];
    Department[] deptList = [d1, d2];
    var outputPersonList =
        from var person in personList
        from var dept in deptList
        select {
            firstName: person.firstName,
            lastName: person.lastName,
            deptAccess: dept.name
        };
    return outputPersonList;
}

function testMultipleSelectClausesWithRecordVariable() returns Person[] {
    Person p1 = {firstName: "Alex", lastName: "George", deptAccess: "XYZ"};
    Person p2 = {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"};
    Person p3 = {firstName: "John", lastName: "David", deptAccess: "XYZ"};
    Department d1 = {name: "HR"};
    Department d2 = {name: "Operations"};
    Person[] personList = [p1, p2, p3];
    Department[] deptList = [d1, d2];
    var outputPersonList =
        from var {firstName: nm1, lastName: nm2, deptAccess: _} in personList
        from var {name: deptName} in deptList
        select {
            firstName: nm1,
            lastName: nm2,
            deptAccess: deptName
        };
    return outputPersonList;
}

function testMultipleSelectClausesWithRecordVariableV2() returns Person[] {
    Person p1 = {firstName: "Alex", lastName: "George", deptAccess: "XYZ"};
    Person p2 = {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"};
    Person p3 = {firstName: "John", lastName: "David", deptAccess: "XYZ"};
    Department d1 = {name: "HR"};
    Department d2 = {name: "Operations"};
    Person[] personList = [p1, p2, p3];
    Department[] deptList = [d1, d2];
    var outputPersonList =
        from var {firstName, lastName, deptAccess: _} in personList
        from var {name} in deptList
        select {
            firstName: firstName,
            lastName: lastName,
            deptAccess: name
        };
    return outputPersonList;
}

public function main() {
    Person[] simpleVariable = testMultipleSelectClausesWithSimpleVariable();
    io:println(simpleVariable.length()); // @output 6
    io:println(simpleVariable[0].firstName); // @output Alex
    io:println(simpleVariable[0].lastName); // @output George
    io:println(simpleVariable[0].deptAccess); // @output HR
    io:println(simpleVariable[1].firstName); // @output Alex
    io:println(simpleVariable[1].lastName); // @output George
    io:println(simpleVariable[1].deptAccess); // @output Operations
    io:println(simpleVariable[2].firstName); // @output Ranjan
    io:println(simpleVariable[2].lastName); // @output Fonseka
    io:println(simpleVariable[2].deptAccess); // @output HR
    io:println(simpleVariable[3].firstName); // @output Ranjan
    io:println(simpleVariable[3].lastName); // @output Fonseka
    io:println(simpleVariable[3].deptAccess); // @output Operations
    io:println(simpleVariable[4].firstName); // @output John
    io:println(simpleVariable[4].lastName); // @output David
    io:println(simpleVariable[4].deptAccess); // @output HR
    io:println(simpleVariable[5].firstName); // @output John
    io:println(simpleVariable[5].lastName); // @output David
    io:println(simpleVariable[5].deptAccess); // @output Operations

    Person[] recordVariable = testMultipleSelectClausesWithRecordVariable();
    io:println(recordVariable.length()); // @output 6
    io:println(recordVariable[0].firstName); // @output Alex
    io:println(recordVariable[0].lastName); // @output George
    io:println(recordVariable[0].deptAccess); // @output HR
    io:println(recordVariable[1].firstName); // @output Alex
    io:println(recordVariable[1].lastName); // @output George
    io:println(recordVariable[1].deptAccess); // @output Operations
    io:println(recordVariable[2].firstName); // @output Ranjan
    io:println(recordVariable[2].lastName); // @output Fonseka
    io:println(recordVariable[2].deptAccess); // @output HR
    io:println(recordVariable[3].firstName); // @output Ranjan
    io:println(recordVariable[3].lastName); // @output Fonseka
    io:println(recordVariable[3].deptAccess); // @output Operations
    io:println(recordVariable[4].firstName); // @output John
    io:println(recordVariable[4].lastName); // @output David
    io:println(recordVariable[4].deptAccess); // @output HR
    io:println(recordVariable[5].firstName); // @output John
    io:println(recordVariable[5].lastName); // @output David
    io:println(recordVariable[5].deptAccess); // @output Operations

    Person[] recordVariableV2 = testMultipleSelectClausesWithRecordVariableV2();
    io:println(recordVariableV2.length()); // @output 6
    io:println(recordVariableV2[0].firstName); // @output Alex
    io:println(recordVariableV2[0].lastName); // @output George
    io:println(recordVariableV2[0].deptAccess); // @output HR
    io:println(recordVariableV2[1].firstName); // @output Alex
    io:println(recordVariableV2[1].lastName); // @output George
    io:println(recordVariableV2[1].deptAccess); // @output Operations
    io:println(recordVariableV2[2].firstName); // @output Ranjan
    io:println(recordVariableV2[2].lastName); // @output Fonseka
    io:println(recordVariableV2[2].deptAccess); // @output HR
    io:println(recordVariableV2[3].firstName); // @output Ranjan
    io:println(recordVariableV2[3].lastName); // @output Fonseka
    io:println(recordVariableV2[3].deptAccess); // @output Operations
    io:println(recordVariableV2[4].firstName); // @output John
    io:println(recordVariableV2[4].lastName); // @output David
    io:println(recordVariableV2[4].deptAccess); // @output HR
    io:println(recordVariableV2[5].firstName); // @output John
    io:println(recordVariableV2[5].lastName); // @output David
    io:println(recordVariableV2[5].deptAccess); // @output Operations
}
