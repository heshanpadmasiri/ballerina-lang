type StringArray record {|
    string[] a;
|};

function trigger() {
    json j = {a: null};
    var a = j.cloneWithType(StringArray); // @panic
    if (a is StringArray) {
        return;
    }
    panic a;
}

public function main() {
    trigger();
}
