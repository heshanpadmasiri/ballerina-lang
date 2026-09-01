configurable int discountRate = 5;

function foo2() {
    discountRate = 9; // @error
}
