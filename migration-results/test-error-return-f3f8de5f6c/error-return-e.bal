public type InvalidNameError error<record { string companyName; }>;

function getQuote(string name) returns float|InvalidNameError {
    if name == "FOO" {
        return 10.5;
    } else if name == "BAR" {
        return 11.5;
    }
    return error InvalidNameError("invalid name", companyName = name);
}

function checkAndThrow() {
    float qVal; // @error unused variable 'qVal'
    var p = getQuote("BAZ");
    if p is float {
        qVal = p;
    } else {
        panic p;
    }
}
