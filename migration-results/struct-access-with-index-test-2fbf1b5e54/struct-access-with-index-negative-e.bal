function testUndeclaredStructAccess() {
    string name = "";
    dpt1[name] = "HR"; // @error
}

function testUndeclaredAttributeAccess() {
    string name;
    Department dpt = {};
    dpt["id"] = "HR"; // @error
}

type Department record {|
    string dptName = "";
    int count = 0;
|};
