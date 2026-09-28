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

type PersonWithChildren record {|
    string name = "";
    int age = 0;
    Person? parent = ();
    json info?;
    map<anydata>? address?;
    int[]? marks?;
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
    Person[]? children;
|};

function trigger() {
    json j = {name: "Child", parent: (), age: 25, address: {city: "Colombo", country: "SriLanka"},
        info: {status: "single"}, a: "any value", marks: [87, 94, 72], score: 5.67};
    var p = j.cloneWithType(PersonWithChildren); // @panic
    if (p is PersonWithChildren) {
        return;
    }
    panic p;
}

public function main() {
    trigger();
}
