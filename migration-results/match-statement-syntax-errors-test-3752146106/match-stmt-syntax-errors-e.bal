// syntax errors
function func1() {
    string var1 = "";
    match var1 {
        v // @error // @error
    } // @error // @error
}
// @error
function func2() {
    string v = "";
    match v
} // @error
// @error
function func3() {
    string v = "";
    match
} // @error // @error // @error
// @error
function func4(any v) {
    match v {
        {a} => {} // @error // @error // @error
    }
}

function func5(any v) {
    match v {
        => { // @error // @error

        }
        if true => { // @error // @error

        }
    }
}
