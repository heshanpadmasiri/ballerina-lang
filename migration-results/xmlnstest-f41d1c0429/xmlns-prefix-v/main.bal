import ballerina/io;

public function main() {
    testXMLNSUsage();
    testXMLNSUsageInAnotherFile();
}

function printValue(anydata value) {
    io:println(value);
}
