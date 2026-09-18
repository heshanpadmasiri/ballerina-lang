const map<string> sm11 = {"sm11k": "sm11v"};

function getStringMap() returns map<string> {
    return sm11;
}

function updateReturnedConstantStringMap2WithNewKey() {
    map<string> m = getStringMap();
    m["newKey"] = "newValue"; // @panic
}

public function main() {
    updateReturnedConstantStringMap2WithNewKey();
}
