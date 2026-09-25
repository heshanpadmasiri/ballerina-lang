import ballerina/io;
import moduletest.test.math;

public function testModule(int x) returns int {
    int sumValue = math:sum(x, x + 2);
    return math:multiply(sumValue, x);
}

public function main() {
    io:println(testModule(2)); // @output 12
}
