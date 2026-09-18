const map<boolean> bm11 = {"bm11k": true};
map<boolean>[] ba1 = [bm11];

function updateConstantBooleanMapValueInArrayWithNewKey() {
    ba1[0]["newKey"] = false; // @panic
}

public function main() {
    updateConstantBooleanMapValueInArrayWithNewKey();
}
