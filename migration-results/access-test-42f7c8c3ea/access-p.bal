type Alpha record {
    Beta?[] betas = [];
};

public type Beta record {|
    int i;
    string s?;
|};

function testFieldOptionalFieldAndMemberAccess3() {
    Alpha a = {betas: []};
    string? s1 = a.betas[0]?.s; // @panic
}

public function main() {
    testFieldOptionalFieldAndMemberAccess3();
}
