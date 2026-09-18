const map<int> im11 = {"im11k": 10};
map<int>[] ia1 = [im11];

function updateConstantIntMapValueInArrayWithExistingKey() {
    ia1[0]["im11k"] = 20; // @panic
}

public function main() {
    updateConstantIntMapValueInArrayWithExistingKey();
}
