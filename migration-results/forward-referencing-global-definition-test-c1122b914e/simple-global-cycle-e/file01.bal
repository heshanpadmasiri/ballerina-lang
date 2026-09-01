public type Person record {
    string name = "";
    int age = 0;
};

public type Employee record {
    string name = "";
    int age = 0;
    int empNo = 0;
};

public function getEmployee2() returns Employee {
    return employee;
}

Employee employee = {
    name: person.name,
    age: person.age,
    empNo: 100
};

[Employee, Person] pp = [employee, person];

public function getEmployee() returns Employee {
    return employee;
}

public function main1() {
    var _ = getEmployee();
    var _ = getEmployee2();
}

int dep1 = dep2;
