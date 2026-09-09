type Teacher record {|
    int index;
    int age;
|};

public function main() {
    Teacher teacher = {index: 1001, age: 25};
    map<anydata> m = teacher;
    m["name"] = "Name"; // @panic
}
