const map<()> nm11 = {"nm11k": ()};

function getNilMap() returns map<()> {
    return nm11;
}

function updateReturnedConstantNilMap2WithNewKey() {
    map<()> m = getNilMap();
    m["newKey"] = (); // @panic
}

public function main() {
    updateReturnedConstantNilMap2WithNewKey();
}
