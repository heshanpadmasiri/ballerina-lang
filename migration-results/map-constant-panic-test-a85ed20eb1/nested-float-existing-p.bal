map<map<float>> fm10 = {"fm10k": fm11};
const map<float> fm11 = {"fm11k": 40.0};

function updateNestedConstantFloatMapValueWithExistingKey() {
    fm10["fm10k"]["fm11k"] = 15.0; // @panic
}

public function main() {
    updateNestedConstantFloatMapValueWithExistingKey();
}
