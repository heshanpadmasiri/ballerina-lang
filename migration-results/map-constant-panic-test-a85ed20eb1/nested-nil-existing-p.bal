map<map<()>> nm10 = {"nm10k": nm11};
const map<()> nm11 = {"nm11k": ()};

function updateNestedConstantNilMapValueWithExistingKey() {
    nm10["nm10k"]["nm11k"] = (); // @panic
}

public function main() {
    updateNestedConstantNilMapValueWithExistingKey();
}
