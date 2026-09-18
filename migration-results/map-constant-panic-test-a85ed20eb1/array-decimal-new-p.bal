const map<decimal> dm11 = {"dm11k": 125};
map<decimal>[] da1 = [dm11];

function updateConstantDecimalMapValueInArrayWithNewKey() {
    da1[0]["newKey"] = 200; // @panic
}

public function main() {
    updateConstantDecimalMapValueInArrayWithNewKey();
}
