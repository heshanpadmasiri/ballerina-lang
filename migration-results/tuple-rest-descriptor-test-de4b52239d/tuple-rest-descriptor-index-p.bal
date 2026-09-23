public function main() {
    string _ = testIndexBasedAccessNegative();
}

function testIndexBasedAccessNegative() returns string {
    [boolean, string...] t = [true, "a", "b", "c"];
    string tempStringC = t[4]; // @panic
    string s = "";
    foreach var i in t {
        s += i.toString();
    }
    return s;
}
