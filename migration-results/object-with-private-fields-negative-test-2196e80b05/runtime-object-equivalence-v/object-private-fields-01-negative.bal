import ballerina/io;
import pkg.org_foo as foo;

public class userA {
    public int age = 0;
    public string name = "";
}

public class userB {
    public int age = 0;
    public string name = "";
    public string address = "";
    string zipcode = "";
}

public function testRuntimeObjEqNegative() returns string|error {
    foo:user u = foo:newUser();
    userA uA = u;
    any a = uA;
    userB uB = check trap <userB> a;
    return uB.zipcode;
}

public function main() {
    io:println(testRuntimeObjEqNegative()); // @output error("{ballerina}TypeCastError",message="incompatible types: 'pkg.org_foo:user' cannot be cast to 'pkg:userB'")
}
