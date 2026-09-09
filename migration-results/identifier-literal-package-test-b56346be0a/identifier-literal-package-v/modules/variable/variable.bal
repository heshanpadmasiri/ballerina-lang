public function 'getVariable\ Int() returns int {
    return 800;
}

public function 'getVariable\ String() returns string {
    return "value";
}

public function 'getVariable\ Float() returns float {
    return 99.34323;
}

public function 'getVariable\ Any() returns any {
    return 88343;
}

public type 'Person\ 1 record {|
    string 'first\ name;
    int 'current\ age;
|};

public function 'getPerson\ 1() returns 'Person\ 1 {
    return {'first\ name: "Harry", 'current\ age: 25};
}

public type 'Employee\ 1 record {|
    string 'first\ name;
    int 'current\ age;
|};

public function 'getEmployee\ 1() returns 'Employee\ 1 {
    return {'first\ name: "John", 'current\ age: 20};
}

public type Foo\$ record {|
    string name;
|};
