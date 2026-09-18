const map<()> nm11 = {"nm11k": ()};
map<()>[] na1 = [nm11];

function updateConstantNilMapValueInArrayWithExistingKey() {
    na1[0]["nm11k"] = (); // @panic
}

public function main() {
    updateConstantNilMapValueInArrayWithExistingKey();
}
