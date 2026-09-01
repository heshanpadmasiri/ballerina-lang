type Department record {|
    int id;
    string name;
|};

Department[] deptList = [
    {id: 1, name: "HR"},
    {id: 2, name: "Operations"},
    {id: 3, name: "Engineering"}
];

function getDeptName(int id) returns string {
    if (id == 1) {
        return "HR";
    }
    if (id == 2) {
        return "Operations";
    }
    return "Engineering";
}

string[] globalQuery4 = from var person in ["Alex", "Ranjan", "Idris", "Dermot"]
    let string hrDep = "HR"
    join var {id, name} in deptList // @error
    on hrDep equals getDeptName(id)
    let string deptName = "WSO2_".concat(hrDep)
    select person.concat(deptName);

public function main() {
}
