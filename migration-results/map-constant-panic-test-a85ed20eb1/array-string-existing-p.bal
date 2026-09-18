const map<string> sm11 = {"sm11k": "sm11v"};
map<string>[] sa1 = [sm11];

function updateConstantStringMapValueInArrayWithExistingKey() {
    sa1[0]["sm11k"] = "sm11nv"; // @panic
}

public function main() {
    updateConstantStringMapValueInArrayWithExistingKey();
}
