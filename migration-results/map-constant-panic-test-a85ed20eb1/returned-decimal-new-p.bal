const map<decimal> dm11 = {"dm11k": 125};

function getDecimalMap() returns map<decimal> {
    return dm11;
}

function updateReturnedConstantDecimalMap2WithNewKey() {
    map<decimal> m = getDecimalMap();
    m["newKey"] = 200; // @panic
}

public function main() {
    updateReturnedConstantDecimalMap2WithNewKey();
}
