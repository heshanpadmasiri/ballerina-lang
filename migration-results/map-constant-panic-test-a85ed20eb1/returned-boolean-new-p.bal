const map<boolean> bm11 = {"bm11k": true};

function getBooleanMap() returns map<boolean> {
    return bm11;
}

function updateReturnedConstantBooleanMap2WithNewKey() {
    map<boolean> m = getBooleanMap();
    m["newKey"] = false; // @panic
}

public function main() {
    updateReturnedConstantBooleanMap2WithNewKey();
}
