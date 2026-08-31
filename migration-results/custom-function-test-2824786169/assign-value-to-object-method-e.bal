public object {
    public function getVal() returns int;
} myObj = object {
    public function getVal() returns int {
        return 30;
    }
};

public class A {
    public function getVal() returns int => 3;
}

function testAssignValueToObjectMethodNegative() {
    myObj.getVal = function() returns int => 10; // @error

    A a = new A();
    a.getVal = function() returns int {return 2;}; // @error
}
