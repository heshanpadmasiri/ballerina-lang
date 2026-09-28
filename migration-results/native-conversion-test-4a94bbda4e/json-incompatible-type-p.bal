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

function trigger() {
    json j = {name: "Child", age: "25", address: {city: "Colombo", country: "SriLanka"},
        info: {status: "single"}, marks: [87, 94, 72]};
    var p = j.cloneWithType(Person); // @panic
    if (p is Person) {
        return;
    }
    panic p;
}

public function main() {
    trigger();
}
