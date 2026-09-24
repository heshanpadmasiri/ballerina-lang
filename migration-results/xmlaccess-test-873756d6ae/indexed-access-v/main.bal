import ballerina/io;

public function main() {
    testXMLAccessWithIndex();
    testXMLSequenceAccessWithIndex();
    [int, int, int, int] lengths = testLengthOfXMLSequence();
    io:println(lengths[0]); // @output 1
    io:println(lengths[1]); // @output 3
    io:println(lengths[2]); // @output 1
    io:println(lengths[3]); // @output 2
    testInvalidXMLUnionAccessWithNegativeIndex();
    error? negativeIndexResult = testInvalidXMLAccessWithNegativeIndex();
    testXmlAccessWithLargerIndex();
    testXmlIndexedAccessWithUnionType();
}
