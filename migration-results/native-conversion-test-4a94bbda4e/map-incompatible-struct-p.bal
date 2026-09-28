type Person record {|
    string name = "";
    int age = 0;
    Person? parent = ();
    json info?;
    map<anydata>? address?;
    int[]? marks?;
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
    Person[]? children?;
|};

type Student record {|
    string name;
    int age;
    string school;
|};

type Employee record {|
    string name;
    int age;
    Person partner;
    json info;
    map<string> address;
    int[] marks;
|};

function trigger() {
    Student student = {name: "Supun", age: 25, school: "ABC College"};
    map<anydata> m = {name: "Child", age: 25, student: student,
        address: {city: "Colombo", country: "SriLanka"}, info: {status: "single"}, marks: [87, 94, 72]};
    var employee = m.cloneWithType(Employee); // @panic
    if (employee is Employee) {
        return;
    }
    panic employee;
}

public function main() {
    trigger();
}
