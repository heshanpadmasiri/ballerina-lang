function testNullWithMatch() returns string {
    json j = null;
    anydata ad = j; // @error WARNING unused variable 'ad'

    match j {
        0 => {
            return "0";
        }
        null => {
            return "null";
        }
    }

    return "";
}
