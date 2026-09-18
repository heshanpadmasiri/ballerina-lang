const map<int> im11 = {"im11k": 10};

function getIntMap() returns map<int> {
    return im11;
}

function updateReturnedConstantIntMap2WithNewKey() {
    map<int> m = getIntMap();
    m["newKey"] = 20; // @panic
}

public function main() {
    updateReturnedConstantIntMap2WithNewKey();
}
