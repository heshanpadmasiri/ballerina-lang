public function main(string... args) {
    int x = 1;
    string s = "ten";
    int i = 10;
    int j = 20;
    string a = x == 1 ? s : i; // @error
    any b = x ? s : i; // @error
    any c = true ? s : i;
}

function test1(int value) {
    string s1 = value > 40 ? true : false ? "morethan40" : "lessthan20"; // @error
}

function test2() {
    int[] a = [];
    boolean trueVal = true;
    boolean falseVal = false;
    a.push(trueVal ? 1 : ""); // @error
    byte[] b = [];
    b.push(falseVal ? 0 : 256); // @error
}
