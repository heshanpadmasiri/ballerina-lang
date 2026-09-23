function testNestedBlocks() returns string {
    if (true) {
        int|string a = 10;
        if (a is string) {
            string s = "nested if"; // @error unused variable 's'
        } else {
            string s = "nested else"; // @error unused variable 's'
        }
        string s = "var after nested if-else";
        return s;
    }
}
