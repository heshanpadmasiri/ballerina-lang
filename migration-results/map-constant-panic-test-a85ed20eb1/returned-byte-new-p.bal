const map<byte> bytem11 = {"bytem11k": 4};

function getByteMap() returns map<byte> {
    return bytem11;
}

function updateReturnedConstantByteMap2WithNewKey() {
    map<byte> m = getByteMap();
    m["newKey"] = 8; // @panic
}

public function main() {
    updateReturnedConstantByteMap2WithNewKey();
}
