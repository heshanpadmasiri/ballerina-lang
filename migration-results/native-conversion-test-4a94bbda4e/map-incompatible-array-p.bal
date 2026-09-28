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
    string[] marks = ["87.0", "94.0", "72.0"];
    map<anydata> m = {name: "Child", age: 25, marks: marks};
    var p = m.cloneWithType(Person); // @panic
    if (p is Person) {
        return;
    }
    panic p;
}

public function main() {
    trigger();
}
