function testNullInForkJoin() returns [string, string]|error {
    string _ = "";
    fork {
        worker foo returns int {
            string _ = "";
        } // @error

        worker bar returns int {
            string _ = "";
        } // @error
    }
} // @error
