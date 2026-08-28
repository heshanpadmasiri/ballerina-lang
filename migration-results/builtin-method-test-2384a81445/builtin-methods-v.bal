import ballerina/io;

public function main() {
    map<anydata> clone = testClone();
    io:println(clone["test"]); // @output sample

    map<any>|error cloneAny = testCloneAny();
    if cloneAny is map<any> {
        io:println(cloneAny["test"]); // @output sample
    } else {
        panic cloneAny;
    }
}

function testClone() returns map<anydata> {
    map<anydata> m = {"test": "sample"};
    return m.clone();
}

function testCloneAny() returns map<any>|error {
    map<anydata> m = {"test": "sample"};
    return m.clone();
}
