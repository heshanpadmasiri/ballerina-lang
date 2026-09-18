const map<float> fm11 = {"fm11k": 40.0};

function getFloatMap() returns map<float> {
    return fm11;
}

function updateReturnedConstantFloatMapWithExistingKey() {
    map<float> m = getFloatMap();
    m["fm11k"] = 15.0; // @panic
}

public function main() {
    updateReturnedConstantFloatMapWithExistingKey();
}
