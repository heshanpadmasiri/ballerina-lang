public function testFunctionPointerAssignmentWithRestParamsNegative() {
   function (string a, int[] b) returns string bar = foo; // @error
}

function foo(string c, int... d) returns string {
    return c;
}
