map<map<string>> sm10 = {"sm10k": sm11};
const map<string> sm11 = {"sm11k": "sm11v"};

function updateNestedConstantStringMapValueWithNewKey() {
    sm10["sm10k"]["newKey"] = "newValue"; // @panic
}

public function main() {
    updateNestedConstantStringMapValueWithNewKey();
}
