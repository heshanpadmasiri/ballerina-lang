type Person record {|
    string firstName;
    string lastName;
    string deptAccess;
|};

type Department record {|
    string name;
|};

function testMultipleSelectClausesWithRecordVariable() returns Person[] {
    Person p1 = {firstName: "Alex", lastName: "George", deptAccess: "XYZ"};
    Person p2 = {firstName: "Ranjan", lastName: "Fonseka", deptAccess: "XYZ"};
    Person p3 = {firstName: "John", lastName: "David", deptAccess: "XYZ"};
    Department d1 = {name: "HR"};
    Department d2 = {name: "Operations"};
    Person[] personList = [p1, p2, p3];
    Department[] deptList = [d1, d2];
    var outputPersonList =
        from var {
            firstName: nm1, lastName: nm2, deptAccess: d // @error unused variable 'd'
        } in personList
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
        from var {
            firstName, lastName, deptAccess // @error unused variable 'deptAccess'
        } in personList
        from var {name} in deptList
        select {
            firstName: firstName,
            lastName: lastName,
            deptAccess: name
        };
    return outputPersonList;
}
