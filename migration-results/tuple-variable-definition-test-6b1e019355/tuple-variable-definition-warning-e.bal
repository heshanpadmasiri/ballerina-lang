type myErrorDetail record { int i; };

function testTupleVariableWithUnusedErrorRestBinding() returns [string, int, int, string] {
    [error<myErrorDetail>, [int, string]] [error(m, i = i, ...k), [p, n]] = [error("err", i = 1), [1, ""]]; // @error
    return [m, i, p, n];
}
