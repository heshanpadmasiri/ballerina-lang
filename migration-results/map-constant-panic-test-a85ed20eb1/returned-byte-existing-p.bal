const map<byte> bytem11 = {"bytem11k": 4};

function getByteMap() returns map<byte> {
    return bytem11;
}

function updateReturnedConstantByteMapWithExistingKey() {
    map<byte> m = getByteMap();
    m["bytem11k"] = 8; // @panic
}

public function main() {
    updateReturnedConstantByteMapWithExistingKey();
}
