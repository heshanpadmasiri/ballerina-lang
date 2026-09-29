import ballerina/io;

float glbVarFloatChange = 99.0;

function changeGlobalVar(int addVal) returns float {
    glbVarFloatChange = 77.0 + <float>addVal;
    return glbVarFloatChange;
}

function getGlobalFloatVar() returns float {
    _ = changeGlobalVar(3);
    return glbVarFloatChange;
}

public function main() {
    io:println(getGlobalFloatVar()); // @output 80.0
}
