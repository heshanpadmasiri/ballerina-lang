import ballerina/io;

public function main() {
    io:println(invalidCastingError()); // @output error("{ballerina}TypeCastError",message="incompatible types: 'string' cannot be cast to 'float'")
}

function invalidCastingError() returns error|() {
    any abc = stringReturn();
    float val = check trap <float> abc;
    return ();
}

function stringReturn() returns any {
    string val = "a";
    return val;
}
