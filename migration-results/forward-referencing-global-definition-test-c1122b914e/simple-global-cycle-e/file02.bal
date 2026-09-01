Person person = { // @error
    name: employee.name,
    age: 30
};

[Employee, Person] pp2 = [employee, person];

int dep2 = dep1; // @error

function() returns boolean lambdaFoo = function() returns boolean {
    return myBool;
};

boolean myBool = lambdaFoo(); // @error
