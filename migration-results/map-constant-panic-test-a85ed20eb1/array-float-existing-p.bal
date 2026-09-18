const map<float> fm11 = {"fm11k": 40.0};
map<float>[] fa1 = [fm11];

function updateConstantFloatMapValueInArrayWithExistingKey() {
    fa1[0]["fm11k"] = 15.0; // @panic
}

public function main() {
    updateConstantFloatMapValueInArrayWithExistingKey();
}
