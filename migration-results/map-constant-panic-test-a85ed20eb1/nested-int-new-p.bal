map<map<int>> im10 = {"im10k": im11};
const map<int> im11 = {"im11k": 10};

function updateNestedConstantIntMapValueWithNewKey() {
    im10["im10k"]["newKey"] = 20; // @panic
}

public function main() {
    updateNestedConstantIntMapValueWithNewKey();
}
