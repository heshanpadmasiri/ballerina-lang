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
    Employee1 e = {id: 5, name: "Anne"};
    table<Employee1> key(id) empTable2 = empTable.cloneReadOnly();
    empTable2.add(e); // @panic
}
