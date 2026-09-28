type StringArray record {|
    string[] a;
|};

function trigger() {
    json j = ();
    var s = j.cloneWithType(StringArray); // @panic
    if (s is StringArray) {
        return;
    }
    panic s;
}

public function main() {
    trigger();
}
