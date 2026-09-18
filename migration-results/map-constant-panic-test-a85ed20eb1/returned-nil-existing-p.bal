const map<()> nm11 = {"nm11k": ()};

function getNilMap() returns map<()> {
    return nm11;
}

function updateReturnedConstantNilMapWithExistingKey() {
    map<()> m = getNilMap();
    m["nm11k"] = (); // @panic
}

public function main() {
    updateReturnedConstantNilMapWithExistingKey();
}
