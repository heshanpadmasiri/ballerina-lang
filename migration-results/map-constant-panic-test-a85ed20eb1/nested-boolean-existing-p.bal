map<map<boolean>> bm10 = {"bm10k": bm11};
const map<boolean> bm11 = {"bm11k": true};

function updateNestedConstantBooleanMapValueWithExistingKey() {
    bm10["bm10k"]["bm11k"] = false; // @panic
}

public function main() {
    updateNestedConstantBooleanMapValueWithExistingKey();
}
