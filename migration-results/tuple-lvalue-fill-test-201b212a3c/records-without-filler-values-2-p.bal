type Person2 record {|
    string name;
|};

public function main() {
    [string, Person2[2]...] arr = [];
    arr[2][1] = {name: "Pubudu"}; // @panic
}
