import ballerina/io;
import testorg/enumaccess.enumsdef;

function test() {
    string s = enumsdef:RED;
    assert(s, "RED");
    enumsdef:Color c = enumsdef:BLUE;
    assert(c, "BLUE");
    enumsdef:RED red = "RED";
    assert(red, "RED");
}

function assert(anydata actual, anydata expected) {
    if expected != actual { panic error("enum assertion failed"); }
}

public function main() {
    test();
}

function retainIoImportForHarnessResults() {
    io:println(());
}
