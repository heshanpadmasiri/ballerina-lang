type StringArray record {|
    string[] a;
|};

function trigger() {
    json j = {a: "im not an array"};
    var a = j.cloneWithType(StringArray); // @panic
    if (a is StringArray) {
        return;
    }
    panic a;
}

public function main() {
    trigger();
}
