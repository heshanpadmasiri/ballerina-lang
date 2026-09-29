int glbVarInt = 800;
string glbVarString = "value";
float glbVarFloat = 99.34323;
any glbVarAny = 88343;
float glbVarFloatChange = 99.0;
float glbVarFloat1 = glbVarFloat;
json glbVarJson = {};
float glbVarFloatLater = 0.0;
byte glbByte = 234;
byte[] glbByteArray1 = [2, 3, 4, 67, 89];
byte[] glbByteArray2 = base64 `afcd34abcdef+dfginermkmf123w/bc234cd/1a4bdfaaFGTdaKMN8923as=`;
byte[] glbByteArray3 = base16 `afcd34abcdef123abc234bcd1a4bdfaaabadabcd892312df`;
int[] glbArray = [1, 2];
int[3] glbSealedArray = [0, 0, 0];
int[*] glbSealedArray2 = [1, 2, 3, 4];
int[2][3] glbSealed2DArray = [[0, 0, 0], [0, 0, 0]];
int[*][2] glbSealed2DArray2 = [[1, 2], [3, 4], [5, 6]];

public function getGlbVarInt() returns int {
    return glbVarInt;
}

public function getGlbVarString() returns string {
    return glbVarString;
}

public function getGlbVarFloat() returns float {
    return glbVarFloat;
}

public function getGlbVarAny() returns any {
    return glbVarAny;
}

public function getGlbVarFloatChange() returns float {
    return glbVarFloatChange;
}

public function setGlbVarFloatChange(float value) {
    glbVarFloatChange = value;
}

public function getGlbVarFloat1() returns float {
    return glbVarFloat1;
}

public function getGlbVarJson() returns json {
    return glbVarJson;
}

public function setGlbVarJson(json value) {
    glbVarJson = value;
}

public function getGlbVarFloatLater() returns float {
    return glbVarFloatLater;
}

public function setGlbVarFloatLater(float value) {
    glbVarFloatLater = value;
}

public function getGlbByte() returns byte {
    return glbByte;
}

public function getGlbByteArray1() returns byte[] {
    return glbByteArray1;
}

public function getGlbByteArray2() returns byte[] {
    return glbByteArray2;
}

public function getGlbByteArray3() returns byte[] {
    return glbByteArray3;
}

public function getGlbArray() returns int[] {
    return glbArray;
}

public function getGlbSealedArray() returns int[3] {
    return glbSealedArray;
}

public function getGlbSealedArray2() returns int[4] {
    return glbSealedArray2;
}

public function getGlbSealed2DArray() returns int[2][3] {
    return glbSealed2DArray;
}

public function getGlbSealed2DArray2() returns int[3][2] {
    return glbSealed2DArray2;
}

public function main() {
}
