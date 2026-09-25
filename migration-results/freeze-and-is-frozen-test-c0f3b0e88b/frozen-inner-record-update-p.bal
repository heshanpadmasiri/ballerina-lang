type Dept record {
    string code;
    string name;
};

type DeptEmployee record {|
    int id;
    string name;
    Dept dept;
|};

public function main() {
    Dept d1 = {code: "fe11", name: "finance"};
    DeptEmployee e1 = {name: "Em", id: 1000, dept: d1};
    DeptEmployee e2 = e1.cloneReadOnly();
    Dept d2 = e2.dept;
    d2.code = "fe12"; // @panic
}
