type Employee1 record {
    readonly int id;
    string name;
};

public function main() {
    table<Employee1> key(id) empTable = table [
        {id: 1, name: "Mary"},
        {id: 2, name: "John"},
        {id: 3, name: "Jim"}
    ];
    table<Employee1> key(id) empTable2 = empTable.cloneReadOnly();
    _ = empTable2.remove(2); // @panic
}
