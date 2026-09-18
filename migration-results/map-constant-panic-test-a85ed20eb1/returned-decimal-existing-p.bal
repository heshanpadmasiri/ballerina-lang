const map<decimal> dm11 = {"dm11k": 125};

function getDecimalMap() returns map<decimal> {
    return dm11;
}

function updateReturnedConstantDecimalMapWithExistingKey() {
    map<decimal> m = getDecimalMap();
    m["dm10k"] = 200; // @panic
}

public function main() {
    updateReturnedConstantDecimalMapWithExistingKey();
}
