const map<string> sm11 = {"sm11k": "sm11v"};
map<string>[] sa1 = [sm11];

function updateConstantStringMapValueInArrayWithNewKey() {
    sa1[0]["newKey"] = "newValue"; // @panic
}

public function main() {
    updateConstantStringMapValueInArrayWithNewKey();
}
