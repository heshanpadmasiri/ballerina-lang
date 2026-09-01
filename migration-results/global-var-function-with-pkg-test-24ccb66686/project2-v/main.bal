import ballerina/io;
import globalvarpkg.mod.cde;
import globalvarpkg.mod.efg;

public function main() {
    io:println(getStringInPkg()); // @output sample value
}

function getStringInPkg() returns string {
    _ = cde:getSample();
    return efg:getStringVal();
}
