function testNonErrorTypeWithOnFail() returns string {
    string str = "";
    do {
        str += "Before failure throw";
        fail str; // @error
    }
    on fail string e { // @error
        str += "-> Error caught ! ";
    }
    str += "-> Execution continues...";
    return str;
}

public function checkOnFailScope() returns int {
    int a = 10;
    int b = 11;
    int c = 0;
    do {
        int d = 100;
        c = a + b;
        fail error("custom error", message = "error value");
    } on fail error e {
        c += d; // @error
    }
    return c;
}
