import ballerina/io;
import globalvarpkg.variable;

float glbVarFloat = <float> variable:getGlbVarAnyInt();
any glbVarAny = getAnyGlobalVar();
int glbVarInt = variable:getIntValue();

public function main() {
    [int, string, float, any] globalVars = getGlobalVars();
    io:println(globalVars[0]); // @output 800
    io:println(globalVars[1]); // @output value
    io:println(globalVars[2]); // @output 99.34323
    io:println(globalVars[3]); // @output 88343

    io:println(changeGlobalVar(88)); // @output 165.0
    io:println(getAssignedGlobalVarFloat()); // @output 88343.0
    io:println(getGlobalVarInt()); // @output 8876
}

function getGlobalVars() returns [int, string, float, any] {
    return [variable:getGlbVarInt(), variable:getGlbVarString(), variable:getGlbVarFloat(),
        variable:getGlbVarAny()];
}

function changeGlobalVar(int addVal) returns float {
    variable:setGlbVarFloatChange(77.0 + <float> addVal);
    return variable:getGlbVarFloatChange();
}

function getGlobalFloatVar() returns float {
    _ = changeGlobalVar(3);
    return variable:getGlbVarFloatChange();
}

function getAssignedGlobalVarFloat() returns float {
    return glbVarFloat;
}

function getAnyGlobalVar() returns any {
    float val = 45545.0;
    return val;
}

function getGlobalVarInt() returns int {
    return glbVarInt;
}
