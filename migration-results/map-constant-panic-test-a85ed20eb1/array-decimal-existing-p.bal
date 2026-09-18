const map<decimal> dm11 = {"dm11k": 125};
map<decimal>[] da1 = [dm11];

function updateConstantDecimalMapValueInArrayWithExistingKey() {
    da1[0]["dm11k"] = 200; // @panic
}

public function main() {
    updateConstantDecimalMapValueInArrayWithExistingKey();
}
