const map<string> sm11 = {"sm11k": "sm11v"};

function getStringMap() returns map<string> {
    return sm11;
}

function updateReturnedConstantStringMapWithExistingKey() {
    map<string> m = getStringMap();
    m["sm11k"] = "sm11kn"; // @panic
}

public function main() {
    updateReturnedConstantStringMapWithExistingKey();
}
