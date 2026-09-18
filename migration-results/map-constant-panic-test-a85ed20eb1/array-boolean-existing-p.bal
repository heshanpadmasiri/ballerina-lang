const map<boolean> bm11 = {"bm11k": true};
map<boolean>[] ba1 = [bm11];

function updateConstantBooleanMapValueInArrayWithExistingKey() {
    ba1[0]["bm11k"] = false; // @panic
}

public function main() {
    updateConstantBooleanMapValueInArrayWithExistingKey();
}
