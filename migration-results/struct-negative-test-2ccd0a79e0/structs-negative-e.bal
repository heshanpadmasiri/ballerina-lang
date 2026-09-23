type Department record {|
    string dptName = "";
    boolean y = false;
|};

type Department record {| // @error
    string name = "";
    int[] a1 = [];
|};

type Department2 record {|
    string dptName = "";
    int id = 0;
    string id = ""; // @error
|};

function testUndeclaredStructInit () {
    Department123 dpt1 = {name:"HR"}; // @error
}

function testUndeclaredStructAccess () {
    string name;
    dpt1.name = "HR"; // @error
}

function testUndeclaredAttributeAccess () {
    string name;
    Department dpt = {};
    dpt.id = "HR"; // @error
}

function testUndeclaredAttributeinit () {
    string name;
    Department dpt = {dptName:"HR", "age":20}; // @error
}

function testInvalidTypeAttributeinit () {
    string name;
    Department dpt = {dptName:54}; // @error
}
