type A int & string; // @error
type II int & int;
type IF (function () returns int) & (function () returns 2|3|4.0f|-50d|"a"); // @error

int & int i = 0; // @error

function foo(A a, II b, int & int c) { // @error
}
