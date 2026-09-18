const map<int> im11 = {"im11k": 10};

function getIntMap() returns map<int> {
    return im11;
}

function updateReturnedConstantIntMapWithExistingKey() {
    map<int> m = getIntMap();
    m["im11k"] = 20; // @panic
}

public function main() {
    updateReturnedConstantIntMapWithExistingKey();
}
