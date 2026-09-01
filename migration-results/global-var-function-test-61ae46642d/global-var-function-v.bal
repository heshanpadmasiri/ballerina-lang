import ballerina/io;

int glbVarInt = 800;
string glbVarString = "value";
float glbVarFloat = 99.34323;
any glbVarAny = 88343;

float glbVarFloatChange = 99.0;
float glbVarFloat1 = glbVarFloat;
json glbVarJson = {};
float glbVarFloatLater = 0.0;

function getGlobalVars() returns [int, string, float, any] {
    return [glbVarInt, glbVarString, glbVarFloat, glbVarAny];
}

function accessGlobalVar() returns int|error {
    int value;
    value = check trap <int>glbVarAny;
    return glbVarInt + value;
}

function changeGlobalVar(int addVal) returns float {
    glbVarFloatChange = 77.0 + <float>addVal;
    float value = glbVarFloatChange;
    return value;
}

function getGlobalFloatVar() returns float {
    _ = changeGlobalVar(3);
    return glbVarFloatChange;
}

function getGlobalVarFloat1() returns float {
    return glbVarFloat1;
}

function initializeGlobalVarSeparately() returns [json, float] {
    glbVarJson = {"name": "James", "age": 30};
    glbVarFloatLater = 3432.3423;
    return [glbVarJson, glbVarFloatLater];
}

public function main() {
    [int, string, float, any] globalVars = getGlobalVars();
    io:println(globalVars[0]); // @output 800
    io:println(globalVars[1]); // @output value
    io:println(globalVars[2]); // @output 99.34323
    io:println(globalVars[3]); // @output 88343

    int accessValue = checkpanic accessGlobalVar();
    io:println(accessValue); // @output 89143

    io:println(changeGlobalVar(88)); // @output 165.0

    // The harness recompiles the source before this invocation. This function resets the value itself.
    io:println(getGlobalFloatVar()); // @output 80.0

    io:println(getGlobalVarFloat1()); // @output 99.34323

    [json, float] initializedGlobals = initializeGlobalVarSeparately();
    io:println(initializedGlobals[0]); // @output {"name":"James","age":30}
    io:println(initializedGlobals[1]); // @output 3432.3423
}
