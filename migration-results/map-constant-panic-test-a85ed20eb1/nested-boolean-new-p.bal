map<map<boolean>> bm10 = {"bm10k": bm11};
const map<boolean> bm11 = {"bm11k": true};

function updateNestedConstantBooleanMapValueWithNewKey() {
    bm10["bm10k"]["newKey"] = false; // @panic
}

public function main() {
    updateNestedConstantBooleanMapValueWithNewKey();
}
