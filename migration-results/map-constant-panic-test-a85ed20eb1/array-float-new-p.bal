const map<float> fm11 = {"fm11k": 40.0};
map<float>[] fa1 = [fm11];

function updateConstantFloatMapValueInArrayWithNewKey() {
    fa1[0]["newKey"] = 15.0; // @panic
}

public function main() {
    updateConstantFloatMapValueInArrayWithNewKey();
}
