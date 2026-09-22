import ballerina/jballerina.java; // @error
import ballerina/jballerina.java as otherJAVA; // @error
import ballerina/jballerina.java as anotherJAVA;
import ballerina/lang.value; // @error
import ballerina/lang.array as _;

public function foo() {
    handle _ = anotherJAVA:fromString("Ballerina!!!");
}
