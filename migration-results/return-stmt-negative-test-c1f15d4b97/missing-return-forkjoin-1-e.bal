function testNullInForkJoin() returns [string, string] {
    string _ = "";
    fork {
        worker foo returns int {
            string _ = "";
        } // @error

        worker bar {
            string _ = "";
        }
    }
} // @error
