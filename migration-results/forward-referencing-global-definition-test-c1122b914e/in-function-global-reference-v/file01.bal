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
Person fromFuncA = fromFunc;
Person fromFunc = getPersonOuter();

Employee employee = {
    name: person.name,
    age: person.age,
    empNo: 100
};

public function forwardEmp(Employee emp) returns Employee {
    return emp;
}
Employee e = getEmployee();
Employee b = forwardEmp(e);

public function getEmployee() returns Employee {
    return employee;
}

public function getEmployeeEmployee() returns Employee {
    var f = basicClosure();
    int r = f(1);
    return getEmployee();
}

int globalA = 11;
int globalB = 12;
int shouldNotReOrder = 13;

function basicClosure() returns (function (int) returns int) {
    int a = 3;
    var foo = function (int b1) returns int {
        int c = 34;
        if (b1 == 3) {
            c = c + b1 + a;
        }
        return c + a;
    };
    return foo;
}

function getPersonInner() returns Person {
    return person;
}

function getPersonOuter() returns Person {
    return getPersonInner();
}

function getfromFuncA() returns Person {
    return fromFuncA;
}
