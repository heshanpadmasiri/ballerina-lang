import ballerina/io;
import ballerina/lang.'decimal as decimals;

function testDecimalToOtherTypesConversion() returns [int, float, string, any, json] {
    decimal d = 23.456;
    int i = <int>d;
    float f = <float>d;
    string s = d.toString();
    any a = d;
    json j = d;

    return [i, f, s, a, j];
}

function testOtherTypesToDecimalConversion() returns [decimal, decimal, decimal]|error {
    int i = 12;
    decimal d1 = <decimal>i;

    float f = -12.34;
    decimal d2 = <decimal>f;

    string s = "23.456";
    decimal d3 = check decimals:fromString(s);

    return [d1, d2, d3];
}

public function main() returns error? {
    [int, float, string, any, json] decimalToOtherTypes = testDecimalToOtherTypesConversion();
    io:println(decimalToOtherTypes[0]); // @output 23
    io:println(decimalToOtherTypes[1]); // @output 23.456
    io:println(decimalToOtherTypes[2]); // @output 23.456
    io:println(decimalToOtherTypes[3]); // @output 23.456
    io:println(decimalToOtherTypes[4]); // @output 23.456

    [decimal, decimal, decimal] otherTypesToDecimal = check testOtherTypesToDecimalConversion();
    io:println(otherTypesToDecimal[0]); // @output 12.0
    io:println(otherTypesToDecimal[1]); // @output -12.34
    io:println(otherTypesToDecimal[2]); // @output 23.456
}
