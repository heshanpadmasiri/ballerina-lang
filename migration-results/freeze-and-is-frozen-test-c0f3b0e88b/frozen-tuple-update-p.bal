type Employee record {|
    int id;
    string name;
|};

public function main() {
    Employee e1 = {name: "Em", id: 1000};
    [int, Employee] t1 = [1, e1];
    [int, Employee] t2 = t1.cloneReadOnly();
    Employee e2 = {name: "Zee", id: 1200};
    t2[1] = e2; // @panic
}
