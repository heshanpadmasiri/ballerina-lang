type Person record {|
   string firstName;
   string lastName;
   int age;
|};

public function main() {
    string g;
    string h;
    int i;
    {firstName:g, lastName:h, _} = fooPerson(1, false); // @error // @error
}

function fooPerson(float a, boolean b) returns Person {
    return {firstName:"john", lastName:"williams", age:40};
}

type EmployeeOne record {
    int a;
    record {
        int b?;
    }[1] age;
};

type EmployeeTwo record {
    int age;
    map<string> name;
};

function testInvalidFieldBindingPattern(){
    EmployeeOne emp = {a: 4, age: [{b: 5}]};
    int empOneName;
    int empOneAge;
    {a: empOneName, age: [{b: empOneAge}]} = emp; // @error

    EmployeeTwo empTwo = {age: 4, name: {first:"Joe"}};
    int empAge;
    string empName;
    {age:empAge, name:{first:empName}} = empTwo; // @error
}
