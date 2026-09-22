import ballerina/lang.'int;
import ballerina/lang.'float;
import ballerina/lang.'int; // @error

public function foo() {
    int|error i3 = 'int:fromString("100");
}
