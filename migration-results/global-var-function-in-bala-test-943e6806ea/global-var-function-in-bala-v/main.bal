import ballerina/io;
import testorg/foo;

function getGlobalVars() returns [int, string, float, any] {
    return [foo:getGlbVarInt(), foo:getGlbVarString(), foo:getGlbVarFloat(), foo:getGlbVarAny()];
}

function accessGlobalVar() returns int {
    return foo:getGlbVarInt() + <int>foo:getGlbVarAny();
}

function changeGlobalVar(int addVal) returns float {
    foo:setGlbVarFloatChange(77.0 + <float>addVal);
    return foo:getGlbVarFloatChange();
}

function getGlobalVarFloat1() returns float {
    return foo:getGlbVarFloat1();
}

function initializeGlobalVarSeparately() returns [json, float] {
    foo:setGlbVarJson({"name": "James", "age": 30});
    foo:setGlbVarFloatLater(3432.3423);
    return [foo:getGlbVarJson(), foo:getGlbVarFloatLater()];
}

function getGlobalVarByte() returns byte {
    return foo:getGlbByte();
}

function getGlobalVarByteArray1() returns byte[] {
    return foo:getGlbByteArray1();
}

function getGlobalVarByteArray2() returns byte[] {
    return foo:getGlbByteArray2();
}

function getGlobalVarByteArray3() returns byte[] {
    return foo:getGlbByteArray3();
}

function getGlobalArrays() returns [int, int, int, int, int, int, int] {
    int[2][3] x = foo:getGlbSealed2DArray();
    int[3][] x1 = foo:getGlbSealed2DArray2();
    return [foo:getGlbArray().length(), foo:getGlbSealedArray().length(), foo:getGlbSealedArray2().length(), x.length(), x[0].length(),
        x1.length(), x1[0].length()];
}

public function main() {
    [int, string, float, any] globalVars = getGlobalVars();
    io:println(globalVars[0]); // @output 800
    io:println(globalVars[1]); // @output value
    io:println(globalVars[2]); // @output 99.34323
    io:println(globalVars[3]); // @output 88343

    io:println(accessGlobalVar()); // @output 89143
    io:println(changeGlobalVar(88)); // @output 165.0
    io:println(getGlobalVarFloat1()); // @output 99.34323

    [json, float] initialized = initializeGlobalVarSeparately();
    io:println(initialized[0]); // @output {"name":"James","age":30}
    io:println(initialized[1]); // @output 3432.3423

    io:println(getGlobalVarByte()); // @output 234

    byte[] bytes1 = getGlobalVarByteArray1();
    io:println(bytes1[0]); // @output 2
    io:println(bytes1[1]); // @output 3
    io:println(bytes1[2]); // @output 4
    io:println(bytes1[3]); // @output 67
    io:println(bytes1[4]); // @output 89

    byte[] bytes2 = getGlobalVarByteArray2();
    io:println(bytes2[0]); // @output 105
    io:println(bytes2[1]); // @output 247
    io:println(bytes2[2]); // @output 29
    io:println(bytes2[3]); // @output 223
    io:println(bytes2[4]); // @output 134
    io:println(bytes2[5]); // @output 155
    io:println(bytes2[6]); // @output 113
    io:println(bytes2[7]); // @output 215
    io:println(bytes2[8]); // @output 159
    io:println(bytes2[9]); // @output 249
    io:println(bytes2[10]); // @output 215
    io:println(bytes2[11]); // @output 224
    io:println(bytes2[12]); // @output 138
    io:println(bytes2[13]); // @output 119
    io:println(bytes2[14]); // @output 171
    io:println(bytes2[15]); // @output 154
    io:println(bytes2[16]); // @output 73
    io:println(bytes2[17]); // @output 159
    io:println(bytes2[18]); // @output 215
    io:println(bytes2[19]); // @output 109
    io:println(bytes2[20]); // @output 240
    io:println(bytes2[21]); // @output 253
    io:println(bytes2[22]); // @output 183
    io:println(bytes2[23]); // @output 54
    io:println(bytes2[24]); // @output 223
    io:println(bytes2[25]); // @output 135
    io:println(bytes2[26]); // @output 29
    io:println(bytes2[27]); // @output 255
    io:println(bytes2[28]); // @output 86
    io:println(bytes2[29]); // @output 184
    io:println(bytes2[30]); // @output 109
    io:println(bytes2[31]); // @output 215
    io:println(bytes2[32]); // @output 218
    io:println(bytes2[33]); // @output 104
    io:println(bytes2[34]); // @output 81
    io:println(bytes2[35]); // @output 147
    io:println(bytes2[36]); // @output 117
    io:println(bytes2[37]); // @output 162
    io:println(bytes2[38]); // @output 140
    io:println(bytes2[39]); // @output 55
    io:println(bytes2[40]); // @output 207
    io:println(bytes2[41]); // @output 118
    io:println(bytes2[42]); // @output 221
    io:println(bytes2[43]); // @output 171

    byte[] bytes3 = getGlobalVarByteArray3();
    io:println(bytes3[0]); // @output 175
    io:println(bytes3[1]); // @output 205
    io:println(bytes3[2]); // @output 52
    io:println(bytes3[3]); // @output 171
    io:println(bytes3[4]); // @output 205
    io:println(bytes3[5]); // @output 239
    io:println(bytes3[6]); // @output 18
    io:println(bytes3[7]); // @output 58
    io:println(bytes3[8]); // @output 188
    io:println(bytes3[9]); // @output 35
    io:println(bytes3[10]); // @output 75
    io:println(bytes3[11]); // @output 205
    io:println(bytes3[12]); // @output 26
    io:println(bytes3[13]); // @output 75
    io:println(bytes3[14]); // @output 223
    io:println(bytes3[15]); // @output 170
    io:println(bytes3[16]); // @output 171
    io:println(bytes3[17]); // @output 173
    io:println(bytes3[18]); // @output 171
    io:println(bytes3[19]); // @output 205
    io:println(bytes3[20]); // @output 137
    io:println(bytes3[21]); // @output 35
    io:println(bytes3[22]); // @output 18
    io:println(bytes3[23]); // @output 223

    [int, int, int, int, int, int, int] lengths = getGlobalArrays();
    io:println(lengths[0]); // @output 2
    io:println(lengths[1]); // @output 3
    io:println(lengths[2]); // @output 4
    io:println(lengths[3]); // @output 2
    io:println(lengths[4]); // @output 3
    io:println(lengths[5]); // @output 3
    io:println(lengths[6]); // @output 2
}
