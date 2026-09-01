import ballerina/io;
import globalvarpkg.variable;

public function main() {
    io:println(getGlobalFloatVar()); // @output 80.0
}

function changeGlobalVar(int addVal) returns float {
    variable:setGlbVarFloatChange(77.0 + <float> addVal);
    return variable:getGlbVarFloatChange();
}

function getGlobalFloatVar() returns float {
    _ = changeGlobalVar(3);
    return variable:getGlbVarFloatChange();
}
