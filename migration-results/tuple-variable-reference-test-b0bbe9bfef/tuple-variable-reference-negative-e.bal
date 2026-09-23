function testDuplicateBinding1() returns [int, int] {
    [int, int] x = [1, 2];
    int a;
    [a, a] = x; // @error
    return [a, a];
}
function testDuplicateBinding2() returns [int, int, int] {
    [int, [int, int]] x = [1, [2, 3]];
    int a;
    [a, [a, a]] = x; // @error
    return [a, a, a];
}
