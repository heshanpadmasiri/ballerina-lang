map<map<byte>> bytem10 = {"bytem10k": bytem11};
const map<byte> bytem11 = {"bytem11k": 4};

function updateNestedConstantByteMapValueWithNewKey() {
    bytem10["bytem10k"]["newKey"] = 8; // @panic
}

public function main() {
    updateNestedConstantByteMapValueWithNewKey();
}
