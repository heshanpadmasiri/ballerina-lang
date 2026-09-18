map<map<string>> sm10 = {"sm10k": sm11};
const map<string> sm11 = {"sm11k": "sm11v"};

function updateNestedConstantStringMapValueWithExistingKey() {
    sm10["sm10k"]["sm11k"] = "sm11nv"; // @panic
}

public function main() {
    updateNestedConstantStringMapValueWithExistingKey();
}
