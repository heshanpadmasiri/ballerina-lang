const int A = 123;
const int B = A;
const int C = B - A - 1;

function f1() {
    1 x = 1;

    if x is A || x is B || x is C { // @error @error @error

    }
}
