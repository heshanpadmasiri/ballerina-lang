map<map<decimal>> dm10 = {"dm10k": dm11};
const map<decimal> dm11 = {"dm11k": 125};

function updateNestedConstantDecimalMapValueWithNewKey() {
    dm10["dm10k"]["newKey"] = 200; // @panic
}

public function main() {
    updateNestedConstantDecimalMapValueWithNewKey();
}
