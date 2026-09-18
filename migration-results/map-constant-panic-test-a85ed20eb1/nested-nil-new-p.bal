map<map<()>> nm10 = {"nm10k": nm11};
const map<()> nm11 = {"nm11k": ()};

function updateNestedConstantNilMapValueWithNewKey() {
    nm10["nm10k"]["newKey"] = (); // @panic
}

public function main() {
    updateNestedConstantNilMapValueWithNewKey();
}
