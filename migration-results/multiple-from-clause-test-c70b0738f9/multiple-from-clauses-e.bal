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
    return from var {firstName: nm1, lastName: nm2, deptAccess: d} // @error unused variable 'd'
        in personList
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
    return from var {firstName, lastName, deptAccess} // @error unused variable 'deptAccess'
        in personList
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
    return from var {firstName, lastName, deptAccess} // @error unused variable 'deptAccess'
        in personList.toStream()
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
    return from var {firstName, lastName, deptAccess} // @error unused variable 'deptAccess'
        in personList.toStream()
        from var {name} // @error unused variable 'name'
        in deptList
        let string companyName = "WSO2"
        select {firstName, lastName, deptAccess: companyName};
}

function testMultipleFromAndSelectClausesWithRecordVariable() returns Person1[] {
    Person1[] personList = [
        {firstName: "Alex", lastName: "George", deptAccess: "XYZ", address: {city: "NY", country: "America"}},
        {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ", address: {city: "NY", country: "America"}}
    ];
    Department[] deptList = [{name: "HR"}, {name: "Operations"}];
    Address[] addressList = [{city: "New York", country: "USA"}, {city: "Springfield", country: "USA"}];
    return from var {
        firstName: nm1,
        lastName: nm2,
        deptAccess: d, // @error unused variable 'd'
        address: {city: c1, // @error unused variable 'c1'
            country: c2} // @error unused variable 'c2'
    } in personList
        from var {name} in deptList
        from var addr in addressList
        select {firstName: nm1, lastName: nm2, deptAccess: name, address: addr};
}

function testQueryExprTupleTypedBinding1() returns boolean {
    [string, float][] arr1 = [["A", 2.0], ["B", 3.0], ["C", 4.0]];
    [string|int|float, [string|float, int]][] arr2 = [["Ballerina", [3.4, 234]], [34, ["APIM", 89]], [45.9, [78.2, 90]]];
    string[] outputStringList = from [string, float] [a, b] // @error unused variable 'b'
        in arr1
        from [string|int|float, [string|float, int]] [g1, [g2, // @error unused variable 'g2'
            g3]] // @error unused variable 'g3'
        in arr2
        where g1 == "Ballerina"
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
    return from Person1 {firstName: nm1, lastName: nm2, deptAccess: d, // @error unused variable 'd'
        address: a1} in personList
        from var dept in deptList
        select {firstName: nm1, lastName: nm2, deptAccess: dept.name, address: a1};
}
