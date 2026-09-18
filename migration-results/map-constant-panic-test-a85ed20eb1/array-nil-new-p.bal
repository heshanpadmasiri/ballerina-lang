const map<()> nm11 = {"nm11k": ()};
map<()>[] na1 = [nm11];

function updateConstantNilMapValueInArrayWithNewKey() {
    na1[0]["newKey"] = (); // @panic
}

public function main() {
    updateConstantNilMapValueInArrayWithNewKey();
}
