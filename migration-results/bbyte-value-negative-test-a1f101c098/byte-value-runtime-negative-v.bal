import ballerina/io;

public function main() {
    io:println(invalidByteLiteral1()); // @output error("{ballerina}NumberConversionError",message="'int' value '-12' cannot be converted to 'byte'")
    io:println(invalidByteLiteral2()); // @output error("{ballerina}NumberConversionError",message="'int' value '-257' cannot be converted to 'byte'")
    io:println(invalidByteLiteral3()); // @output error("{ballerina}NumberConversionError",message="'int' value '12,345' cannot be converted to 'byte'")
}

function invalidByteLiteral1() returns error? {
    int a = -12;
    byte b = check trap <byte>a;
    return;
}

function invalidByteLiteral2() returns error? {
    int c = -257;
    byte d = check trap <byte>c;
    return;
}

function invalidByteLiteral3() returns error? {
    int e = 12345;
    byte f = check trap <byte>e;
    return;
}
