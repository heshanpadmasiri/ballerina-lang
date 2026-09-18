function arrayLengthAccessNullArrayCase(int _x, int _y) returns int {
    int[] arr = [];
    int length;
    length = arr.length();
    return length;
}

function arrayLengthAccessNullMapCase(int x, int y) returns int {
    map<anydata> m = {};
    int length;
    length = m.length();
    return length;
}

public function main() {
    int _ = arrayLengthAccessNullArrayCase(100, 5);
    _ = arrayLengthAccessNullMapCase(100, 5);
}
