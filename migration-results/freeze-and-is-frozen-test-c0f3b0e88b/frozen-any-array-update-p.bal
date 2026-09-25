type Employee record {|
    int id;
    string name;
|};

public function main() {
    Employee e1 = {name: "Em", id: 1000};
    int[] i = [1, 2];
    anydata[] i1 = [i, e1];
    anydata[] i2 = i1.cloneReadOnly();
    Employee e2 = check <Employee>i2[1];
    i2[1] = 100; // @panic
}
