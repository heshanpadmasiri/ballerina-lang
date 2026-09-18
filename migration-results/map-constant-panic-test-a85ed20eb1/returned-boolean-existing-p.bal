const map<boolean> bm11 = {"bm11k": true};

function getBooleanMap() returns map<boolean> {
    return bm11;
}

function updateReturnedConstantBooleanMapWithExistingKey() {
    map<boolean> m = getBooleanMap();
    m["bm11k"] = false; // @panic
}

public function main() {
    updateReturnedConstantBooleanMapWithExistingKey();
}
