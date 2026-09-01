import ballerina/io;

function testForkWithinIfCondition() returns int {
    boolean isForked = false;
    if isForked {
        fork {
            worker A {
                5 -> B;
                string value = <- B;
            }

            worker B {
                int value = <- A;
                "a" -> A;
            }
        }
        return 0;
    }
    return 1;
}

public function main() {
    io:println(testForkWithinIfCondition()); // @output 1
}
