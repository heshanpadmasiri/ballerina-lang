type Department record {
    string dptName = "";
    boolean y = false;
};

function testVarRefAsKey() {
    Department p = {(a): "HR"}; // @error // @error // @error // @error // @error
}

function testFuncCallAsKey() {
    Department	 p = {foo(): "HR"}; // @error // @error // @error
}

function foo() returns (string) {
    return "dptName";
}
