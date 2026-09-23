type Department record {
    string dptName = "";
    boolean y = false;
};

type person record {
    string a = "";
};

function testInvalidFieldNameInit () {
    string name;
    Department dpt = {dptName[0]:54}; // @error // @error // @error // @error
}

function testVarRefAsKey() {
    person p = {(a): "HR"}; // @error // @error // @error // @error // @error
}

function testFuncCallAsKey() {
    person p = {foo(): "HR"}; // @error // @error // @error
}

function foo() returns (string) {
    return "dptName";
}
