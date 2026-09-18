const map<float> fm11 = {"fm11k": 40.0};

function getFloatMap() returns map<float> {
    return fm11;
}

function updateReturnedConstantFloatMap2WithNewKey() {
    map<float> m = getFloatMap();
    m["newKey"] = 15.0; // @panic
}

public function main() {
    updateReturnedConstantFloatMap2WithNewKey();
}
