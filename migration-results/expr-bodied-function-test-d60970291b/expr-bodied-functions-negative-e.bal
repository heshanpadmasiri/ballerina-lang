// Block body with =>
function sum(int a, int b) returns int => { // @error
    return a + b; // @error
} // @error

// Extern body with =>
function add(int a, int b) returns int => external // @error

// Statement as the body
function sum(int a1, int b1) returns int => int x = 10; // @error
