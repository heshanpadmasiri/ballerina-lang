public function main() {
    overflowByDivision();
}

function overflowByDivision() {
    int val = -1;
    int val1 = getPowerof(-2, 63);
    int k = val1 / val; // @panic
}

function getPowerof(int num, int power) returns int {
    int i = 0;
    int res = 1;
    while i < power {
        res = res * num;
        i += 1;
    }
    return res;
}
