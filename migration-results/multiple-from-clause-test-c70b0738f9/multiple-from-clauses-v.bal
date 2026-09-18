import ballerina/io;

type Person record {|
    string firstName;
    string lastName;
    string deptAccess;
|};

type Department record {|
    string name;
|};

type Person1 record {|
    string firstName;
    string lastName;
    string deptAccess;
    Address address;
|};

type Address record {|
    string city;
    string country;
|};

type Section record {
    string name;
    Grades grades;
};

type Grades record {|
    int physics;
    int chemistry;
    int...;
|};

function testMultipleSelectClausesWithSimpleVariable() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from var person in personList
        from var dept in deptList
        select {firstName: person.firstName, lastName: person.lastName, deptAccess: dept.name};
}

function testMultipleSelectClausesWithRecordVariable() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from var {firstName: nm1, lastName: nm2, deptAccess: _} in personList
        from var {name: deptName} in deptList
        select {firstName: nm1, lastName: nm2, deptAccess: deptName};
}

function testMultipleSelectClausesWithRecordVariableV2() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from var {firstName, lastName, deptAccess: _} in personList
        from var {name} in deptList
        select {firstName, lastName, deptAccess: name};
}

function testMultipleFromClausesWithStream() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from var {firstName, lastName, deptAccess: _} in personList.toStream()
        from var {name} in deptList
        select {firstName, lastName, deptAccess: name};
}

function testMultipleFromWithLetClauses() returns Person[] {
    Person[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ"},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"},
        {firstName: "John", lastName: "David", deptAccess: "XYZ"}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from var {firstName, lastName, deptAccess: _} in personList.toStream()
        from var {name} in deptList
        let string companyName = name == "" ? "WSO2" : "WSO2"
        select {firstName, lastName, deptAccess: companyName};
}

function testMultipleFromAndSelectClausesWithRecordVariable() returns Person1[] {
    Person1[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ", address: {city: "NY", country: "America"}},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ", address: {city: "NY", country: "America"}}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    Address[] addressList = [{city: "New York", country: "USA"}, {city: "Springfield", country: "USA"}];
    return from var {firstName: nm1, lastName: nm2, deptAccess: _, address: _} in personList
        from var {name} in deptList
        from var addr in addressList
        select {firstName: nm1, lastName: nm2, deptAccess: name, address: addr};
}

function testQueryExprTupleTypedBinding1() returns boolean {
    [string, float][] arr1 = [["A", 2.0], ["B", 3.0], ["C", 4.0]];
    [string|int|float, [string|float, int]][] arr2 = [["Ballerina", [3.4, 234]], [34, ["APIM", 89]], [45.9, [78.2, 90]]];
    string[] outputStringList = from [string, float] [a, b] in arr1
        from [string|int|float, [string|float, int]] [g1, [g2, g3]] in arr2
        where g1 == "Ballerina" && b >= 0.0 && g2 is string|float && g3 is int
        select a;
    return outputStringList == ["A", "B", "C"];
}

function testQueryExprWithOpenRecords() returns Section[] {
    Section[] sectionList = [
        {name: "Maths", grades: {physics: 80, chemistry: 90}},
        {name: "Bio", grades: {physics: 70, chemistry: 60}}
    ];
    Grades[] gradesList = [{physics: 30, chemistry: 50, "maths": 60}, {physics: 50, chemistry: 60, "bio": 70}];
    return from var section in sectionList
        from var grades in gradesList
        let int noOfStudents = 100
        select {name: section.name, grades, "noOfStudents": noOfStudents};
}

function testQueryExprRecordTypedBinding() returns Person1[] {
    Person1[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ", address: {city: "NY", country: "America"}},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ", address: {city: "NY", country: "America"}}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    return from Person1 {firstName: nm1, lastName: nm2, deptAccess: _, address: a1} in personList
        from var dept in deptList
        select {firstName: nm1, lastName: nm2, deptAccess: dept.name, address: a1};
}

public function main() {
    Person[] simplePeople = testMultipleSelectClausesWithSimpleVariable();
    io:println(simplePeople.length()); // @output 6
    io:println(simplePeople[0].firstName); // @output Alex
    io:println(simplePeople[0].lastName); // @output George
    io:println(simplePeople[0].deptAccess); // @output HR
    io:println(simplePeople[1].firstName); // @output Alex
    io:println(simplePeople[1].lastName); // @output George
    io:println(simplePeople[1].deptAccess); // @output Operations
    io:println(simplePeople[2].firstName); // @output Ranjan
    io:println(simplePeople[2].lastName); // @output Fonseka
    io:println(simplePeople[2].deptAccess); // @output HR
    io:println(simplePeople[3].firstName); // @output Ranjan
    io:println(simplePeople[3].lastName); // @output Fonseka
    io:println(simplePeople[3].deptAccess); // @output Operations
    io:println(simplePeople[4].firstName); // @output John
    io:println(simplePeople[4].lastName); // @output David
    io:println(simplePeople[4].deptAccess); // @output HR
    io:println(simplePeople[5].firstName); // @output John
    io:println(simplePeople[5].lastName); // @output David
    io:println(simplePeople[5].deptAccess); // @output Operations

    Person[] recordPeople = testMultipleSelectClausesWithRecordVariable();
    io:println(recordPeople.length()); // @output 6
    io:println(recordPeople[0].firstName); // @output Alex
    io:println(recordPeople[0].lastName); // @output George
    io:println(recordPeople[0].deptAccess); // @output HR
    io:println(recordPeople[1].firstName); // @output Alex
    io:println(recordPeople[1].lastName); // @output George
    io:println(recordPeople[1].deptAccess); // @output Operations
    io:println(recordPeople[2].firstName); // @output Ranjan
    io:println(recordPeople[2].lastName); // @output Fonseka
    io:println(recordPeople[2].deptAccess); // @output HR
    io:println(recordPeople[3].firstName); // @output Ranjan
    io:println(recordPeople[3].lastName); // @output Fonseka
    io:println(recordPeople[3].deptAccess); // @output Operations
    io:println(recordPeople[4].firstName); // @output John
    io:println(recordPeople[4].lastName); // @output David
    io:println(recordPeople[4].deptAccess); // @output HR
    io:println(recordPeople[5].firstName); // @output John
    io:println(recordPeople[5].lastName); // @output David
    io:println(recordPeople[5].deptAccess); // @output Operations

    Person[] recordPeopleV2 = testMultipleSelectClausesWithRecordVariableV2();
    io:println(recordPeopleV2.length()); // @output 6
    io:println(recordPeopleV2[0].firstName); // @output Alex
    io:println(recordPeopleV2[0].lastName); // @output George
    io:println(recordPeopleV2[0].deptAccess); // @output HR
    io:println(recordPeopleV2[1].firstName); // @output Alex
    io:println(recordPeopleV2[1].lastName); // @output George
    io:println(recordPeopleV2[1].deptAccess); // @output Operations
    io:println(recordPeopleV2[2].firstName); // @output Ranjan
    io:println(recordPeopleV2[2].lastName); // @output Fonseka
    io:println(recordPeopleV2[2].deptAccess); // @output HR
    io:println(recordPeopleV2[3].firstName); // @output Ranjan
    io:println(recordPeopleV2[3].lastName); // @output Fonseka
    io:println(recordPeopleV2[3].deptAccess); // @output Operations
    io:println(recordPeopleV2[4].firstName); // @output John
    io:println(recordPeopleV2[4].lastName); // @output David
    io:println(recordPeopleV2[4].deptAccess); // @output HR
    io:println(recordPeopleV2[5].firstName); // @output John
    io:println(recordPeopleV2[5].lastName); // @output David
    io:println(recordPeopleV2[5].deptAccess); // @output Operations

    Person[] streamPeople = testMultipleFromClausesWithStream();
    io:println(streamPeople.length()); // @output 6
    io:println(streamPeople[0].firstName); // @output Alex
    io:println(streamPeople[0].lastName); // @output George
    io:println(streamPeople[0].deptAccess); // @output HR
    io:println(streamPeople[1].firstName); // @output Alex
    io:println(streamPeople[1].lastName); // @output George
    io:println(streamPeople[1].deptAccess); // @output Operations
    io:println(streamPeople[2].firstName); // @output Ranjan
    io:println(streamPeople[2].lastName); // @output Fonseka
    io:println(streamPeople[2].deptAccess); // @output HR
    io:println(streamPeople[3].firstName); // @output Ranjan
    io:println(streamPeople[3].lastName); // @output Fonseka
    io:println(streamPeople[3].deptAccess); // @output Operations
    io:println(streamPeople[4].firstName); // @output John
    io:println(streamPeople[4].lastName); // @output David
    io:println(streamPeople[4].deptAccess); // @output HR
    io:println(streamPeople[5].firstName); // @output John
    io:println(streamPeople[5].lastName); // @output David
    io:println(streamPeople[5].deptAccess); // @output Operations

    Person[] letPeople = testMultipleFromWithLetClauses();
    io:println(letPeople.length()); // @output 6
    foreach Person person in letPeople {
        io:println(person.firstName); // @output Alex
        io:println(person.lastName); // @output George
        io:println(person.deptAccess); // @output WSO2
        io:println(letPeople[1].firstName); // @output Alex
        io:println(letPeople[1].lastName); // @output George
        io:println(letPeople[1].deptAccess); // @output WSO2
        io:println(letPeople[2].firstName); // @output Ranjan
        io:println(letPeople[2].lastName); // @output Fonseka
        io:println(letPeople[2].deptAccess); // @output WSO2
        io:println(letPeople[3].firstName); // @output Ranjan
        io:println(letPeople[3].lastName); // @output Fonseka
        io:println(letPeople[3].deptAccess); // @output WSO2
        io:println(letPeople[4].firstName); // @output John
        io:println(letPeople[4].lastName); // @output David
        io:println(letPeople[4].deptAccess); // @output WSO2
        io:println(letPeople[5].firstName); // @output John
        io:println(letPeople[5].lastName); // @output David
        io:println(letPeople[5].deptAccess); // @output WSO2
        break;
    }

    Person1[] peopleWithAddresses = testMultipleFromAndSelectClausesWithRecordVariable();
    io:println(peopleWithAddresses.length()); // @output 8
    foreach Person1 person in peopleWithAddresses {
        io:println(person.firstName); // @output Alex
        io:println(person.lastName); // @output George
        io:println(person.deptAccess); // @output HR
        io:println(person.address.city); // @output New York
        io:println(person.address.country); // @output USA
        io:println(peopleWithAddresses[1].firstName); // @output Alex
        io:println(peopleWithAddresses[1].lastName); // @output George
        io:println(peopleWithAddresses[1].deptAccess); // @output HR
        io:println(peopleWithAddresses[1].address.city); // @output Springfield
        io:println(peopleWithAddresses[1].address.country); // @output USA
        io:println(peopleWithAddresses[2].firstName); // @output Alex
        io:println(peopleWithAddresses[2].lastName); // @output George
        io:println(peopleWithAddresses[2].deptAccess); // @output Operations
        io:println(peopleWithAddresses[2].address.city); // @output New York
        io:println(peopleWithAddresses[2].address.country); // @output USA
        io:println(peopleWithAddresses[3].firstName); // @output Alex
        io:println(peopleWithAddresses[3].lastName); // @output George
        io:println(peopleWithAddresses[3].deptAccess); // @output Operations
        io:println(peopleWithAddresses[3].address.city); // @output Springfield
        io:println(peopleWithAddresses[3].address.country); // @output USA
        io:println(peopleWithAddresses[4].firstName); // @output Ranjan
        io:println(peopleWithAddresses[4].lastName); // @output Fonseka
        io:println(peopleWithAddresses[4].deptAccess); // @output HR
        io:println(peopleWithAddresses[4].address.city); // @output New York
        io:println(peopleWithAddresses[4].address.country); // @output USA
        io:println(peopleWithAddresses[5].firstName); // @output Ranjan
        io:println(peopleWithAddresses[5].lastName); // @output Fonseka
        io:println(peopleWithAddresses[5].deptAccess); // @output HR
        io:println(peopleWithAddresses[5].address.city); // @output Springfield
        io:println(peopleWithAddresses[5].address.country); // @output USA
        io:println(peopleWithAddresses[6].firstName); // @output Ranjan
        io:println(peopleWithAddresses[6].lastName); // @output Fonseka
        io:println(peopleWithAddresses[6].deptAccess); // @output Operations
        io:println(peopleWithAddresses[6].address.city); // @output New York
        io:println(peopleWithAddresses[6].address.country); // @output USA
        io:println(peopleWithAddresses[7].firstName); // @output Ranjan
        io:println(peopleWithAddresses[7].lastName); // @output Fonseka
        io:println(peopleWithAddresses[7].deptAccess); // @output Operations
        io:println(peopleWithAddresses[7].address.city); // @output Springfield
        io:println(peopleWithAddresses[7].address.country); // @output USA
        break;
    }

    io:println(testQueryExprTupleTypedBinding1()); // @output true

    Section[] sections = testQueryExprWithOpenRecords();
    io:println(sections.length()); // @output 4
    io:println(sections[0].grades is map<anydata>); // @output true
    io:println(sections[0].grades); // @output {"physics":30,"chemistry":50,"maths":60}
    io:println(sections[0]); // @output {"name":"Maths","grades":{"physics":30,"chemistry":50,"maths":60},"noOfStudents":100}
    io:println(sections[1].grades is map<anydata>); // @output true
    io:println(sections[1].grades); // @output {"physics":50,"chemistry":60,"bio":70}
    io:println(sections[1]); // @output {"name":"Maths","grades":{"physics":50,"chemistry":60,"bio":70},"noOfStudents":100}
    io:println(sections[2].grades is map<anydata>); // @output true
    io:println(sections[2].grades); // @output {"physics":30,"chemistry":50,"maths":60}
    io:println(sections[2]); // @output {"name":"Bio","grades":{"physics":30,"chemistry":50,"maths":60},"noOfStudents":100}
    io:println(sections[3].grades is map<anydata>); // @output true
    io:println(sections[3].grades); // @output {"physics":50,"chemistry":60,"bio":70}
    io:println(sections[3]); // @output {"name":"Bio","grades":{"physics":50,"chemistry":60,"bio":70},"noOfStudents":100}

    Person1[] recordBoundPeople = testQueryExprRecordTypedBinding();
    io:println(recordBoundPeople.length()); // @output 4
    io:println(recordBoundPeople[0].address is map<anydata>); // @output true
    io:println(recordBoundPeople[0]); // @output {"firstName":"Alex","lastName":"George","deptAccess":"HR","address":{"city":"NY","country":"America"}}
    io:println(recordBoundPeople[1]); // @output {"firstName":"Alex","lastName":"George","deptAccess":"Operations","address":{"city":"NY","country":"America"}}
    io:println(recordBoundPeople[2]); // @output {"firstName":"Ranjan","lastName":"Fonseka","deptAccess":"HR","address":{"city":"NY","country":"America"}}
    io:println(recordBoundPeople[3]); // @output {"firstName":"Ranjan","lastName":"Fonseka","deptAccess":"Operations","address":{"city":"NY","country":"America"}}
}
