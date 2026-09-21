type myType record { int i; } | 4 | object { int intField1; int intField2; };
type myType1 string | boolean | 1 | object { int intField1; int intField2; };

public function testAssigment() {
    testObj to = new;
    myType mt = to; // @error unused variable 'mt'
    myType1 _ = to;
}

class testObj {
    int intField1; // @error uninitialized field 'intField1'
    int intField2; // @error uninitialized field 'intField2'
    int intField = 10;
    string stringField = "";
    function objFunc() {}
}
