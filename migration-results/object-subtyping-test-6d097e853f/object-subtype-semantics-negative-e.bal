type myType record { int i; } | 4 | object { int intField1; int intField2; };
type myType1 string | boolean | 1 | object { int intField1; int intField2; };

public function testAssigment() {
    testObj to = new;
    myType mt = to; // @error incompatible types: expected 'myType', found 'testObj'
    myType1 mt1 = to; // @error incompatible types: expected 'myType1', found 'testObj'
}

class testObj {
    int intField = 10;
    string stringField = "";
    function objFunc() {}
}
