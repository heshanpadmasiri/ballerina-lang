const map<int> im11 = {"im11k": 10};
map<int>[] ia1 = [im11];

function updateConstantIntMapValueInArrayWithNewKey() {
    ia1[0]["newKey"] = 20; // @panic
}

public function main() {
    updateConstantIntMapValueInArrayWithNewKey();
}
