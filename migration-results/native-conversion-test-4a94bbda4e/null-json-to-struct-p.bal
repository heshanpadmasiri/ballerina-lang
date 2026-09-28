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
    json j = ();
    var p = j.cloneWithType(Person); // @panic
    if (p is Person) {
        return;
    }
    panic p;
}

public function main() {
    trigger();
}
