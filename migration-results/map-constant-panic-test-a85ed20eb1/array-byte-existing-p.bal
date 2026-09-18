const map<byte> bytem11 = {"bytem11k": 4};
map<byte>[] bytea1 = [bytem11];

function updateConstantByteMapValueInArrayWithExistingKey() {
    bytea1[0]["bytem11k"] = 8; // @panic
}

public function main() {
    updateConstantByteMapValueInArrayWithExistingKey();
}
